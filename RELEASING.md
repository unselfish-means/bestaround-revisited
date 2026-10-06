# Releasing

How a change goes from a merged PR to a GitHub release and a CurseForge file.

## CurseForge packaging

The [Package and release](.github/workflows/release.yml) workflow runs the
[BigWigs packager](https://github.com/BigWigsMods/packager) on every pushed tag
and uploads the result to CurseForge. It's the shared WIKR setup described in
the `curseforge-packaging` runbook in `wow-addons-skill`.

- **Every pushed tag** uploads as a **release** file. A tag containing `beta`
  or `alpha` uploads as that type instead. Pushes to `main` upload nothing.
- The project ID is `## X-Curse-Project-ID` in the `.toc`. The token is the
  `CURSEFORGE_API_TOKEN` repository **Actions** secret (a Codespaces secret
  doesn't reach workflows). If either is missing, the workflow fails.
- The game versions come from every value in `## Interface`. The packager maps
  each to its CurseForge game type, so one file covers Retail, MoP Classic,
  Classic Era, and WoW: Forever.
- [.pkgmeta](.pkgmeta) sets what ships: the same files as the release script's
  ship list below. A new top-level file that shouldn't ship must be added to
  its `ignore` list.
- The file and its CurseForge display name are `BestAroundRevisited-<tag>`,
  such as `BestAroundRevisited-1.8.2`. Its changelog is generated from the
  commit messages since the previous tag.
- To retry an upload, run the workflow by hand on the *Actions* tab with the
  existing tag. That works only for tags whose `.toc` has `X-Curse-Project-ID`
  (1.8.0 and earlier don't).

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

## Package and publish

Both steps are done by the `release-addon` skill's script,
[.claude/skills/release-addon/release.ps1](.claude/skills/release-addon/release.ps1)
(ask Claude to "cut a release", or run it yourself). It:

- reads `## Version` from the `.toc` at `origin/main` — the version is never
  typed in, so the tag can't drift from what the addon reports;
- refuses if that tag or release already exists (bump the version in a PR);
- packages from `git archive`, not the working tree, so local-only files
  can't leak in;
- zips the **ship list only** under a `BestAroundRevisited/` root and
  verifies it before publishing;
- tags the commit and pushes the tag with `git push`, which starts the
  CurseForge workflow — never pre-tag;
- creates the GitHub release on that tag with the zip attached.

```
BestAroundRevisited/
  BestAroundRevisited.toc
  Core.lua
  Options.lua
  README.md
  Libs/        (whole folder — the .toc lists only each lib's .xml entry point)
  Assets/      (whole folder — not .toc-listed, needed at runtime for sounds)
```

Nothing else ships: no `.claude/`, `CLAUDE.md`, `RELEASING.md`, `TODO.md`,
`LICENSE`, `embeds.xml`, `graphify-out/`, or `.git`. Do **not** upload GitHub's auto-generated source
zip — its root folder is `wow-wikr-bestaroundrevisited-<tag>/`, which the game
won't load.

Always dry-run first, then publish with a title and a notes **file** (a
file, not a string — multi-line strings passed to `gh` on PowerShell get
split into separate arguments):

```powershell
& .\.claude\skills\release-addon\release.ps1 -DryRun
```

```powershell
& .\.claude\skills\release-addon\release.ps1 `
  -Title "Short description of the release" `
  -NotesFile .\notes.md
```

Notes template:

```markdown
One-paragraph summary.

## Changes
- ...

## Supported clients
Retail 12.1, Classic Beta 1.60, Classic Era 1.15, MoP Classic 5.5

## Install
Download `BestAroundRevisited-<ver>.zip` and extract it into `Interface\AddOns\`.
```

The script prints the release URL. Verify with
`gh release view <ver> --json tagName,targetCommitish,assets`.

## After releasing

- Confirm the *Latest* badge on GitHub points at the new tag.
- Check the *Package and release* run for the tag passed:
  `gh run list --workflow release.yml`. If it failed, read the log
  (`gh run view <id> --log-failed`), fix the cause, and retry from the
  *Actions* tab with the tag.
- On the CurseForge *Files* tab, check `<ver>` is a **Release** with every
  client's game version. To show the player-facing notes, edit the file and
  replace the generated changelog with the GitHub release notes.
- If the release changes what players see, update [README.md](README.md) and
  paste it into the CurseForge project's description.
- Optionally delete the merged feature branch on GitHub.
- If a client build was missing from CurseForge's version picker, check back
  after a few days and edit the file's game versions once it appears.

## Recovering from a bad release

- **Wrong zip / wrong notes, tag is fine**: `gh release upload <ver> <zip> --clobber`
  or `gh release edit <ver> --notes-file ...`. On CurseForge, edit or archive
  the uploaded file.
- **Bad code**: don't move the tag. Fix forward with a patch bump and a new
  release.
