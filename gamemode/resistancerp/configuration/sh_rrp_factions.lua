--Create a team table, this team table is fed into sv_core.lua to do some calculations and assign it to the team, it will also store what ranks are in each team, certs available and promo shit
ResistanceRP.Factions = ResistanceRP.Factions or {}

ResistanceRP.Factions["GGR"] = {
    idName = "GGR",
    dName = "The Greater German Reich", --dName is DisplayName
    description = "Germany Gang!",
    icon = "gbOP1RV",
    ranks = {
        --Display the ranks, lowest to highest (pvt --> cpt etc)
        [0] = {
            idName = "GGR_Trainee", 
            dName = "Trainee", 
            rankPrefix = "TRA", 
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
            skins = {0, 1, 2, 3},
            bodygroups = {
                {4}, --Headgear
                {0}, -- Helmet Accessory
                {0,1,2,3,4}, --Facial Features
                {1}, -- Trousers
                {0,1}, --Trousers
                {0,1}, --Watch
                {0}, -- Hands
                {0}, --Rank
                {0}, --Facewear
                {1}, --Backpack
                {1}, --ET
                {6} --Kit
            }, --List all bodygroups for this rank (if you want multiple, put in multiple variables)
            maxPromote = 0, --Can't Promote
            maxDemote = 0, --Can't Demote
            -- If they could promote, a number of 2 would mean they could promot eup to rank two, like from trainee to spc (trainee, pvt, spc etc)
            rankIcon = "", --Not needed
            weapons = {"re_hands"},
            commands = {}, --This could be used to allow users access to special commands on job specific
        },
        --Display the ranks, lowest to highest (pvt --> cpt etc)
        [1] = {
            idName = "GGR_Grenadier", 
            dName = "Grenadier", 
            rankPrefix = "Gren", 
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
            skins = {0, 1, 2, 3},
            bodygroups = {
                {4}, --Headgear
                {0}, -- Helmet Accessory
                {0,1,2,3,4}, --Facial Features
                {1}, -- Trousers
                {0,1}, --Trousers
                {0,1}, --Watch
                {0}, -- Hands
                {0}, --Rank
                {0}, --Facewear
                {1}, --Backpack
                {1}, --ET
                {6} --Kit
            }, --List all bodygroups for this rank (if you want multiple, put in multiple variables)
            maxPromote = 0, --Can't Promote
            maxDemote = 0, --Can't Demote
            -- If they could promote, a number of 2 would mean they could promot eup to rank two, like from trainee to spc (trainee, pvt, spc etc)
            rankIcon = "", --Not needed
            weapons = {"re_hands"},
            commands = {}, --This could be used to allow users access to special commands on job specific
        },
    },
}

ResistanceRP.Factions["FR"] = {
    idName = "FR",
    dName = "French Resistance", --dName is DisplayName
    icon = "4mj3JDy",
    description = "Viva la France",
    SubFactions = {
        ["FRN"] = {
            parentFactionID = "FR",
            idName = "FRN",
            dName = "French Resistance",
            description = "Viva la France",
            icon = "p2gUJDf",
            ranks = {},
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
        },
        ["FRC"] = {
            parentFactionID = "FR",
            idName = "FRC",
            dName = "French Communist Resistance",
            description = "Viva la France but shite",
            icon = "p2gUJDf",
            ranks = {},
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
        },
    },
}

ResistanceRP.Factions["CIV"] = {
    idName = "CIV",
    dName = "Civilian", --dName is DisplayName
    icon = "p2gUJDf",
    description = "Lemme live",
    SubFactions = {
        ["CIVC"] = {
            parentFactionID = "CIV",
            idName = "CIVC",
            dName = "Collaborationist",
            description = "Traitor to your land",
            icon = "p2gUJDf",
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
        },
        ["CIVR"] = {
            parentFactionID = "CIV",
            idName = "CIVR",
            dName = "Regular Civilian",
            description = "Just Getting By",
            icon = "p2gUJDf",
            playerModels = {
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_01.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_02.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_03.mdl", 
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_04.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_05.mdl",
                "models/hts/comradebear/pm0v3/player/heer/infantry/en/m36_s1_06.mdl",
            },
        },
    },
}