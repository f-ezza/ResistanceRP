ResistanceRP.Client = ResistanceRP.Client or {}
ResistanceRP.LoadedImages = ResistanceRP.LoadedImages or {}
file.CreateDir("resistancerp")
file.CreateDir("resistancerp/images")

--Local Functions
local function ClearAllPanels()
    for _, panel in pairs(vgui.GetWorldPanel():GetChildren()) do
        if IsValid(panel) and panel:IsVisible() then
            panel:Remove()
        end
    end
end

local function SetupIntroduction()
    local introduction = vgui.Create("ResistanceRP.Introduction")
end

local function LoadMainMenu()
    local mainMenu = vgui.Create("ResistanceRP.MainMenu")
end

function ResistanceRP.FetchImage(id, callback, instant)
	local loadedImage = ResistanceRP.LoadedImages[id]
	if (loadedImage) then
		callback(loadedImage)
		return
	end

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
        local mat = Material("data/resistancerp/images/" .. id .. ".png", "noclamp smooth")
        ResistanceRP.LoadedImages[id] = mat
        if (!instant) then
            callback(mat)
        end
    end, function ()
        callback(false)
    end)
end

function ResistanceRP.GetMaterialFromImage(icon, val)
    icon:SetMaterial(nil)
    if (#val > 3) then
        ResistanceRP.FetchImage(val, function (mat)
            if (!mat) then return end
            icon:SetMaterial(mat)
        end)
    end
end

function GM:InitPostEntity()
    ResistanceRP.Print("Loaded!")
    net.Start("ResistanceRP.CreateNewUser")
    net.SendToServer()
end

local disabledHUD = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
}

-- Define the HUDShouldDraw hook function
hook.Add("HUDShouldDraw", "HideDisabledHUD", function(name)
    -- Check if the current HUD element should be disabled
    if disabledHUD[name] then
        return false
    end
end)

net.Receive("ResistanceRP.Debug.RemovePanels", ClearAllPanels)
net.Receive("ResistanceRP.LoadMainMenu", LoadMainMenu)
net.Receive("ResistanceRP.SendPlayerInfo", function()
    ResistanceRP.Client = net.ReadTable()
    if(ResistanceRP.Client.playIntroduction) then
        LoadMainMenu()
        SetupIntroduction()
    else
        LoadMainMenu()
    end
end)