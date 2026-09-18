---
name: release-addon
description: Cut a GitHub release of BestAroundRevisited from main — packages a CurseForge-ready zip and tags it with the .toc version. Use when the user asks to release, cut a release, publish a version, or make a CurseForge build.
---

# Release Addon

Publishes the addon at `origin/main` as a GitHub release via
[release.ps1](release.ps1). The release is tagged with the `## Version` from
the `.toc` (bare, no `v`) and carries a `BestAroundRevisited-<ver>.zip` whose
root folder is `BestAroundRevisited/` with only the ship list inside — the
file the user then uploads to CurseForge by hand. Full conventions live in
[RELEASING.md](../../../RELEASING.md); this skill is the executable half.

A release is outward-facing and not cleanly reversible (tags stay, CurseForge
sees it). **Always dry-run first and get an explicit yes before the real run.**

## Steps

1. **Preconditions.** The change is merged to `main` and the version was
   bumped *in that PR* — the script reads `## Version` from the `.toc` on
   `origin/main` and will refuse if that tag already exists. If it refuses,
   the fix is a version-bump PR, not a flag.

2. **Draft the notes.** Find what shipped since the last tag:

   ```powershell
   git fetch origin --tags
   $prev = git describe --tags --abbrev=0 origin/main~1
   git log --oneline "$prev..origin/main"
   gh pr list --state merged --base main --limit 20 --json number,title,mergedAt
   ```

   Write user-facing Markdown to a file in the scratchpad (a file, not an
   inline string — PowerShell splits multi-line args to `gh`). Shape:

   ```markdown
   One-paragraph summary.

   ## Changes
   - What changed, from the player's point of view. Skip tooling/docs.

   ## Supported clients
   Derived from the .toc's `## Interface` line, e.g.
   Retail 12.1, Classic Beta 1.60, Classic Era 1.15, MoP Classic 5.5

   ## Install
   Download `BestAroundRevisited-<ver>.zip` and extract it into `Interface\AddOns\`.
   ```

   Pick a short title describing the release, not the version number.

3. **Dry run.** Packages and verifies the zip without touching GitHub:

   ```powershell
   & "<repo-root>\.claude\skills\release-addon\release.ps1" -DryRun
   ```

   Show the user the version it resolved, the file count, and the top-level
   entries. Anything outside `BestAroundRevisited/`, or a missing `.toc`, is
   a real packaging bug — stop and fix it.

4. **Confirm.** Show the title and notes, then ask the user to confirm the
   release. Do not proceed on the original "release it" alone.

5. **Publish.**

   ```powershell
   & "<repo-root>\.claude\skills\release-addon\release.ps1" `
       -Title "Short description" `
       -NotesFile "<path>\notes.md"
   ```

   `gh release create` creates the tag on the target commit itself — never
   pre-tag.

6. **Report.** Give the user the release URL and the local zip path the
   script prints, and remind them the CurseForge upload is manual (game
   versions = every build in the `.toc`'s `## Interface` line; a brand-new
   client build may not be in CurseForge's picker yet).

## Flags

- `-Ref <ref>` — release something other than `origin/main` (e.g. a hotfix
  branch). Rare; say why in the release notes.
- `-DryRun` — package only. Skips the tag-exists and notes checks.

## Notes

- The version is deliberately **not** a parameter. If the `.toc` says
  `1.6.0`, the release is `1.6.0`. That's the invariant the tag guard
  protects.
- Ship-list rules match the `test-addon` skill: `.toc`-listed top-level
  files, plus `Libs\` and `Assets\` wholesale. If a new runtime dependency
  appears that isn't `.toc`-listed, update **both** scripts.
- Requires `gh` authenticated as an account with push access to the repo
  (`gh auth status`). A 403 from `gh` or git means the wrong account is
  active — see `gh auth switch`.
