<#
.SYNOPSIS
    Packages a CurseForge-ready zip of the addon from a git ref and (unless
    -DryRun) publishes it as a GitHub release tagged with the .toc version.

.DESCRIPTION
    The version is never passed in -- it is read from `## Version` in the .toc
    at the given ref, so the tag can't drift from what the addon reports.
    Packaging works from `git archive`, not the working tree, so untracked or
    local-only files can't leak into the zip. The zip's root folder is the
    addon folder (BestAroundRevisited/) containing only the ship list: the
    .toc, its top-level listed files, and the whole Libs\ and Assets\ folders.

.PARAMETER Title
    Release title. Short description of what changed, not the version.

.PARAMETER NotesFile
    Path to a Markdown file with the release notes. Required unless -DryRun.
    (A file, not a string: multi-line strings passed to gh on PowerShell get
    split into separate arguments.)

.PARAMETER Ref
    Git ref to release. Defaults to origin/main after a fetch.

.PARAMETER DryRun
    Build and verify the zip, print where it is, and stop before touching
    GitHub. Skips the tag-exists and notes checks.

.EXAMPLE
    .\release.ps1 -DryRun
    .\release.ps1 -Title "Classic Beta 1.60 support" -NotesFile .\notes.md
#>
[CmdletBinding()]
param(
    [string]$Title,
    [string]$NotesFile,
    [string]$Ref = "origin/main",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
$AddonName = "BestAroundRevisited"
$TocName = "$AddonName.toc"

if (-not $DryRun) {
    if (-not $Title) { throw "-Title is required (or use -DryRun)." }
    if (-not $NotesFile) { throw "-NotesFile is required (or use -DryRun)." }
    if (-not (Test-Path $NotesFile)) { throw "Notes file not found: $NotesFile" }
    $NotesFile = (Resolve-Path $NotesFile).Path
}

Push-Location $RepoRoot
try {
    # --- Resolve the ref -------------------------------------------------------
    if ($Ref.StartsWith("origin/")) {
        git fetch --quiet origin
        if ($LASTEXITCODE -ne 0) { throw "git fetch origin failed" }
    }
    $Sha = (git rev-parse --verify --quiet "$Ref^{commit}")
    if ($LASTEXITCODE -ne 0 -or -not $Sha) { throw "Ref not found: $Ref" }
    $Sha = $Sha.Trim()

    # --- Read the version from the .toc at that ref -----------------------------
    $tocText = git show "${Sha}:$TocName"
    if ($LASTEXITCODE -ne 0) { throw "$TocName not found at $Ref" }
    $versionLine = $tocText | Where-Object { $_ -match '^## Version:\s*(\S+)' } | Select-Object -First 1
    if (-not $versionLine) { throw "No '## Version:' line in $TocName at $Ref" }
    $Version = $Matches[1]
    Write-Host "Releasing $AddonName $Version from $Ref ($($Sha.Substring(0,7)))"

    # --- Refuse to reuse a tag ------------------------------------------------
    if (-not $DryRun) {
        git rev-parse --verify --quiet "refs/tags/$Version" *> $null
        if ($LASTEXITCODE -eq 0) { throw "Tag $Version already exists locally. Bump ## Version in the .toc first." }
        $remoteTag = git ls-remote --tags origin "refs/tags/$Version"
        if ($remoteTag) { throw "Tag $Version already exists on origin. Bump ## Version in the .toc first." }
        gh release view $Version *> $null
        if ($LASTEXITCODE -eq 0) { throw "GitHub release $Version already exists." }
    }

    # --- Stage a clean tree from git archive -----------------------------------
    $Work = Join-Path $env:TEMP "bar-release-$Version"
    if (Test-Path $Work) { Remove-Item -Recurse -Force -Confirm:$false $Work }
    $Src = Join-Path $Work "src"
    $Pkg = Join-Path $Work "pkg\$AddonName"
    New-Item -ItemType Directory -Path $Src, $Pkg | Out-Null

    $tarPath = Join-Path $Work "src.tar"
    git archive --format=tar --output=$tarPath $Sha
    if ($LASTEXITCODE -ne 0) { throw "git archive failed" }
    tar -xf $tarPath -C $Src
    if ($LASTEXITCODE -ne 0) { throw "tar extract failed" }

    # --- Copy the ship list (same rules as test-addon) --------------------------
    # .toc-listed top-level files, plus Libs\ and Assets\ as whole folders:
    # Libs\ entries in the .toc are only each library's .xml entry point, and
    # Assets\ isn't .toc-listed at all but is needed at runtime.
    $relativePaths = $tocText | ForEach-Object { $_.Trim() } | Where-Object {
        $_ -ne "" -and -not $_.StartsWith("#")
    }
    $topLevelPaths = $relativePaths | Where-Object { -not $_.StartsWith("Libs\") }
    $filesToCopy = @($TocName, "README.md") + $topLevelPaths

    foreach ($relPath in $filesToCopy) {
        $from = Join-Path $Src $relPath
        if (-not (Test-Path $from)) { throw "File listed in $TocName not found at ${Ref}: $relPath" }
        $to = Join-Path $Pkg $relPath
        New-Item -ItemType Directory -Force -Path (Split-Path $to) | Out-Null
        Copy-Item $from $to
    }
    foreach ($folder in "Libs", "Assets") {
        $from = Join-Path $Src $folder
        if (-not (Test-Path $from)) { throw "$folder\ not found at $Ref" }
        Copy-Item -Recurse $from (Join-Path $Pkg $folder)
    }

    # --- Zip and verify the root -----------------------------------------------
    $Zip = Join-Path $Work "$AddonName-$Version.zip"
    Compress-Archive -Path (Join-Path $Work "pkg\$AddonName") -DestinationPath $Zip -CompressionLevel Optimal -Force

    $archive = [IO.Compression.ZipFile]::OpenRead($Zip)
    try {
        $entries = $archive.Entries | ForEach-Object FullName
        $badRoot = $entries | Where-Object { -not $_.StartsWith("$AddonName/") }
        if ($badRoot) { throw "Zip has entries outside $AddonName/: $($badRoot -join ', ')" }
        if ("$AddonName/$TocName" -notin $entries) { throw "Zip is missing $AddonName/$TocName" }
        Write-Host "Packaged $Zip ($($entries.Count) files, $([math]::Round((Get-Item $Zip).Length / 1KB)) KB)"
        Write-Host "Top-level entries:"
        $entries | Where-Object { $_ -notmatch "/Libs/" } | ForEach-Object { Write-Host "  $_" }
    } finally {
        $archive.Dispose()
    }

    if ($DryRun) {
        Write-Host "Dry run -- no tag or release created."
        return
    }

    # --- Publish ---------------------------------------------------------------
    # gh creates the tag at --target; do not pre-tag.
    gh release create $Version $Zip --target $Sha --title $Title --notes-file $NotesFile --latest
    if ($LASTEXITCODE -ne 0) { throw "gh release create failed" }

    Write-Host ""
    Write-Host "Upload this file to CurseForge: $Zip"
} finally {
    Pop-Location
}
