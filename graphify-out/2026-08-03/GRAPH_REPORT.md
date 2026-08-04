# Graph Report - bestaroundrevisited  (2026-08-03)

## Corpus Check
- 53 files · ~64,275 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 585 nodes · 752 edges · 53 communities (45 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `cac77a17`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- AceConfigDialog-3.0.lua
- AceGUIWidget-DropDown.lua
- AceAddon-3.0.lua
- ChatThrottleLib.lua
- AceGUIWidget-DropDown-Items.lua
- AceGUIContainer-TreeGroup.lua
- AceGUI-3.0.lua
- AceDB-3.0.lua
- AceGUIWidget-MultiLineEditBox.lua
- AceConfigCmd-3.0.lua
- AceGUIContainer-TabGroup.lua
- AceHook-3.0.lua
- AceGUIWidget-EditBox.lua
- AceGUIWidget-Slider.lua
- AceBucket-3.0.lua
- AceConsole-3.0.lua
- AceDBOptions-3.0.lua
- AceComm-3.0.lua
- AceConfigRegistry-3.0.lua
- AceTab-3.0.lua
- Ace3.lua
- AceGUIWidget-Keybinding.lua
- AceSerializer-3.0.lua
- AceTimer-3.0.lua
- CLAUDE.md
- AceGUIWidget-CheckBox.lua
- AceGUIWidget-ColorPicker.lua
- WIKR - Best Around (Revisited)
- TODO.md
- Test Addon

## God Nodes (most connected - your core abstractions)
1. `del()` - 15 edges
2. `GetOptionsMemberValue()` - 15 edges
3. `new()` - 14 edges
4. `handle()` - 11 edges
5. `FeedOptions()` - 11 edges
6. `ActivateControl()` - 10 edges
7. `BuildGroups()` - 10 edges
8. `AceConfigDialog:FeedGroup()` - 10 edges
9. `CheckOptionHidden()` - 9 edges
10. `BuildSubGroups()` - 9 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (53 total, 8 thin omitted)

### Community 0 - "AceConfigDialog-3.0.lua"
Cohesion: 0.11
Nodes (32): AceConfigDialog:FeedGroup(), AceConfigDialog:Open(), AceConfigDialog:SelectGroup(), ActivateControl(), ActivateMultiControl(), ActivateSlider(), BuildGroups(), BuildPath() (+24 more)

### Community 1 - "AceGUIWidget-DropDown.lua"
Cohesion: 0.05
Nodes (12): AddCloseButton(), AddItem(), AddListItem(), fixlevels(), fixstrata(), OnAcquire(), OnItemValueChanged(), Open() (+4 more)

### Community 2 - "AceAddon-3.0.lua"
Cohesion: 0.07
Nodes (9): AceAddon:DisableAddon(), AceAddon:EnableAddon(), AceAddon:InitializeAddon(), AceAddon:NewAddon(), Embed(), Enable(), NewModule(), queuedForInitialization() (+1 more)

### Community 3 - "ChatThrottleLib.lua"
Cohesion: 0.12
Nodes (21): ChatThrottleLib:BNSendGameData(), ChatThrottleLib:Despool(), ChatThrottleLib:Enqueue(), ChatThrottleLib.Hook_BNSendGameData(), ChatThrottleLib.Hook_SendAddonMessage(), ChatThrottleLib.Hook_SendAddonMessageLogged(), ChatThrottleLib.Hook_SendChatMessage(), ChatThrottleLib:Init() (+13 more)

### Community 4 - "AceGUIWidget-DropDown-Items.lua"
Cohesion: 0.08
Nodes (11): Constructor(), fixlevels(), Frame_OnClick(), ItemBase.Create(), ItemBase.OnRelease(), ItemBase.SetDisabled(), ItemBase.SetPullout(), OnRelease() (+3 more)

### Community 6 - "AceGUIContainer-TreeGroup.lua"
Cohesion: 0.10
Nodes (3): addLine(), GetButtonUniqueValue(), new()

### Community 7 - "AceGUI-3.0.lua"
Cohesion: 0.12
Nodes (7): AceGUI:ClearFocus(), AceGUI:Create(), AceGUI:Release(), AceGUI:SetFocus(), delWidget(), newWidget(), safecall()

### Community 8 - "AceDB-3.0.lua"
Cohesion: 0.17
Nodes (13): AceDB:New(), copyDefaults(), copyTable(), DBObjectLib:CopyProfile(), DBObjectLib:RegisterDefaults(), DBObjectLib:RegisterNamespace(), DBObjectLib:ResetDB(), DBObjectLib:ResetProfile() (+5 more)

### Community 10 - "AceConfigCmd-3.0.lua"
Cohesion: 0.27
Nodes (13): AceConfigCmd:HandleCommand(), callfunction(), callmethod(), checkhidden(), do_final(), err(), getparam(), handle() (+5 more)

### Community 11 - "AceGUIContainer-TabGroup.lua"
Cohesion: 0.19
Nodes (8): PanelTemplates_DeselectTab(), PanelTemplates_SelectTab(), PanelTemplates_SetDisabledTabState(), PanelTemplates_TabResize(), Tab_SetDisabled(), Tab_SetSelected(), Tab_SetText(), UpdateTabLook()

### Community 12 - "AceHook-3.0.lua"
Cohesion: 0.20
Nodes (8): AceHook:Hook(), AceHook:HookScript(), AceHook:RawHook(), AceHook:RawHookScript(), AceHook:SecureHook(), AceHook:SecureHookScript(), createHook(), hook()

### Community 13 - "AceGUIWidget-EditBox.lua"
Cohesion: 0.19
Nodes (6): Button_OnClick(), EditBox_OnEnterPressed(), EditBox_OnReceiveDrag(), EditBox_OnTextChanged(), HideButton(), ShowButton()

### Community 16 - "AceBucket-3.0.lua"
Cohesion: 0.21
Nodes (5): AceBucket:RegisterBucketEvent(), AceBucket:RegisterBucketMessage(), FireBucket(), RegisterBucket(), safecall()

### Community 17 - "AceConsole-3.0.lua"
Cohesion: 0.21
Nodes (5): AceConsole:GetArgs(), AceConsole:Print(), AceConsole:Printf(), nils(), Print()

### Community 18 - "AceDBOptions-3.0.lua"
Cohesion: 0.21
Nodes (5): AceDBOptions:GetOptionsTable(), generateDefaultProfiles(), getOptionsHandler(), getProfileList(), OptionsHandlerPrototype:ListProfiles()

### Community 20 - "AceConfigRegistry-3.0.lua"
Cohesion: 0.31
Nodes (7): AceConfigRegistry:RegisterOptionsTable(), AceConfigRegistry:ValidateOptionsTable(), err(), validate(), validateGetterArgs(), validateKey(), validateVal()

### Community 21 - "AceTab-3.0.lua"
Cohesion: 0.29
Nodes (7): AceTab:OnTabPressed(), AceTab:RegisterTabCompletion(), cycleTab(), fillMatches(), gcbs(), getTextBeforeCursor(), hookFrame()

### Community 23 - "AceGUIWidget-Keybinding.lua"
Cohesion: 0.28
Nodes (3): Keybinding_OnKeyDown(), Keybinding_OnMouseDown(), Keybinding_OnMouseWheel()

### Community 24 - "AceSerializer-3.0.lua"
Cohesion: 0.28
Nodes (4): AceSerializer:Serialize(), DeserializeNumberHelper(), DeserializeValue(), SerializeValue()

### Community 25 - "AceTimer-3.0.lua"
Cohesion: 0.28
Nodes (3): AceTimer:ScheduleRepeatingTimer(), AceTimer:ScheduleTimer(), new()

### Community 28 - "CLAUDE.md"
Cohesion: 0.29
Nodes (5): Adding a new sound category (following the `achievements`/`levels`/`deaths` pattern), Architecture, Config model, Project overview, Testing

### Community 51 - "Test Addon"
Cohesion: 0.33
Nodes (5): Notes, Running it, Test Addon, What it does, When to use

## Knowledge Gaps
- **11 isolated node(s):** `What it does`, `When to use`, `Running it`, `Notes`, `Project overview` (+6 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What connects `What it does`, `When to use`, `Running it` to the rest of the system?**
  _11 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `AceConfigDialog-3.0.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.10938775510204081 - nodes in this community are weakly interconnected._
- **Should `AceGUIWidget-DropDown.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.05454545454545454 - nodes in this community are weakly interconnected._
- **Should `AceAddon-3.0.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.06951871657754011 - nodes in this community are weakly interconnected._
- **Should `ChatThrottleLib.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.12315270935960591 - nodes in this community are weakly interconnected._
- **Should `AceGUIWidget-DropDown-Items.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.08374384236453201 - nodes in this community are weakly interconnected._
- **Should `AceGUIContainer-Window.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.08695652173913043 - nodes in this community are weakly interconnected._