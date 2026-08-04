<#
.SYNOPSIS
    Mirrors a clean copy of the addon (as defined by the .toc) into the local
    WoW retail AddOns folder, so in-game testing reflects what a fresh
    install/download would actually contain.
#>

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..")
$TocPath = Join-Path $RepoRoot "BestAroundRevisited.toc"
$AddonName = [System.IO.Path]::GetFileNameWithoutExtension($TocPath)
$AddonsRoot = "F:\Blizzard\World of Warcraft\_retail_\Interface\AddOns"
$Dest = Join-Path $AddonsRoot $AddonName

if (-not (Test-Path $TocPath)) {
    throw "Could not find $TocPath"
}
if (-not (Test-Path $AddonsRoot)) {
    throw "AddOns folder not found at $AddonsRoot -- is the retail client installed there?"
}

# Parse the .toc: skip blank lines and comments (# or ##), keep the rest as
# addon-relative file paths.
$relativePaths = Get-Content $TocPath | ForEach-Object { $_.Trim() } | Where-Object {
    $_ -ne "" -and -not $_.StartsWith("#")
}

# Libs\ entries in the .toc are only each library's .xml entry point -- that
# XML in turn <Script file="..."> a sibling .lua that is never itself listed
# in the .toc. Copying just the .toc-listed files leaves every library's
# actual .lua behind, so Libs\ ships as a whole directory instead, same as
# Assets\.
$topLevelPaths = $relativePaths | Where-Object { -not $_.StartsWith("Libs\") }
$filesToCopy = @("BestAroundRevisited.toc") + $topLevelPaths

Write-Host "Mirroring $AddonName -> $Dest"

if (Test-Path $Dest) {
    Remove-Item -Recurse -Force -Confirm:$false $Dest
}
New-Item -ItemType Directory -Path $Dest | Out-Null

foreach ($relPath in $filesToCopy) {
    $src = Join-Path $RepoRoot $relPath
    if (-not (Test-Path $src)) {
        throw "File listed in $($AddonName).toc not found on disk: $relPath"
    }
    $dstFile = Join-Path $Dest $relPath
    New-Item -ItemType Directory -Force -Path (Split-Path $dstFile) | Out-Null
    Copy-Item $src $dstFile -Force
}

$libsSrc = Join-Path $RepoRoot "Libs"
if (-not (Test-Path $libsSrc)) {
    throw "Libs\ not found on disk at $libsSrc"
}
Copy-Item -Recurse -Force $libsSrc (Join-Path $Dest "Libs")
Write-Host "Copied Libs\ ($((Get-ChildItem -Recurse -File $libsSrc).Count) file(s))"

$assetsSrc = Join-Path $RepoRoot "Assets"
if (Test-Path $assetsSrc) {
    Copy-Item -Recurse -Force $assetsSrc (Join-Path $Dest "Assets")
    Write-Host "Copied Assets\ ($((Get-ChildItem -Recurse -File $assetsSrc).Count) file(s))"
}

Write-Host "Copied $($filesToCopy.Count) .toc-listed file(s)."
Write-Host "Done. /reload or relaunch WoW to pick up the test build."
