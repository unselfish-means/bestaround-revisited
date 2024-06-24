local WOWsounds = {}
WOWsounds[#WOWsounds+1] = 'Interface\\AddOns\\BestAroundRevisited\\sounds\\bestaround.mp3'

local soundLength = #WOWsounds

local levelFrame = CreateFrame("Frame")

levelFrame:RegisterEvent("PLAYER_LEVEL_UP")
levelFrame:RegisterEvent("ACHIEVEMENT_EARNED")


print('BestAroundReloaded loaded ' .. soundLength .. ' looting sounds.')


levelFrame:SetScript("OnEvent",function(self, event, ...)
	local g = math.random(soundLength)
	PlaySoundFile(WOWsounds[g], "Master")
end)
