-- Define ResistanceRP table if not already defined
local ResistanceRP = ResistanceRP or {}
ResistanceRP.Client = ResistanceRP.Client or {} -- Initialize Client table if not already initialized
ResistanceRP.LoadedImages = ResistanceRP.LoadedImages or {} -- Initialize LoadedImages table if not already initialized

-- Create necessary directories if they do not exist
file.CreateDir("resistancerp")
file.CreateDir("resistancerp/images/")

-- Function to clear all panels from the world panel
local function ClearAllPanels()
    for _, panel in ipairs(vgui.GetWorldPanel():GetChildren()) do
        if IsValid(panel) and panel:IsVisible() then
            panel:Remove()
        end
    end
end

-- Function to set up introduction panel
local function SetupIntroduction()
    vgui.Create("ResistanceRP.Introduction")
end

-- Function to load main menu panel
local function LoadMainMenu()
    vgui.Create("ResistanceRP.MainMenu")
end

-- Function to fetch image from URL
local function FetchImage(id, callback, instant)
	local loadedImage = ResistanceRP.LoadedImages[id]
	if (loadedImage) then
		callback(loadedImage)
		return
	end

	if (file.Exists("resistancerp/images/" .. id .. ".png", "DATA")) then
		local mat = Material("data/resistancerp/images/"..id..".png", "noclamp smooth")
        if (!mat) then
			-- prevent memory leaks
			mat = Material("content/materials/models/player/black.vtf")
		end
		ResistanceRP.LoadedImages[id] = mat
        callback(mat)
	else
		http.Fetch("https://i.imgur.com/" .. id .. ".png", function (body, size, headers, code)
			if (code != 200) then
				callback(false)
				return
			end

			if (!body or body == "") then 
				callback(false)
				return 
			end


			file.Write("resistancerp/images/" .. id .. ".png", body)
			local mat = Material("data/resistancerp/images/"..id..".png", "noclamp smooth")
			ResistanceRP.LoadedImages[id] = mat
			if (!instant) then
				callback(mat)
			end
		end, function ()
			callback(false)
		end)
	end
end

-- Function to set material for an image panel from image ID
function ResistanceRP.GetMaterialFromImage(icon, val)
    icon:SetMaterial(nil)
    if #val > 3 then
        FetchImage(val, function(mat)
            if mat then
                icon:SetMaterial(mat)
            end
        end)
    end
end

-- List of HUD elements to be disabled
local disabledHUD = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
}

function GM:InitPostEntity()
    net.Start("ResistanceRP.CreateNewUser")
    net.SendToServer()
end

-- Hook to control visibility of HUD elements
hook.Add("HUDShouldDraw", "HideDisabledHUD", function(name)
    if disabledHUD[name] then
        return false
    end
end)

-- Function to handle receiving debug remove panels message
local function OnReceiveDebugRemovePanels()
    ClearAllPanels()
end

-- Function to handle receiving load main menu message
local function OnReceiveLoadMainMenu()
    LoadMainMenu()
end

-- Function to handle receiving player info message
local function OnReceiveSendPlayerInfo()
    ResistanceRP.Client = net.ReadTable()
    if ResistanceRP.Client.playIntroduction then
        LoadMainMenu()
        SetupIntroduction()
    else
        LoadMainMenu()
    end
end

-- Listen for network messages and attach appropriate handlers
net.Receive("ResistanceRP.Debug.RemovePanels", OnReceiveDebugRemovePanels)
net.Receive("ResistanceRP.LoadMainMenu", OnReceiveLoadMainMenu)
net.Receive("ResistanceRP.SendPlayerInfo", OnReceiveSendPlayerInfo)
