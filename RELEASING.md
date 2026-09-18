# Releasing

How a change goes from a merged PR to a GitHub release and a CurseForge upload.
There is no CI or packager — every step is manual, which is fine at this size.

## Conventions

- **Tags** are the bare version, `1.6.0` (no `v` prefix). The tag must match
  `## Version` in `BestAroundRevisited.toc`.
- **Version bumps** happen in the PR that changes behavior, not at release time.
  Patch for fixes, minor for new client support / new features / library
  upgrades. Docs- and tooling-only changes don't bump.
- **Interface versions** (`## Interface` in the `.toc`) must list every client
  build the release is uploaded for. The client's build number is in
  `<WoW install>\_<flavor>_\.build.info` (`Version` column, e.g. `1.60.1` →
  `16001`, `12.1.0` → `120100`).
- **Release title** is a short description of what changed, not the version.
  Notes are user-facing: what changed and which clients are supported.

## Before you release

1. The PR is merged to `main` and `main` is fetched locally.
2. `## Version` in the `.toc` on `main` is the version you're about to tag.
3. The build has been exercised in-game on the clients you're claiming support
   for — at minimum `/bar` (options panel: hover, dropdown, toggle, Test) plus
   `/bar test level` and `/bar test death`. Use the `test-addon` skill
   (`.claude/skills/test-addon/push-test-build.ps1`) for the retail folder; for
   other flavors copy the ship list into that flavor's `Interface\AddOns\`.
4. If `Libs/` changed, check upstream's `Libs/Ace3.toc` `## Interface` line
   overlaps the clients you're targeting.

## Package the zip

CurseForge and manual installs need a zip whose root is the addon folder
(`BestAroundRevisited/`), containing **only the ship list**:

```
BestAroundRevisited/
  BestAroundRevisited.toc
  Core.lua
  Options.lua
  Libs/        (whole folder — the .toc lists only each lib's .xml entry point)
  Assets/      (whole folder — not .toc-listed, needed at runtime for sounds)
```

Nothing else: no `.claude/`, `README.md`, `RELEASING.md`, `embeds.xml`,
`graphify-out/`, or `.git`. Do **not** upload GitHub's auto-generated source
zip — its root folder is `wow-wikr-bestaroundrevisited-<tag>/`, which the game
won't load.

Build it from the merged commit, not from a working tree, so stray local files
can't leak in:

```powershell
$ver  = "1.6.0"
$work = Join-Path $env:TEMP "bar-release-$ver"
Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "$work\src", "$work\pkg\BestAroundRevisited" | Out-Null

git archive origin/main | tar -x -C "$work\src"
Copy-Item "$work\src\BestAroundRevisited.toc", "$work\src\Core.lua", "$work\src\Options.lua" "$work\pkg\BestAroundRevisited\"
Copy-Item "$work\src\Libs", "$work\src\Assets" "$work\pkg\BestAroundRevisited\" -Recurse

Compress-Archive -Path "$work\pkg\BestAroundRevisited" -DestinationPath "$work\BestAroundRevisited-$ver.zip" -Force
```

Sanity-check the archive root before uploading:

```powershell
[IO.Compression.ZipFile]::OpenRead("$work\BestAroundRevisited-$ver.zip").Entries |
  Where-Object FullName -notmatch '/Libs/' | Select-Object -ExpandProperty FullName
```

You should see `BestAroundRevisited/BestAroundRevisited.toc`, the two Lua
files, and the two `Assets/*.mp3` — nothing at the top level.

## Create the GitHub release

Write the notes to a file first; multi-line strings passed straight to `gh`
on PowerShell get split into arguments.

```powershell
$notes = @'
One-paragraph summary.

## Changes
- ...

## Supported clients
Retail 12.1, Classic Beta 1.60, Classic Era 1.15, MoP Classic 5.5

## Install
Download `BestAroundRevisited-<ver>.zip` and extract it into `Interface\AddOns\`.
'@
[IO.File]::WriteAllText("$work\notes.md", $notes)

gh release create $ver "$work\BestAroundRevisited-$ver.zip" `
  --target main `
  --title "Short description of the release" `
  --notes-file "$work\notes.md" `
  --latest
```

`gh release create` creates the tag on `main` for you; don't pre-tag. Verify:

```powershell
gh release view $ver --json tagName,targetCommitish,assets
```

## Upload to CurseForge

Manual, on the project page's *Upload File* form:

1. **File**: the `BestAroundRevisited-<ver>.zip` you just attached to the
   GitHub release — same bytes, so the two stay in sync.
2. **Display name**: `<ver>` (e.g. `1.6.0`).
3. **Release type**: Release (Beta only if the `.toc` targets a beta client you
   haven't been able to test properly).
4. **Game versions**: select every build listed in the `.toc`'s `## Interface`
   line. CurseForge groups them by flavor (Retail / Classic Era / MoP Classic /
   etc.); a brand-new client build may not be selectable yet — if so, upload
   without it and note it in the changelog rather than picking a wrong version.
5. **Changelog**: paste the GitHub release notes (Markdown is supported).

## After releasing

- Confirm the *Latest* badge on GitHub points at the new tag.
- Optionally delete the merged feature branch on GitHub.
- If a client build was missing from CurseForge's version picker, check back
  after a few days and edit the file's game versions once it appears.

## Recovering from a bad release

- **Wrong zip / wrong notes, tag is fine**: `gh release upload <ver> <zip> --clobber`
  or `gh release edit <ver> --notes-file ...`. Re-upload to CurseForge as a new
  file and archive the bad one there.
- **Bad code**: don't move the tag. Fix forward with a patch bump and a new
  release.
