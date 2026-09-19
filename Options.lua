BestAround.sounds = {
    ["bestaround.mp3"] = "bestaround.mp3",
    ["coffin-dance.mp3"] = "coffin-dance.mp3",
    ["dumbwaystodie.mp3"] = "dumbwaystodie.mp3",
    ["dumbwaystodie-hai-hai-hai.mp3"] = "dumbwaystodie-hai-hai-hai.mp3",
    ["dumbwaystodie-outro.mp3"] = "dumbwaystodie-outro.mp3",
    ["dumbwaystodie-short.mp3"] = "dumbwaystodie-short.mp3",
    ["dumbwaystodie-so-many-ways.mp3"] = "dumbwaystodie-so-many-ways.mp3",
    ["pacman-death.mp3"] = "pacman-death.mp3"
}

BestAround.defaults = {
    profile = {
        baseSoundPath = 'Interface\\AddOns\\BestAroundRevisited\\Assets\\',
        soundChannel = "Master",
        -- `sounds` is a set of file name -> true. One is picked at random each
        -- time the event fires; an empty set means the event plays nothing.
        achievements = {
            enabled = true,
            sounds = { ["bestaround.mp3"] = true },
        },
        levels = {
            enabled = true,
            sounds = { ["bestaround.mp3"] = true },
        },
        deaths = {
            enabled = true,
            sounds = { ["dumbwaystodie.mp3"] = true },
        },
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
            order = 1,
            values = {
                Master = "Master",
                SFX = "SFX",
                Music = "Music",
            },
            get = function(info) return BestAround.db.profile.soundChannel end,
            set = function(info, value) BestAround.db.profile.soundChannel = value end,
        },
        divider = {
            type = "description",
            name = " ",
            order = 2,
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
                    type = "multiselect",
                    dialogControl = "Dropdown",
                    name = "Sounds",
                    desc = "Select the sounds to play; one is picked at random",
                    values = BestAround.sounds,
                    get = function(info, key) return BestAround.db.profile.achievements.sounds[key] end,
                    set = function(info, key, value) BestAround.db.profile.achievements.sounds[key] = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the achievement sound",
                    func = function() BestAround:TestCategorySound("achievements") end
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
                    type = "multiselect",
                    dialogControl = "Dropdown",
                    name = "Sounds",
                    desc = "Select the sounds to play on level up; one is picked at random",
                    values = BestAround.sounds,
                    get = function(info, key) return BestAround.db.profile.levels.sounds[key] end,
                    set = function(info, key, value) BestAround.db.profile.levels.sounds[key] = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the level-up sound",
                    func = function() BestAround:TestCategorySound("levels") end
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
                    type = "multiselect",
                    dialogControl = "Dropdown",
                    name = "Sounds",
                    desc = "Select the sounds to play on death; one is picked at random",
                    values = BestAround.sounds,
                    get = function(info, key) return BestAround.db.profile.deaths.sounds[key] end,
                    set = function(info, key, value) BestAround.db.profile.deaths.sounds[key] = value end,
                },
                testButton = {
                    type = "execute",
                    name = "Test",
                    desc = "Play the death sound",
                    func = function() BestAround:TestCategorySound("deaths") end
                }
            },
        },
    }
}