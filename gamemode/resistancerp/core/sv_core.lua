ResistanceRP.Players = ResistanceRP.Players or {}

hook.Add("Initialize", "ResistanceRP.DataRetrevial", function()
    local query = db:query("SELECT * FROM RRP_Players")
    function query:onSuccess( data )
        for _, row in ipairs(data) do
            local playerData = {
                playerID = row.playerID,
                characters = util.JSONToTable(row.characters), -- Convert JSON string to Lua table
                playIntroduction = row.playIntroduction
            }
            ResistanceRP.Players[row.playerID] = playerData
        end
    end
    function query:onError( err, sql )
        print( "Query errored!" )
        print( "Query:", sql )
        print( "Error:", err )
    end
    query:start()
end)

local function CreateCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
    -- Check if the player has provided all required data
    if not name or not age or not eyeColor or not bloodType or not hairColor or not description or not playerModel then
        ply:ChatPrint("Please fill in all character details.")
        return
    end

    -- Check if the name is formatted properly (at least two words)
    local nameWords = {}
    for word in name:gmatch("%S+") do
        table.insert(nameWords, word)
    end
    if #nameWords < 2 then
        ply:ChatPrint("Please enter a full name (First and Last name).")
        return
    end

    -- Check if the player has already reached the maximum number of characters allowed
    local maxCharacters = 5 -- Example: Maximum number of characters allowed per player
    if ResistanceRP.Players[ply:SteamID64()].characters and table.Count(ResistanceRP.Players[ply:SteamID64()].characters) >= maxCharacters then
        ply:ChatPrint("You have reached the maximum number of characters allowed.")
        return
    end

    if ResistanceRP.Players[ply:SteamID64()].characters and ResistanceRP.Players[ply:SteamID64()].characters[name] then
        ply:ChatPrint("You already have a character with that name.")
        return
    end

    if #description < 50 then
        ply:ChatPrint("Description must be at least 50 characters long.")
        return
    end

    local character = {
        charName = name,
        charAge = age,
        charEye = eyeColor,
        charBlood = bloodType,
        charHair = hairColor,
        charDesc = description,
        charPlayermodel = playerModel,
        charFaction = faction,
    }
    ResistanceRP.Players[ply:SteamID64()].characters[name] = character
    local query = db:query("UPDATE RRP_Players SET characters = '"..db:escape(util.TableToJSON(ResistanceRP.Players[ply:SteamID64()].characters)).."' WHERE playerID = '"..db:escape(ply:SteamID64()).."'")
    function query:onError( err, sql )
        print( "Query errored!" )
        print( "Query:", sql )
        print( "Error:", err )
    end
    query:start()
end

local function SpawnCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
    ply:Spawn()
end

--Chat Commands
hook.Add( "PlayerSay", "ResistanceRP.ChatCommands", function( ply, text )
	if ( string.lower( text ) == "!intro" ) then
        net.Start("ResistanceRP.PlayIntroduction")
        net.Send(ply)
		return ""
	end
    if(string.lower(text) == "!clearpanels") then
        net.Start("ResistanceRP.Debug.RemovePanels")
        net.Send(ply)
        return ""
    end
    if(string.lower(text) == "!mainmenu") then
        net.Start("ResistanceRP.LoadMainMenu")
        net.Send(ply)
        return ""
    end
end )


net.Receive("ResistanceRP.LoadMainMenu", function(len, ply)
    net.Start("ResistanceRP.LoadMainMenu")
    net.Send(ply)
end)

net.Receive("ResistanceRP.CreateCharacter", function(len, ply)
    local name = net.ReadString()
    local age = net.ReadInt(8) -- Read age from the client
    local eyeColor = net.ReadString()
    local bloodType = net.ReadString()
    local hairColor = net.ReadString()
    local description = net.ReadString()
    local playerModel = net.ReadString()
    local faction = net.ReadString()
    CreateCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
    SpawnCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
end)

net.Receive("ResistanceRP.CreateNewUser", function(len, ply)
    local steamID64 = ply:SteamID64()

    if not ResistanceRP.Players[steamID64] then
        ResistanceRP.Players[steamID64] = {
            playerID = steamID64,
            characters = {},
            playIntroduction = true,
        }
        
        local query = db:query("INSERT INTO RRP_Players (playerID, characters, playIntroduction) VALUES ('"..steamID64.."', '{}', '"..tostring(0).."')")
        function query:onError( err, sql )
            print( "Query errored!" )
            print( "Query:", sql )
            print( "Error:", err )
    
        end
        query:start()
    end
    net.Start("ResistanceRP.SendPlayerInfo")
        net.WriteTable(ResistanceRP.Players[ply:SteamID64()])
    net.Send(ply)
end)