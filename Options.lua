BestAround.defaults = {
    profile = {
        achievements = true,
        levels = true,
        deaths = true,
        soundChannel = "Master"
    }
}

BestAround.options = {
    type = "group",
    name = "BestAround Revisited",
    args = {
        achievements = {
            type = "toggle",
            name = "Achievements",
            desc = "Enable or disable achievement sounds",
            get = function(info) return BestAround.db.profile.achievements end,
            set = function(info, value) BestAround.db.profile.achievements = value end,
        },
        levels = {
            type = "toggle",
            name = "Levels",
            desc = "Enable or disable level-up sounds",
            get = function(info) return BestAround.db.profile.levels end,
            set = function(info, value) BestAround.db.profile.levels = value end,
        },
        deaths = {
            type = "toggle",
            name = "Deaths",
            desc = "Enable or disable death sounds",
            get = function(info) return BestAround.db.profile.deaths end,
            set = function(info, value) BestAround.db.profile.deaths = value end,
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