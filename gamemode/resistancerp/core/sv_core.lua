-- Define ResistanceRP table if not already defined
ResistanceRP = ResistanceRP or {}
ResistanceRP.Players = ResistanceRP.Players or {} -- Initialize Players table if not already initialized

-- Hook to initialize data retrieval when server starts
hook.Add("Initialize", "ResistanceRP.DataRetrevial", function()
    local query = db:query("CREATE TABLE IF NOT EXISTS RRP_Players (playerID VARCHAR(17) PRIMARY KEY, characters TEXT)")
    query:start()
    -- Query to retrieve player data from the database
    local query = db:query("SELECT * FROM RRP_Players")

    -- Callback function executed on query success
    function query:onSuccess(data)
        -- Iterate over retrieved data
        for _, row in ipairs(data) do
            -- Create player data table
            local playerData = {
                playerID = row.playerID,
                characters = util.JSONToTable(row.characters), -- Convert JSON string to Lua table
                playIntroduction = false
            }
            -- Store player data in Players table
            ResistanceRP.Players[row.playerID] = playerData
        end
    end
    -- Callback function executed on query error
    function query:onError(err, sql)
        print("Query errored!")
        print("Query:", sql)
        print("Error:", err)
    end

    -- Execute the query
    query:start()
end)

-- Function to create a character for a player
local function CreateCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
    -- Check if all required character details are provided
    if not name or not age or not eyeColor or not bloodType or not hairColor or not description or not playerModel then
        ply:ChatPrint("Please fill in all character details.")
        return
    end

    -- Check if the name is properly formatted (at least two words)
    local nameWords = {}
    for word in name:gmatch("%S+") do
        table.insert(nameWords, word)
    end
    if #nameWords < 2 then
        ply:ChatPrint("Please enter a full name (First and Last name).")
        return
    end

    -- Check if the player has reached the maximum number of characters allowed
    if ResistanceRP.Players[ply:SteamID64()].characters and table.Count(ResistanceRP.Players[ply:SteamID64()].characters) >= ResistanceRP.Configuration.MaxCharacters then
        ply:ChatPrint("You have reached the maximum number of characters allowed.")
        return
    end

    -- Check if the player already has a character with the same name
    if ResistanceRP.Players[ply:SteamID64()].characters and ResistanceRP.Players[ply:SteamID64()].characters[name] then
        ply:ChatPrint("You already have a character with that name.")
        return
    end

    -- Check if the description is at least 50 characters long
    if #description < 50 then
        ply:ChatPrint("Description must be at least 50 characters long.")
        return
    end

    -- Create character data
    local character = {
        charName = name,
        charAge = age,
        charEye = eyeColor,
        charBlood = bloodType,
        charHair = hairColor,
        charDesc = description,
        charPlayermodel = playerModel,
        charFaction = faction,
        currentlyActiveCharacter = true,
    }

    -- Add character to player's characters
    ResistanceRP.Players[ply:SteamID64()].characters[name] = character
    ResistanceRP.Players[ply:SteamID64()].activeCharacter = character

    -- Update database with new character data
    local query = db:query("UPDATE RRP_Players SET characters = '"..db:escape(util.TableToJSON(ResistanceRP.Players[ply:SteamID64()].characters)).."' WHERE playerID = '"..db:escape(ply:SteamID64()).."'")
    function query:onError(err, sql)
        print("Query errored!")
        print("Query:", sql)
        print("Error:", err)
    end
    query:start()
end

-- Function to spawn a character for a player
local function SpawnCharacter(ply, name, age, eyeColor, bloodType, hairColor, description, playerModel, faction)
    ResistanceRP.Print(ply:SteamID64().." is currently playing as ".. name)
    PrintTable(ResistanceRP.Players[ply:SteamID64()].characters[name])
end

-- Hook to handle player chat commands
hook.Add("PlayerSay", "ResistanceRP.ChatCommands", function(ply, text)
    -- Handle "!intro" command
    if string.lower(text) == "!intro" then
        net.Start("ResistanceRP.PlayIntroduction")
        net.Send(ply)
        return ""
    end
    -- Handle "!clearpanels" command
    if string.lower(text) == "!clearpanels" then
        net.Start("ResistanceRP.Debug.RemovePanels")
        net.Send(ply)
        return ""
    end
    -- Handle "!mainmenu" command
    if string.lower(text) == "!mainmenu" then
        net.Start("ResistanceRP.LoadMainMenu")
        net.Send(ply)
        return ""
    end
end)

-- Network message handler to load main menu for a player
net.Receive("ResistanceRP.LoadMainMenu", function(len, ply)
    net.Start("ResistanceRP.LoadMainMenu")
    net.Send(ply)
end)

-- Network message handler to create a character for a player
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
end)

-- Network message handler to create a new user
net.Receive("ResistanceRP.CreateNewUser", function(len, ply)
    local steamID64 = ply:SteamID64()

    -- Check if the player is not already in the Players table
    if not ResistanceRP.Players[steamID64] then
        ResistanceRP.Print("Player is in the table")
        -- Initialize player data
        ResistanceRP.Players[steamID64] = {
            playerID = steamID64,
            characters = {},
            playIntroduction = true,
        }
        
        -- Insert player data into the database
        local query = db:query("INSERT INTO RRP_Players (playerID, characters) VALUES ('"..steamID64.."', '{}')")
        function query:onError(err, sql)
            print("Query errored!")
            print("Query:", sql)
            print("Error:", err)
        end
        query:start()
    end

    -- Send player info to the player
    net.Start("ResistanceRP.SendPlayerInfo")
    net.WriteTable(ResistanceRP.Players[ply:SteamID64()])
    net.Send(ply)
end)
