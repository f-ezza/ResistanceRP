-- Define a new panel named "ResistanceRP.CharacterCreator" inheriting from "DPanel"
local PANEL = {}

-- Initialize the panel
function PANEL:Init()
    -- Set the size of the panel to cover the entire screen
    self:SetSize(ScrW(), ScrH())
    -- Center the panel on the screen
    self:Center()
    -- Make the panel appear on top of other panels
    self:MakePopup()
    -- Set the background color of the panel
    self:SetBackgroundColor(ResistanceRP.Colors.Background)

    -- Create and configure header text
    local headerText = vgui.Create("DLabel", self)
    headerText:SetText("ResistanceRP 1943")
    headerText:SetFont("ResistanceRP.36N")
    headerText:SizeToContents()
    headerText:SetPos(ScrW() * 0.025, ScrH() * 0.05)

    -- Create and configure secondary header text
    local secondaryHeaderText = vgui.Create("DLabel", self)
    secondaryHeaderText:SetText("Character Creator")
    secondaryHeaderText:SetFont("ResistanceRP.32N")
    secondaryHeaderText:SizeToContents()
    secondaryHeaderText:SetPos(ScrW() * 0.025, ScrH() * 0.1)

    -- Create a container for character slots
    local characterSlotContainer = vgui.Create("EditablePanel", self)
    characterSlotContainer:SetSize(ScrW() * 0.85, ScrH() * 0.70)
    characterSlotContainer:Center()
    characterSlotContainer:MakePopup()
    characterSlotContainer.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.BackgroundSecondary)
    end

    -- Display factions in the character slot container
    self:DisplayFactions(characterSlotContainer)
end

-- Function to display factions
function PANEL:DisplayFactions(characterSlotContainer)
    -- Calculate button width to fill the container horizontally with spacing
    local buttonWidth = (characterSlotContainer:GetWide() - 15 * 4) / 3

    -- Iterate over factions and create buttons for each
    for faction, factionData in pairs(ResistanceRP.Factions) do
        -- Create a panel for the faction button
        local characterSlotButton = vgui.Create("DPanel", characterSlotContainer)
        characterSlotButton:SetWide(buttonWidth)
        characterSlotButton:Dock(LEFT)
        characterSlotButton:DockMargin(15, 15, 0, 15)
        
        -- Create label for faction name
        local buttonText = vgui.Create("DLabel", characterSlotButton)
        buttonText:SetText(factionData.dName)
        buttonText:SetFont("ResistanceRP.34N")
        buttonText:SizeToContents()
        buttonText:SetContentAlignment(5)
        buttonText:Dock(TOP)
        buttonText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background)
        end

        -- Create icon button for faction
        local iconButton = vgui.Create("DImageButton", characterSlotButton)
        iconButton:Dock(FILL)
        ResistanceRP.GetMaterialFromImage(iconButton, factionData.icon)
        iconButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background)
        end

        -- Define behavior when the faction button is clicked
        iconButton.DoClick = function()
            if(factionData.SubFactions != nil) then
                characterSlotContainer:Clear()
                self:DisplaySubFactions(characterSlotContainer, factionData.SubFactions)
            else
                characterSlotContainer:Clear()
                self:CreateNewCharacter(factionData, characterSlotContainer)
            end
        end
    end
end

-- Function to display sub-factions
function PANEL:DisplaySubFactions(characterSlotContainer, subFactions)
    -- Calculate button width to fill the container horizontally with spacing
    local buttonWidth = (characterSlotContainer:GetWide() - 15 * 4) / 2

    -- Iterate over sub-factions and create buttons for each
    for faction, factionData in pairs(subFactions) do
        -- Create a panel for the sub-faction button
        local characterSlotButton = vgui.Create("DPanel", characterSlotContainer)
        characterSlotButton:SetWide(buttonWidth)
        characterSlotButton:Dock(LEFT)
        characterSlotButton:DockMargin(15, 15, 0, 15)
        
        -- Create label for sub-faction name
        local buttonText = vgui.Create("DLabel", characterSlotButton)
        buttonText:SetText(factionData.dName)
        buttonText:SetFont("ResistanceRP.34N")
        buttonText:SizeToContents()
        buttonText:SetContentAlignment(5)
        buttonText:Dock(TOP)
        buttonText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background)
        end

        -- Create icon button for sub-faction
        local iconButton = vgui.Create("DImageButton", characterSlotButton)
        iconButton:Dock(FILL)
        ResistanceRP.GetMaterialFromImage(iconButton, factionData.icon)
        iconButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background)
        end

        -- Define behavior when the sub-faction button is clicked
        iconButton.DoClick = function()
            characterSlotContainer:Clear()
            self:CreateNewCharacter(factionData, characterSlotContainer)
        end
    end
