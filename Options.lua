BestAround.sounds = {
    ["bestaround.mp3"] = "bestaround.mp3",
    ["dumbwaystodie.mp3"] = "dumbwaystodie.mp3"
}

BestAround.defaults = {
    profile = {
        baseSoundPath = 'Interface\\AddOns\\BestAroundRevisited\\Assets\\',
        achievements = {
            enabled = true,
            soundFiles = BestAround.sounds.BestAround,
        },
        levels = {
            enabled = true,
            soundFiles = BestAround.sounds.BestAround,
        },
        deaths = {
            enabled = true,
            soundFiles = BestAround.sounds.DumbWaysToDie,
        },
        soundChannel = "Master"
    }
}

BestAround.options = {
    type = "group",
    name = "BestAround Revisited",
    handler = BestAround,
    args = {
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
        achievements = {
            type = "group",
            name = "Achievements",
            desc = "Enable or disable achievement sounds",
            inline = true,
            args = {
                achievementToggle = {
                    type = "toggle",
                    name = "Enabled",
                    desc = "Enable or disable achievement sounds",
                    get = function(info) return BestAround.db.profile.achievements.enabled end,
                    set = function(info, value) BestAround.db.profile.achievements.enabled = value end,
                },
                sound = {
                    type = "select",
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
                    func = function() BestAround:ACHIEVEMENT_EARNED("Testing ACHIEVEMENT_EARNED") end
                }
            },
        },
        levels = {
            type = "group",
            name = "Levels",
            desc = "Enable or disable level-up sounds",
            inline = true,
            args = {
                levelToggle = {
                    type = "toggle",
                    name = "Enabled",
                    desc = "Enable or disable level-up sounds",
                    get = function(info) return BestAround.db.profile.levels.enabled end,
                    set = function(info, value) BestAround.db.profile.levels.enabled = value end,
                },
                sound = {
                    type = "select",
                    name = "Sound",
                    desc = "Select the sound to play on level up",
                    values = BestAround.sounds,
                    get = function(info) return BestAround.db.profile.levels.soundFiles end,
                    set = function(info, value) BestAround.db.profile.levels.soundFiles = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the level-up sound",
                    func = function() BestAround:PLAYER_LEVEL_UP("Testing PLAYER_LEVEL_UP") end
                }
            },
        },
        deaths = {
            type = "group",
            name = "Deaths",
            desc = "Enable or disable death sounds",
            inline = true,
            args = {
                deathToggle = {
                    type = "toggle",
                    name = "Enabled",
                    desc = "Enable or disable death sounds",
                    get = function(info) return BestAround.db.profile.deaths.enabled end,
                    set = function(info, value) BestAround.db.profile.deaths.enabled = value end,
                },
                sound = {
                    type = "select",
                    name = "Sound",
                    desc = "Select the sound to play on death",
                    values = BestAround.sounds,
                    get = function(info) return BestAround.db.profile.deaths.soundFiles end,
                    set = function(info, value) BestAround.db.profile.deaths.soundFiles = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the death sound",
                    func = function() BestAround:PLAYER_DEAD("Testing PLAYER_DEAD") end
                }
            },
        },
    }
}