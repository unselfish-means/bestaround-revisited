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
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.achievements.soundFiles, self.db.profile.soundChannel)
end

function BestAround:PLAYER_LEVEL_UP(event, level)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.levels.soundFiles, self.db.profile.soundChannel)
end

function BestAround:PLAYER_DEAD(event)
	PlaySoundFile(self.db.profile.baseSoundPath .. self.db.profile.deaths.soundFiles, self.db.profile.soundChannel)
end

function BestAround:ChatCommand(input, editbox)
	if input == "achievement" then
		self:ACHIEVEMENT_EARNED()
	elseif input == "level" then
		self:PLAYER_LEVEL_UP()
	elseif input == "death" then
		self:PLAYER_DEAD()
	end
end

-- -- frames

-- local mainFrame = CreateFrame("Frame", "BestAroundRevisitedFrame", UIParent, "BasicFrameTemplateWithInset")
-- local eventListenerFrame = CreateFrame("Frame", "BestAroundRevisitedListenerFrame", UIParent)


-- -- Assets

-- local sounds = {
-- 	BEST_AROUND = 'Interface\\AddOns\\BestAroundRevisited\\assets\\bestaround.mp3',
-- 	DUMB_WAYS_TO_DIE = 'Interface\\AddOns\\BestAroundRevisited\\assets\\dumbwaystodie.mp3',
-- }


-- -- Events

-- local Event = {}
-- Event.__index = Event

-- function Event:new(name, event, sounds)
-- 	local obj = {
-- 		name = name,
-- 		event = event,
-- 		sounds = sounds or {}
-- 	}
-- 	eventListenerFrame:RegisterEvent(event)
-- 	setmetatable(obj, Event)
-- 	return obj
-- end

-- function Event:playSound(isTest)
-- 	if #self.sounds > 0 and (isTest or self:isEnabled()) then
-- 		PlaySoundFile(self.sounds[math.random(#self.sounds)], "Master")
-- 	end
-- end

-- function Event:isEnabled()
-- 	return BA.db.profile[self.event] == true
-- end

-- function Event:enable()
-- 	BestAroundRevisitedDB.config[self.event] = true
-- end

-- function Event:disable()
-- 	BestAroundRevisitedDB.config[self.event] = false
-- end

-- function Event:toggle()
-- 	BestAroundRevisitedDB.config[self.event] = not BestAroundRevisitedDB.config[self.event]
-- end

-- function Event:test()
-- 	local isTest = true
-- 	self:playSound(isTest)
-- end

-- -- Define events
-- local Events = {
-- 	-- (name, event, sounds)
-- 	achievement = Event:new("achievement", "ACHIEVEMENT_EARNED", {sounds.BEST_AROUND}),
-- 	level = Event:new("level", "PLAYER_LEVEL_UP", {sounds.BEST_AROUND}),
-- 	death = Event:new("death", "PLAYER_DEAD", {sounds.DUMB_WAYS_TO_DIE}),
-- }

-- -- colors

-- local colors = {}
-- colors['LIGHTBLUE'] = 'cff00ccff';
-- local colorOn = '\124'
-- local colorOff = '\124r'

-- local function colorize(text, color)
-- 	return colorOn .. colors[color] .. text .. colorOff
-- end

-- local prefix = colorize('BestAround: ', 'LIGHTBLUE')

-- local function _print(text)
-- 	print(prefix .. text)
-- end

-- local function printUsage()
-- 	_print("/bestaround <achievements|levels> <on|off|toggle>")
-- 	_print("/bestaround test")
-- 	_print("/bestaround help")
-- end

-- local function updateSettings(setting, value)
-- 	if BestAroundRevisitedDB.config[setting] == nil then
-- 		_print("Unknown Setting")
-- 		return
-- 	end

-- 	if value == "on" then
-- 		BestAroundRevisitedDB.config[setting] = true
-- 	elseif value == "off" then
-- 		BestAroundRevisitedDB.config[setting] = false
-- 		BestAroundRevisitedDB.config[setting] = not BestAroundRevisitedDB.config[setting]
-- 	else
-- 		_print("Invalid value. Use 'on', 'off', or 'toggle'.")
-- 	end

-- 	_print(setting .. " is now " .. (BestAroundRevisitedDB.config[setting] and "on" or "off"))
-- end


-- -- slash command


-- SLASH_BESTAROUND1 = "/bar"
-- SLASH_BESTAROUND2 = "/bestaround"
-- SlashCmdList["BESTAROUND"] = function(msg)
-- 		-- parse the setting
-- 		local command, value = msg:match("^(%S*)%s*(.-)$")

-- 		-- handle command
-- 		if command == "help" then
-- 			printUsage()
-- 			_print("Settings:")
-- 			for k, v in pairs(BestAroundRevisitedDB.config) do
-- 				print(k .. ": " .. (v and "on" or "off"))
-- 			end
-- 		elseif command == "test" then
-- 			Events.level:playSound(true)
-- 		elseif command == "testdeath" then
-- 			Events.death:playSound(true)
-- 		elseif BestAroundRevisitedDB.config[command] ~= nil then
-- 			updateSettings(command, value)
-- 		else
-- 			printUsage()
-- 		end
-- end

-- -- event listener Frame

-- local function eventHandler(self, event, ...)
-- 	if event == Events.level.event and Events.level.isEnabled() then
-- 		Events.level:playSound(true)
-- 	elseif event == Events.achievement.event and Events.achievement.isEnabled() then
-- 		Events.achievement:playSound(true)
-- 	elseif event == Events.death.event and Events.death.isEnabled() then
-- 		Events.death:playSound(true)
-- 	else
-- 		_print("Unhandled event: " .. event)
-- 	end
-- end

-- eventListenerFrame:SetScript("OnEvent", eventHandler)

-- table.insert(UISpecialFrames, "BestAroundRevisitedFrame")
