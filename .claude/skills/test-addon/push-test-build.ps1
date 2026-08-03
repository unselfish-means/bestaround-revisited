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

# What ships: the .toc itself, every file it lists, and Assets/ (sound files
# referenced at runtime but never listed as a .toc load file).
$filesToCopy = @("BestAroundRevisited.toc") + $relativePaths

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

$assetsSrc = Join-Path $RepoRoot "Assets"
if (Test-Path $assetsSrc) {
    Copy-Item -Recurse -Force $assetsSrc (Join-Path $Dest "Assets")
    Write-Host "Copied Assets\ ($((Get-ChildItem -Recurse -File $assetsSrc).Count) file(s))"
}

Write-Host "Copied $($filesToCopy.Count) .toc-listed file(s)."
Write-Host "Done. /reload or relaunch WoW to pick up the test build."
