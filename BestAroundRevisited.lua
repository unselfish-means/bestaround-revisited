-- register the addon command
if not BestAroundRevisitedDB then 
	BestAroundRevisitedDB = {
		config = {
			achievements = true,
			levels = true,
		}
	}
end

-- BestAround = {
-- 	config = {
-- 		achievements = true,
-- 		levels = true,
-- 	}
-- }

local function updateSettings(setting, value)
	if BestAroundRevisitedDB.config[setting] == nil then
		print("BestAroundRevisited: Unknown Setting")
		return
	end

	if value == "on" then
		BestAroundRevisitedDB.config[setting] = true
	elseif value == "off" then
		BestAroundRevisitedDB.config[setting] = false
	elseif value == "toggle" then
		BestAroundRevisitedDB.config[setting] = not BestAroundRevisitedDB.config[setting]
	else
		print("BestAroundRevisited: Invalid value. Use 'on', 'off', or 'toggle'.")
	end

	print("BestAroundRevisited: " .. setting .. " is now " .. (BestAroundRevisitedDB.config[setting] and "on" or "off"))
end

local SlashCommand = "/bestaround"
local SlashCommandList["BESTAROUNDREVISITED"] = function(msg)
	-- parse the setting
	local command, value = msg:match("^(%S*)%s*(.-)$")

	-- handle command
	if command == "get" then
		print("BestAroundRevisited: Settings")
		for k, v in pairs(BestAround.config) do
			print(k .. ": " .. (v and "on" or "off"))
		end
	elseif BestAround.config[command] ~= nil then
		updateSettings(command, value)
	else
		-- Print usage information
		print("BestAround usage:")
		print("/bestaround <setting> <on|off|toggle>")
		print("/bestaround get")
		print("Available settings: achievements, levels")
	end

	updateSettings(setting, value)
end


local WOWsounds = {}
WOWsounds[#WOWsounds+1] = 'Interface\\AddOns\\BestAroundRevisited\\assets\\bestaround.mp3'

local soundLength = #WOWsounds

local levelFrame = CreateFrame("Frame")

levelFrame:RegisterEvent("PLAYER_LEVEL_UP")
levelFrame:RegisterEvent("ACHIEVEMENT_EARNED")


print('BestAroundReloaded loaded ' .. soundLength .. ' looting sounds.')


levelFrame:SetScript("OnEvent",function(self, event, ...)
	print("Debugging: event is " .. event)
	print("Debugging: achievements is " .. BestAroundRevisitedDB.config.achievements)
	print("Debugging: levels is " .. BestAroundRevisitedDB.config.levels)

	local g = math.random(soundLength)

	if event == "PLAYER_LEVEL_UP" and BestAroundRevisitedDB.config.levels then
		print("Debugging: you have leveled up!")
		PlaySoundFile(WOWsounds[g], "Master")
	end

	if event == "ACHIEVEMENT_EARNED" and BestAroundRevisitedDB.config.achievements then
		print("Debugging: you have earned an achievement!")
		PlaySoundFile(WOWsounds[g], "Master")
	end
end)
