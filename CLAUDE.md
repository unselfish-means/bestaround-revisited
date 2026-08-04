# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

"Best Around (Revisited)" is a World of Warcraft addon (author: WIKR) that plays an audio cue when the player levels up, earns an achievement, or dies. It's built on the [Ace3](https://www.wowace.com/projects/ace3) addon framework (vendored under `Libs/`). There is no build system, package manager, or automated test suite — WoW addons are plain Lua/XML loaded directly by the game client per the `.toc` manifest.

## Architecture

- [BestAroundRevisited.toc](BestAroundRevisited.toc) — the addon manifest WoW reads to load the addon. Declares supported client `## Interface` versions, metadata, and the ordered list of files to load: the vendored Ace3 library XML files (in dependency order), then `Core.lua`, then `Options.lua`. Any new file must be added here or it will never load.
- [Core.lua](Core.lua) — addon entry point. Creates the `BestAround` addon object via `LibStub("AceAddon-3.0"):NewAddon(...)` (with `AceEvent-3.0` and `AceConsole-3.0` mixins). Key lifecycle:
  - `OnInitialize` — builds `self.db` via `AceDB-3.0` (backed by `BestAround.defaults` from Options.lua, saved as `BestAroundRevisitedDB`), registers the options table with `AceConfig`/`AceConfigDialog` (added to the Blizzard options panel, plus a Profiles sub-panel via `AceDBOptions`), and registers the `/bestaround` and `/bar` chat commands.
  - `OnEnable` — registers `ACHIEVEMENT_EARNED`, `PLAYER_LEVEL_UP`, `PLAYER_DEAD` WoW events via `AceEvent-3.0`.
  - Event handler methods (`BestAround:ACHIEVEMENT_EARNED`, `BestAround:PLAYER_LEVEL_UP`, `BestAround:PLAYER_DEAD`) all call `PlaySoundFile` using `self.db.profile.<category>.soundFiles`, `self.db.profile.baseSoundPath`, and `self.db.profile.soundChannel`.
  - `ChatCommand` handles `/bar test[s|s achievement|test level|test death]` (fires the corresponding event handler directly) and otherwise opens the AceConfig options dialog.
- [Options.lua](Options.lua) — defines `BestAround.sounds` (available sound file names), `BestAround.defaults` (AceDB profile defaults: one sub-table per category — `achievements`, `levels`, `deaths` — each with `enabled` and `soundFiles`), and `BestAround.options` (the AceConfig options table: sound channel selector, plus one inline group per category with an enable toggle, sound picker, and test button). Both tables are populated onto the `BestAround` global that `Core.lua` creates — load order in the `.toc` (Core.lua before Options.lua) means `Core.lua` must not read `self.defaults`/`self.options` until after Options.lua has run (i.e. not at file scope).
- [Libs/](Libs/) — vendored Ace3 framework libraries (AceAddon, AceConfig, AceDB, AceConsole, AceEvent, AceGUI, etc.), each with its own `.lua`/`.xml`. Referenced individually by the top-level `.toc`. `Libs/Ace3.lua`/`Libs/Ace3.toc` and the root [embeds.xml](embeds.xml) are leftover standalone-Ace3 dev-tooling artifacts (a `/ace3` config browser, `/rl` reload-UI binding) — they are **not** referenced by `BestAroundRevisited.toc` and are not part of the loaded addon.
- [Assets/](Assets/) — audio files referenced by relative path in `Options.lua`'s `sounds` table and joined with `baseSoundPath` (`Interface\AddOns\BestAroundRevisited\Assets\`) at play time.

## Config model

Settings live in `BestAround.db.profile` (an AceDB profile, so they're per-profile and support the Ace3 profile-switching UI). There is no longer a hand-rolled `config` table or manual slash-command toggles — all settings are read/written through the AceConfig options table's `get`/`set` functions, which is the single source of truth for both the GUI and any programmatic access.

## Adding a new sound category (following the `achievements`/`levels`/`deaths` pattern)

1. Add a `<category> = { enabled = true, soundFiles = ... }` entry to `BestAround.defaults.profile` in Options.lua.
2. Add a matching inline group under `BestAround.options.args` in Options.lua (toggle, sound select, test button), following an existing category's shape.
3. Add a `BestAround:<EVENT_NAME>(event, ...)` handler in Core.lua that calls `PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.<category>.soundFiles, self.db.profile.soundChannel)`, guarded by `self.db.profile.<category>.enabled` if the event should be individually toggleable.
4. Register the new WoW event in `OnEnable` (`self:RegisterEvent("EVENT_NAME")`).
5. Optionally wire a `test <category>` branch into `ChatCommand`.

## Testing

There is no automated test suite. Verification is manual: load the addon in a WoW client (see `.toc` `## Interface` versions for supported client builds), then exercise it in-game via `/bar` (opens options), `/bar test`/`test level`/`test death`, the Blizzard AddOns options panel, leveling up, earning an achievement, or dying.
