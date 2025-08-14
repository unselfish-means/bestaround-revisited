# Ace3 Migration TODO

1. [x] **Add Ace3 Libraries**
   - [x] Download Ace3 from https://www.wowace.com/projects/ace3 or use an existing copy.
   - [x] Place Ace3 folders (AceAddon-3.0, AceConfig-3.0, AceConfigDialog-3.0, AceDB-3.0, AceConsole-3.0, AceGUI-3.0) in a `libs` folder inside your addon.
   - [x] Reference the Ace3 XML files in your `.toc` file.

2. [ ] **Initialize Ace3 in Your Lua File**
   - [x] Require Ace3 libraries using `LibStub`.
   - [ ] Create your main addon object using `AceAddon:NewAddon`.

3. [ ] **Replace Your SavedVariables with AceDB**
   - [ ] Remove manual config table (e.g., `BestAroundRevisitedDB`).
   - [ ] Use AceDB to create a database:
     ```lua
     local AceDB = LibStub("AceDB-3.0")
     addon.db = AceDB:New("BestAroundRevisitedDB", { profile = { ...defaults... } })
     ```
   - [ ] Access settings via `addon.db.profile.settingName`.

4. [ ] **Create an AceConfig Options Table**
   - [ ] Define options in a table structure compatible with AceConfig.
   - [ ] Use `get` and `set` functions to read/write settings from AceDB.

5. [ ] **Register Options with AceConfig and Add to Blizzard Interface Panel**
   - [ ] Register your options table with AceConfig.
   - [ ] Add it to the Blizzard options UI using AceConfigDialog.

6. [ ] **Update Your Addon Logic**
   - [ ] Replace references to old config table with AceDB profile references.
   - [ ] Remove manual slash command logic for settings if you want to rely on the GUI.

7. [ ] **Test In-Game**
   - [ ] Reload your UI and check the Interface > AddOns panel for your options.
