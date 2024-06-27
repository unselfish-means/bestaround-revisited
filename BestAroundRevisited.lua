-- data storage

if not BestAroundRevisitedDB then 
	BestAroundRevisitedDB = {
		config = {
			achievements = true,
			levels = true,
		}
	}
end


-- assets

local WOWsounds = {}
WOWsounds[#WOWsounds+1] = 'Interface\\AddOns\\BestAroundRevisited\\assets\\bestaround.mp3'
local soundLength = #WOWsounds
print('BestAroundReloaded: loaded ' .. soundLength .. ' looting sounds.')


-- main frame

local mainFrame = CreateFrame("Frame", "BestAroundRevisitedFrame", UIParent, "BasicFrameTemplateWithInset")


-- functionality

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


-- slash command

SLASH_BESTAROUND1 = "/bar"
SLASH_BESTAROUND2 = "/bestaround"
SlashCmdList["BESTAROUND"] = function(msg)
		-- parse the setting
		local command, value = msg:match("^(%S*)%s*(.-)$")

		-- handle command
		if command == "get" then
			print("BestAroundRevisited: Settings")
			for k, v in pairs(BestAroundRevisitedDB.config) do
				print(k .. ": " .. (v and "on" or "off"))
			end
		elseif BestAroundRevisitedDB.config[command] ~= nil then
			updateSettings(command, value)
		else
			-- Print usage information
			print("BestAround usage:")
			print("/bestaround <achievements|levels> <on|off|toggle>")
			print("/bestaround get")
		end
end

-- event listener

local eventListenerFrame = CreateFrame("Frame", "BestAroundRevisitedListenerFrame", UIParent)

local function eventHandler(self, event, ...)
	if event == "PLAYER_LEVEL_UP" and BestAroundRevisitedDB.config.levels then
		PlaySoundFile(WOWsounds[math.random(soundLength)], "Master")
	elseif event == "ACHIEVEMENT_EARNED" and BestAroundRevisitedDB.config.achievements then
		PlaySoundFile(WOWsounds[math.random(soundLength)], "Master")
	end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventListenerFrame:RegisterEvent("ACHIEVEMENT_EARNED")

table.insert(UISpecialFrames, "BestAroundRevisitedFrame")