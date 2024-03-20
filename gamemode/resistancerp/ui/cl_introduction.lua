local PANEL = {}

function PANEL:PlayIntroduction(text)
    text:AlphaTo(0, 2, 2, function()
        text:SetText(ResistanceRP.Configuration.ServerName)
        text:SizeToContents()
        text:SetPos((self:GetWide() - text:GetWide()) / 2, (self:GetTall() - text:GetTall()) / 2)
        text:AlphaTo(255, 1, 1, function()
            self:AlphaTo(0, 3, 2, function()
                self:Remove()
            end)
            text:AlphaTo(0, 2.5, 1, function()
                text:Remove()
            end)
        end)
    end)
end

function PANEL:Init()
    local soundObject = CreateSound(LocalPlayer(), ResistanceRP.Configuration.ServerIntroSong)
    soundObject:Play()
    ResistanceRP.Client.Playing = soundObject
    
    --Introduction Sequence
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetBackgroundColor(ResistanceRP.Colors.Black)

    local text = vgui.Create("DLabel", self)
    text:SetText("Cordite Development Presents")
    text:SetFont("ResistanceRP.36N")
    
    text:SizeToContents()  -- Adjust size to fit the text
    text:SetPos((self:GetWide() - text:GetWide()) / 2, (self:GetTall() - text:GetTall()) / 2)

    self:PlayIntroduction(text)
end

vgui.Register("ResistanceRP.Introduction", PANEL, "DPanel")
