BestAround.sounds = {
    BestAround = "bestaround.mp3",
    DumbWaysToDie = "dumbwaystodie.mp3"
}

BestAround.defaults = {
    profile = {
        baseSoundPath = 'Interface\\AddOns\\BestAroundRevisited\\Assets\\',
        achievements = {
            enabled = true,
            soundFiles = 'bestaround.mp3',
        },
        levels = {
            enabled = true,
            soundFiles = 'bestaround.mp3',
        },
        deaths = {
            enabled = true,
            soundFiles = 'dumbwaystodie.mp3',
        },
        soundChannel = "Master"
    }
}

BestAround.options = {
    type = "group",
    name = "BestAround Revisited",
    handler = BestAround,
    args = {
        achievements = {
            type = "group",
            name = "Achievements",
            desc = "Enable or disable achievement sounds",
            inline = true,
            args = {
                achievementToggle = {
                    type = "toggle",
                    name = "Achievements",
                    desc = "Enable or disable achievement sounds",
                    get = function(info) return BestAround.db.profile.achievements.enabled end,
                    set = function(info, value) BestAround.db.profile.achievements.enabled = value end,
                },
                sound = {
                    type = "dropdown",
                    name = "Sound",
                    desc = "Select the sound to play",
                    values = BestAround.sounds,
                    get = function(info) return BestAround.db.profile.achievements.soundFiles end,
                    set = function(info, value) BestAround.db.profile.achievements.soundFiles = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the achievement sound",
                    func = function() BestAround:ACHIEVEMENT_EARNED("TEST_EVENT", 12345) end
                }
            },
        },
        levels = {
            type = "toggle",
            name = "Levels",
            desc = "Enable or disable level-up sounds",
            get = function(info) return BestAround.db.profile.levels.enabled end,
            set = function(info, value) BestAround.db.profile.levels.enabled = value end,
        },
        deaths = {
            type = "toggle",
            name = "Deaths",
            desc = "Enable or disable death sounds",
            get = function(info) return BestAround.db.profile.deaths.enabled end,
            set = function(info, value) BestAround.db.profile.deaths.enabled = value end,
        },
        soundChannel = {
            type = "select",
            name = "Sound Channel",
            desc = "Select the sound channel",
            values = {
                Master = "Master",
                SFX = "SFX",
                Music = "Music",
            },
            get = function(info) return BestAround.db.profile.soundChannel end,
            set = function(info, value) BestAround.db.profile.soundChannel = value end,
        },
    }
}