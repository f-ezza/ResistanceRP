GM.Name = "ResistanceRP"
GM.Author = "Cordite Development"
GM.Email = "corditedevelopment@gmail.com"
GM.Website = "corditedevelopment.com"

DeriveGamemode("sandbox")

--Table Creation
ResistanceRP = ResistanceRP or {}
ResistanceRP.Configuration = ResistanceRP.Configuration or {}
ResistanceRP.Colors = ResistanceRP.Colors or {}
--Colors & Fonts
ResistanceRP.Colors = {
    --Feedback Colors
    Success = Color(76, 175, 80),        
    Error = Color(255, 87, 34),          
    Print = Color(255, 235, 59),         
    Header = Color(0,0,200),

    --UI
    Background = Color(18, 18, 18),
    BackgroundSecondary = Color(33, 33, 33), 
    Border = Color(0, 50, 200),
    Text = Color(255, 255, 255), 
	Disabled = Color(50,50,50,100),    
	
	--Solid Colors
	Black = Color(10,10,10),
}


--Global Functions
function ResistanceRP.Print(...)
    MsgC(ResistanceRP.Colors.Header, "[ResistanceRP] ", ResistanceRP.Colors.Text, ... .. "\n")
end

function DirectoryLoad(scanDirectory, isGamemode )
	isGamemode = isGamemode or false
	
	local queue = { scanDirectory }
	
	while #queue > 0 do
		for _, directory in pairs( queue ) do
			local files, directories = file.Find( directory .. "/*", "LUA" )
            
			for _, fileName in pairs( files ) do
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					local relativePath = directory .. "/" .. fileName
					if isGamemode then
						relativePath = string.gsub( directory .. "/" .. fileName, GM.FolderName .. "/gamemode/", "" )
					end
					
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			
			for _, subdirectory in pairs( directories ) do
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			
			table.RemoveByValue( queue, directory )
		end
	end
end
DirectoryLoad( GM.FolderName .. "/gamemode", true )

local function CreateFactions()
	for faction, factionData in pairs(ResistanceRP.Factions) do
        ResistanceRP.Print(factionData.dName)
    end
end

--Initalization
function GM:Initialize()
    ResistanceRP.Print("Gamemode initalization started")
	CreateFactions()
end
