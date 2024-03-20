local PANEL = {}
local customView = true

function PANEL:Init()
    -- Set up rendering hook to render the world from a fixed position
    hook.Add("CalcView", "ResistanceRP.MainMenuCamera", function(ply, pos, angles, fov)
        if customView then
            local cameraPos = Vector(x, y, z) -- Set the position of the virtual camera
            local cameraAngles = Angle(pitch, yaw, roll) -- Set the angles of the virtual camera

            local view = {}
            view.origin = cameraPos
            view.angles = cameraAngles
            view.fov = fov

            return view
        else
            return {
                origin = pos,
                angles = angles,
                fov = fov
            }
        end
    end)

    self:SetSize(ScrW(), ScrH())
    self:SetBackgroundColor(Color(0, 0, 0, 0))
    self:MakePopup()

    -- Function to handle button clicks
    local function ButtonClicked(buttonText)
        if buttonText == "Load Character" then
            self:Remove()
            if(ResistanceRP.Client.Playing != nil) then ResistanceRP.Client.Playing:Stop() end
            customView = false
        elseif buttonText == "New Character" then
            local createCharacterPanel = vgui.Create("ResistanceRP.CharacterMenu")
            self:Remove()
            customView = false
        elseif buttonText == "Content" then
            -- Handle Content action (open a link)
            gui.OpenURL("https://discord.gg/sEAg3MkPn5")  -- Replace "http://example.com" with your desired URL
        elseif buttonText == "Exit" then
            -- Handle Exit action (disconnect the user)
            RunConsoleCommand("disconnect")
        end
    end

    -- List of buttons
    local buttonLabels = {"Exit", "Content", "New Character", "Load Character"}

    local backingImage = vgui.Create("DImage", self)
    backingImage:SetSize(ScrW(), ScrH())
    backingImage:Center()
    backingImage:SetMaterial(ResistanceRP.GetMaterialFromImage(backingImage, "jQD3UKx"))

    local logo = vgui.Create("DImage", self)
    logo:SetSize(500, 500)
    logo:SetPos(0, (ScrH() - logo:GetTall()) / 2)
    logo:SetMaterial(ResistanceRP.GetMaterialFromImage(logo, "sPwTrhU"))

    local buttonWidth = 200
    local buttonHeight = 30
    local buttonMargin = 30

    local imageX, imageY = logo:GetPos()
    local imageWidth = logo:GetWide()
    local buttonX = imageX + (imageWidth - buttonWidth) / 2
    local startY = ScrH() * 0.85 - buttonHeight - buttonMargin
    
    -- Create buttons centered under the image
    for i, labelText in ipairs(buttonLabels) do
        local button = vgui.Create("DButton", self)
        button:SetText(labelText)
        button:SetFont("ResistanceRP.30N") -- Use a default font
        button:SetTextColor(ResistanceRP.Colors.Text)
        button:SetSize(buttonWidth, buttonHeight)
        button:SetPos(buttonX, startY - (buttonHeight + buttonMargin) * (i - 1))
        if(ResistanceRP.Client.characters == nil && labelText == "Load Character") then
            button:SetEnabled(false)
        end
        button.Paint = function(self, w, h)
            if self:IsHovered() && button:IsEnabled() then
                button:SetTextColor(ResistanceRP.Colors.Border)
            elseif !button:IsEnabled() then
                button:SetTextColor(ResistanceRP.Colors.Disabled)
            else
                button:SetTextColor(ResistanceRP.Colors.Text)
            end
        end
        button.DoClick = function()
            ButtonClicked(labelText)
        end
    end

    if(ResistanceRP.Client.playIntroduction) then
        local fadePanel = vgui.Create("DPanel")
        fadePanel:SetSize(ScrW(), ScrH())
        fadePanel:SetBackgroundColor(ResistanceRP.Colors.Black)

        self:SetAlpha(0) -- Set initial alpha to 0
        self:AlphaTo(255, 1, 8, function()
            -- Fade-in animation complete callback
        end)

        fadePanel:SetAlpha(255) -- Set initial alpha to 0
        fadePanel:AlphaTo(0, 1, 8, function()
            -- Fade-in animation complete callback
        end)
    end
end

vgui.Register("ResistanceRP.MainMenu", PANEL, "DPanel")
