-- register the addon command
BestAround = {
	config = {
		achievements = true,
		levels = true,
	}
}

local function updateSettings(setting, value)
	if BestAround.config[setting] == nil then
		print("BestAroundRevisited: Unknown Setting")
		return
	end

	if value == "on" then
		BestAround.config[setting] = true
	elseif value == "off" then
		BestAround.config[setting] = false
	elseif value == "toggle" then
		BestAround.config[setting] = not BestAround.config[setting]
	else
		print("BestAroundRevisited: Invalid value. Use 'on', 'off', or 'toggle'.")
	end

	print("BestAroundRevisited: " .. setting .. " is now " .. (BestAround.config[setting] and "on" or "off"))
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
	local g = math.random(soundLength)
	PlaySoundFile(WOWsounds[g], "Master")
end)
