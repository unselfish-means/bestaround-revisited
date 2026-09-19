-- init Ace3 libraries
BestAround = LibStub("AceAddon-3.0"):NewAddon("BestAroundRevisited", "AceEvent-3.0", "AceConsole-3.0")
local AceAddon = LibStub("AceAddon-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDbOptions = LibStub("AceDBOptions-3.0")
local AceConsole = LibStub("AceConsole-3.0")


-- data storage
function BestAround:OnInitialize()
	-- use the default profile in Options.lua
	-- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	self.db = LibStub("AceDB-3.0"):New("BestAroundRevisitedDB", self.defaults, true)

	-- register an options table and add it to the Blizz options window
	-- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
	AceConfig:RegisterOptionsTable("BestAround_Options", self.options)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("BestAround_Options", "BestAround Revisited")

	-- adds a child options table (profiles panel)
	local profiles = AceDbOptions:GetOptionsTable(self.db)
	AceConfig:RegisterOptionsTable("BestAround_Profiles", profiles)
	AceConfigDialog:AddToBlizOptions("BestAround_Profiles", "Profiles", "BestAround Revisited")

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bestaround", "ChatCommand")
	self:RegisterChatCommand("bar", "ChatCommand")

end

function BestAround:OnEnable()
	self:Print("enabled")
	self:RegisterEvent("ACHIEVEMENT_EARNED")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("PLAYER_DEAD")
end

function BestAround:PlayCategorySound(category)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile[category].soundFiles, self.db.profile.soundChannel)
end

-- WoW can fire the same event more than once for a single occurrence (notably
-- PLAYER_DEAD), which made the sound overlap itself. Ignore repeat plays of a
-- category within this window (measured from the last play, per category).
local DEBOUNCE_SECONDS = 5
local lastPlayed = {}

-- Returns true if the sound played, false if it was suppressed by the debounce.
function BestAround:PlayCategorySoundDebounced(category)
	local now = GetTime()
	if lastPlayed[category] and now - lastPlayed[category] < DEBOUNCE_SECONDS then
		return false
	end
	lastPlayed[category] = now
	self:PlayCategorySound(category)
	return true
end

function BestAround:ACHIEVEMENT_EARNED(event, id)
	if self.db.profile.achievements.enabled then
		self:PlayCategorySoundDebounced("achievements")
	end
end

function BestAround:PLAYER_LEVEL_UP(event, level)
	if self.db.profile.levels.enabled then
		self:PlayCategorySoundDebounced("levels")
	end
end

function BestAround:PLAYER_DEAD(event)
	if self.db.profile.deaths.enabled then
		self:PlayCategorySoundDebounced("deaths")
	end
end

-- Dev-only, unlisted: fires `count` debounced plays of `category` spaced `gap`
-- seconds apart and reports which ones actually played.
function BestAround:DebounceTest(category, count, gap)
	if not (self.db.profile[category] and self.db.profile[category].soundFiles) then
		self:Print("unknown category: " .. tostring(category))
		return
	end
	self:Print(("debounce %s: %d plays, %.2fs apart, %ds window"):format(category, count, gap, DEBOUNCE_SECONDS))
	for i = 1, count do
		C_Timer.After((i - 1) * gap, function()
			local played = self:PlayCategorySoundDebounced(category)
			self:Print(("  %d/%d %s"):format(i, count, played and "played" or "suppressed"))
		end)
	end
end

function BestAround:ChatCommand(input)
	if input == "test achievement" or input == "test" then
		self:PlayCategorySound("achievements")
	elseif input == "test level" then
		self:PlayCategorySound("levels")
	elseif input == "test death" then
		self:PlayCategorySound("deaths")
	elseif input and input:sub(1, 8) == "debounce" then
		-- unlisted: /bar debounce [category] [count] [gap]
		local _, category, count, gap = strsplit(" ", input)
		self:DebounceTest(category or "deaths", tonumber(count) or 3, tonumber(gap) or 0.25)
	else
		AceConfigDialog:Open("BestAround_Options")
	end
end

function BestAround:Print(msg)
	print("|cFF33FF99BestAround:|r " .. msg)
end