end

-- Function to create a new character
function PANEL:CreateNewCharacter(factionData, characterSlotContainer)
    PrintTable(factionData)
    -- Create form panel for character details
    local formPanel = vgui.Create("EditablePanel", characterSlotContainer)
    formPanel:SetWide(characterSlotContainer:GetWide() * 0.575)
    formPanel:Dock(LEFT)
    formPanel:DockMargin(10, 10, 10, 10)
    formPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background)
    end

    -- Create model panel for character preview
    local modelPanel = vgui.Create("DPanel", characterSlotContainer)
    modelPanel:SetWide(characterSlotContainer:GetWide() * 0.4)
    modelPanel:Dock(RIGHT)
    modelPanel:DockMargin(10, 10, 10, 10)
    modelPanel:SetBackgroundColor(ResistanceRP.Colors.Background)

    -- Create form inputs for character attributes
    local nameLabel = vgui.Create("DLabel", formPanel)
    nameLabel:SetText("Name:")
    nameLabel:SetFont("ResistanceRP.24N")
    nameLabel:SetTextColor(ResistanceRP.Colors.Text)
    nameLabel:Dock(TOP)
    nameLabel:DockMargin(15, 15, 15, 0)
    
    local nameEntry = vgui.Create("DTextEntry", formPanel)
    nameEntry:Dock(TOP)
    nameEntry:DockMargin(15,5,250,15)
    nameEntry:SetPlaceholderText("John Smith")
    nameEntry:SetFont("ResistanceRP.24N")
    nameEntry:SetTextColor(ResistanceRP.Colors.Text)
    nameEntry:SetPlaceholderColor(ResistanceRP.Colors.Text)
    nameEntry:SetNumeric(false)
    nameEntry.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.BackgroundSecondary) 
        surface.SetDrawColor(ResistanceRP.Colors.Border) -- Set color for the underline
        surface.DrawRect(0, h - 2, w, 2) -- Draw the underline
        self:DrawTextEntryText(ResistanceRP.Colors.Text,ResistanceRP.Colors.Text,ResistanceRP.Colors.Text)
    end

    local ageLabel = vgui.Create("DLabel", formPanel)
    ageLabel:SetText("Age:")
    ageLabel:SetFont("ResistanceRP.24N")
    ageLabel:SetTextColor(ResistanceRP.Colors.Text)
    ageLabel:Dock(TOP)
    ageLabel:DockMargin(15,15,15,0)

    local ageEntry = vgui.Create("DTextEntry", formPanel)
    ageEntry:Dock(TOP)
    ageEntry:DockMargin(15,5,250,15)
    ageEntry:SetFont("ResistanceRP.24N")
    ageEntry:SetTextColor(ResistanceRP.Colors.Text)
    ageEntry:SetPlaceholderColor(ResistanceRP.Colors.Text)
    ageEntry:SetNumeric(true)
    ageEntry:SetMaximumCharCount(2)
    ageEntry.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.BackgroundSecondary) 
        surface.SetDrawColor(ResistanceRP.Colors.Border) -- Set color for the underline
        surface.DrawRect(0, h - 2, w, 2) -- Draw the underline
        self:DrawTextEntryText(ResistanceRP.Colors.Text,ResistanceRP.Colors.Text,ResistanceRP.Colors.Text)
    end
    
    -- Function to create a block
    local function CreateBlock(parent, labelText, choices)
        
        local label = vgui.Create("DLabel", parent)
        label:SetText(labelText)
        label:SetFont("ResistanceRP.24N")
        label:SetTextColor(ResistanceRP.Colors.Text)
        label:SizeToContents() -- Adjust height to fit the text
        label:Dock(TOP)
        label:DockMargin(15,15,15,0)
        
        local comboBox = vgui.Create("DComboBox", parent)
        comboBox:Dock(TOP)
        comboBox:DockMargin(15,5,250,15)
        comboBox:SetFont("ResistanceRP.24N")
        comboBox:SetTextColor(ResistanceRP.Colors.Text)
        for _, choice in ipairs(choices) do
            comboBox:AddChoice(choice)
        end
        comboBox.Paint = function(self, w, h)
            surface.SetDrawColor(ResistanceRP.Colors.Border) -- Set color for the underline
            surface.DrawRect(0, h - 2, w, 2) -- Draw the underline
        end
    
        return comboBox
    end
    local eyeColorComboBox = CreateBlock(formPanel, "Eye Color:", {"Blue", "Brown", "Green", "Dark Brown", "Hazelnut"})
    local bloodTypeComboBox = CreateBlock(formPanel, "Blood Type:", {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"})
    local hairColorComboBox = CreateBlock(formPanel, "Hair Color:", {"Blonde", "Brown", "Black", "Red", "Gray"})

    local descriptionLabel = vgui.Create("DLabel", formPanel)
    descriptionLabel:SetText("Description:")
    descriptionLabel:SetFont("ResistanceRP.24N")
    descriptionLabel:SetTextColor(ResistanceRP.Colors.Text)
    descriptionLabel:Dock(TOP)
    descriptionLabel:DockMargin(15,15,15,0)

    local descriptionEntry = vgui.Create("DTextEntry", formPanel)
    descriptionEntry:Dock(TOP)
    descriptionEntry:DockMargin(15,5,250,15)
    descriptionEntry:SetFont("ResistanceRP.24N")
    descriptionEntry:SetTextColor(ResistanceRP.Colors.Text)
    descriptionEntry:SetPlaceholderColor(ResistanceRP.Colors.Text)
    descriptionEntry:SetMultiline(true)
    descriptionEntry:SetTall(200)
    descriptionEntry.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.BackgroundSecondary) 
        surface.SetDrawColor(ResistanceRP.Colors.Border) -- Set color for the underline
        surface.DrawRect(0, h - 2, w, 2) -- Draw the underline
        self:DrawTextEntryText(ResistanceRP.Colors.Text,ResistanceRP.Colors.Text,ResistanceRP.Colors.Text)
    end

    local modelViewer = vgui.Create("DModelPanel", modelPanel)
    modelViewer:Dock(FILL)

    local modelDropdown = vgui.Create("DComboBox", modelPanel)
    modelDropdown:Dock(BOTTOM)
    for k, v in ipairs(factionData.ranks[0].playerModels) do
        modelDropdown:AddChoice(v)
    end
    modelViewer:SetModel(factionData.ranks[0].playerModels[1])
    modelDropdown.OnSelect = function(self, index, value, data)
        modelViewer:SetModel(value)
    end

    local createCharacterButton = vgui.Create("DButton", formPanel)
    createCharacterButton:Dock(TOP)
    createCharacterButton:DockMargin(15,15,700,15)
    createCharacterButton:SetTall(64)
    createCharacterButton:SetFont("ResistanceRP.32N")
    createCharacterButton:SetTextColor(ResistanceRP.Colors.Text)
    createCharacterButton:SetText("Create Character")
    createCharacterButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) 
        surface.SetDrawColor(ResistanceRP.Colors.Border)
        surface.DrawOutlinedRect(0, 0, w, h) 
    end

    createCharacterButton.DoClick = function()
        local name = nameEntry:GetText()
        local age = tonumber(ageEntry:GetText())
        local eyeColor = eyeColorComboBox:GetValue()
        local bloodType = bloodTypeComboBox:GetValue()
        local hairColor = hairColorComboBox:GetValue()
        local description = descriptionEntry:GetText()
        local playerModel = modelViewer:GetModel()
        local factionName = factionData.idName
    
        -- Check if name has at least two words
        local nameWords = {}
        for word in name:gmatch("%S+") do
            table.insert(nameWords, word)
        end
        if #nameWords < 2 then
            Derma_Message("Please enter a full name (First and Last name).", "Error", "OK")
            return
        end
    
        -- Check if all options are selected
        if name == "" or age == nil or eyeColor == "" or bloodType == "" or hairColor == "" or description == "" then
            Derma_Message("Please fill in all character details.", "Error", "OK")
            return
        end
    
        -- Check if description is at least 50 characters
        if #description < 50 then
            Derma_Message("Description must be at least 50 characters long.", "Error", "OK")
            return
        end



        ResistanceRP.Print("All good, creating character!")
        ResistanceRP.Client.characters = ResistanceRP.Client.characters or {}
        if ResistanceRP.Client.characters[name] then
            Derma_Message("You already have a character called this!", "Error", "OK")
            return
        end
        print(factionName)
        ResistanceRP.Client.characters[name] = {
            charName = name,
            charAge = age,
            charEye = eyeColor,
            charBlood = bloodType,
            charHair = hairColor,
            charDesc = description,
            charPlayermodel = playerModel,
            charFaction = factionName,
        }
        net.Start("ResistanceRP.CreateCharacter")
            net.WriteString(name)
            net.WriteInt(age, 8) -- Assuming age is within byte range
            net.WriteString(eyeColor)
            net.WriteString(bloodType)
            net.WriteString(hairColor)
            net.WriteString(description)    
            net.WriteString(playerModel)
            net.WriteString(factionName)
        net.SendToServer()
        if(ResistanceRP.Client.Playing != nil) then ResistanceRP.Client.Playing:Stop() end
        ResistanceRP.Client.activeCharacter = ResistanceRP.Client.characters[name]
        self:Remove()
    end

end


vgui.Register("ResistanceRP.CharacterCreator", PANEL, "DPanel")

