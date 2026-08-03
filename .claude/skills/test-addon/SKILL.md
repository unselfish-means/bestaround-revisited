---
name: test-addon
description: Push a clean test build of BestAroundRevisited into the local WoW retail AddOns folder for in-game testing. Use when the user asks to test the addon, push a test build, or wants to try their changes in-game.
---

# Test Addon

Deploys a clean, deliberate test build of this addon into the local WoW
retail client so it can be tested in-game. This is a manual checkpoint, not
an auto-sync — run it when you're ready to test, not on every save.

## What it does

Runs [push-test-build.ps1](push-test-build.ps1), which:

1. Reads `BestAroundRevisited.toc` and extracts the list of files it
   declares (skipping comments/directives).
2. **Wipes** `F:\Blizzard\World of Warcraft\_retail_\Interface\AddOns\BestAroundRevisited\`
   before copying anything, so stale files from a previous test build can
   never linger and mask a packaging bug. This matters because the goal is
   to mirror what a fresh install/download would actually contain, not just
   sync a dev folder.
3. Copies the `.toc` file itself, every file the `.toc` lists (`Core.lua`,
   `Options.lua`, `Libs\...`), and the entire `Assets\` folder — `Assets\`
   isn't listed in the `.toc` (it's not Lua/XML to load) but is required at
   runtime for sound playback, so it's always included.
4. Prints a summary of what was copied.

## When to use

Invoke via `/test-addon`, or when the user asks to test the addon, push a
build, or verify changes work in-game.

## Running it

Use the PowerShell tool to run:

```powershell
& "<repo-root>\.claude\skills\test-addon\push-test-build.ps1"
```

Report the script's output (files copied, any errors) back to the user. If
it throws because a `.toc`-listed file is missing on disk, that's a real
packaging bug worth surfacing clearly — it means the `.toc` and the repo
have drifted apart.

## Notes

- Retail only for now (`_retail_`). No Classic/PTR support.
- If `Assets\` ever needs anything beyond audio files, or if another
  runtime dependency shows up that isn't `.toc`-listed, update the script's
  hardcoded inclusion list to match — the `.toc` alone is not a complete
  ship-list.
