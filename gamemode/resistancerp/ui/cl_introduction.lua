local PANEL = {}

function PANEL:PlayIntroduction(text)
    -- Fade out the initial text
    text:AlphaTo(0, 2, 2, function()
        -- Update text to server name
        text:SetText(ResistanceRP.Configuration.ServerName)
        text:SizeToContents()  -- Adjust size to fit the new text
        text:SetPos((self:GetWide() - text:GetWide()) / 2, (self:GetTall() - text:GetTall()) / 2)
        -- Fade in the updated text
        text:AlphaTo(255, 1, 1, function()
            -- Fade out the panel
            self:AlphaTo(0, 3, 2, function()
                self:Remove()  -- Remove the panel after fading out
            end)
            -- Fade out the text
            text:AlphaTo(0, 2.5, 1, function()
                text:Remove()  -- Remove the text after fading out
            end)
        end)
    end)
end

function PANEL:Init()
    local soundObject = CreateSound(LocalPlayer(), ResistanceRP.Configuration.ServerIntroSong)
    soundObject:Play()
    ResistanceRP.Client.Playing = soundObject
    
    --Introduction Sequence
    self:SetSize(ScrW(), ScrH())  -- Set panel size to screen size
    self:Center()  -- Center the panel on the screen
    self:SetBackgroundColor(ResistanceRP.Colors.Black)  -- Set background color

    -- Create a label for displaying text
    local text = vgui.Create("DLabel", self)
    text:SetText("Cordite Development Presents")
    text:SetFont("ResistanceRP.36N")
    text:SizeToContents()  -- Adjust size to fit the text
    text:SetPos((self:GetWide() - text:GetWide()) / 2, (self:GetTall() - text:GetTall()) / 2)  -- Center the text

    self:PlayIntroduction(text)  -- Start the introduction sequence
end

-- Register the panel type
vgui.Register("ResistanceRP.Introduction", PANEL, "DPanel")
