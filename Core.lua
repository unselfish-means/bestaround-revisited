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
	self:RegisterEvent("ACHIEVEMENT_EARNED")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("PLAYER_DEAD")
end

function BestAround:ACHIEVEMENT_EARNED(event, id)
	print("BestAround:" .. event)
	print("BestAround:" .. id)
	print("BestAround:" .. self.db.profile.soundChannel)
	print("BestAround:" .. self.db.profile.baseSoundPath)
	print("BestAround:" .. self.db.profile.achievements.soundFiles)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.achievements.soundFiles, self.db.profile.soundChannel)
end

function BestAround:PLAYER_LEVEL_UP(event, level)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.levels.soundFiles, self.db.profile.soundChannel)
end

function BestAround:PLAYER_DEAD(event)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.deaths.soundFiles, self.db.profile.soundChannel)
end

function BestAround:ChatCommand(input)
	if input == "achievement" then
		self:ACHIEVEMENT_EARNED("Testing ACHIEVEMENT_EARNED")
	elseif input == "level" then
		self:PLAYER_LEVEL_UP("Testing PLAYER_LEVEL_UP")
	elseif input == "death" then
		self:PLAYER_DEAD("Testing PLAYER_DEAD")
	else
		AceConfigDialog:Open("BestAround_Options")
	end
end