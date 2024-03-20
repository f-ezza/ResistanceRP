local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()
    self:SetBackgroundColor(ResistanceRP.Colors.Background)

    local headerText = vgui.Create("DLabel", self)
    headerText:SetText("ResistanceRP 1943")
    headerText:SetFont("ResistanceRP.36N")
    headerText:SizeToContents()
    headerText:SetPos(ScrW() * 0.025, ScrH() * 0.05)

    local secondaryHeaderText = vgui.Create("DLabel", self)
    secondaryHeaderText:SetText("Create Character")
    secondaryHeaderText:SetFont("ResistanceRP.32N")
    secondaryHeaderText:SizeToContents()
    secondaryHeaderText:SetPos(ScrW() * 0.025, ScrH() * 0.1)

    local characterSlotContainer = vgui.Create("DPanel", self)
    characterSlotContainer:SetSize(ScrW() * 0.85, ScrH() * 0.70)
    characterSlotContainer:Center()
    characterSlotContainer:SetBackgroundColor(ResistanceRP.Colors.BackgroundSecondary)

    -- Calculate the button width to fill the container horizontally with spacing
    local buttonWidth = (characterSlotContainer:GetWide() - 15 * 4) / 3 -- Adjust spacing as necessary
    local iconVerticalPos = (characterSlotContainer:GetTall() - 32) / 2 -- Adjust 32 to the actual height of the icon


    -- Add a for loop to create three buttons horizontally
    for i = 1, 3 do
        local characterSlotButton = vgui.Create("DButton", characterSlotContainer)
        characterSlotButton:SetText("New Character")
        characterSlotButton:SetFont("ResistanceRP.34N")
        characterSlotButton:SetWide(buttonWidth) -- Set button width
        characterSlotButton:Dock(LEFT) -- Dock buttons to the left side of the container
        characterSlotButton:DockMargin(15, 15, 0, 15) -- Add spacing between buttons
        characterSlotButton:SetTextInset(0, -300) -- Set text inset
        characterSlotButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Background color
            surface.SetDrawColor(ResistanceRP.Colors.Border)
            surface.DrawOutlinedRect(0, 0, w, h, 2) -- Border
        end
        characterSlotButton.DoClick = function()
            local characterCreator = vgui.Create("ResistanceRP.CharacterCreator")
            self:Remove()
            ResistanceRP.Print("Loading Character Creator")
        end

        local iconImage = vgui.Create("DImage", characterSlotButton)
        iconImage:SetSize(64, 64) -- Set icon size
        iconImage:SetPos((buttonWidth - 64) / 2, iconVerticalPos) -- Center the icon horizontally and vertically
        iconImage:SetImage("materials/ui/icons/rrp_cordite_ps.png")
    end
end

vgui.Register("ResistanceRP.CharacterMenu", PANEL, "DPanel")