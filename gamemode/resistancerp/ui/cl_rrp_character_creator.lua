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
    secondaryHeaderText:SetText("Character Creator")
    secondaryHeaderText:SetFont("ResistanceRP.32N")
    secondaryHeaderText:SizeToContents()
    secondaryHeaderText:SetPos(ScrW() * 0.025, ScrH() * 0.1)

    local characterSlotContainer = vgui.Create("EditablePanel", self)
    characterSlotContainer:SetSize(ScrW() * 0.85, ScrH() * 0.70)
    characterSlotContainer:Center()
    characterSlotContainer:MakePopup()
    characterSlotContainer.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.BackgroundSecondary) -- Draw a colored rectangle for the background
    end

    self:DisplayFactions(characterSlotContainer)
end

function PANEL:DisplayFactions(characterSlotContainer)
    -- Calculate the button width to fill the container horizontally with spacing
    local buttonWidth = (characterSlotContainer:GetWide() - 15 * 4) / 3 -- Adjust spacing as necessary

    -- Add a for loop to create three buttons horizontally
    for faction, factionData in pairs(ResistanceRP.Factions) do
        local characterSlotButton = vgui.Create("DPanel", characterSlotContainer)
        characterSlotButton:SetWide(buttonWidth) -- Set the width of the button
        characterSlotButton:Dock(LEFT) -- Dock buttons to the left side of the container
        characterSlotButton:DockMargin(15, 15, 0, 15) -- Add spacing between buttons
        
        local buttonText = vgui.Create("DLabel", characterSlotButton)
        buttonText:SetText(factionData.dName) -- Set the text
        buttonText:SetFont("ResistanceRP.34N")
        buttonText:SizeToContents()
        buttonText:SetContentAlignment(5) -- Center the text horizontally
        buttonText:Dock(TOP) -- Dock the text label to the top of the panel
        buttonText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Background color
        end

        local iconButton = vgui.Create("DImageButton", characterSlotButton)
        iconButton:Dock(FILL) -- Dock the image button to fill the remaining space in the panel
        ResistanceRP.GetMaterialFromImage(iconButton, factionData.icon) -- Fetch and set the image from Imgur
        iconButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Background color
        end
        iconButton.DoClick = function()
            if(factionData.SubFactions != nil) then
                characterSlotContainer:Clear()
                self:DisplaySubFactions(characterSlotContainer, factionData.SubFactions)
            else
                characterSlotContainer:Clear()
                self:CreateNewCharacter(factionData.ranks[0], characterSlotContainer)
            end
        end
    end
end

function PANEL:DisplaySubFactions(characterSlotContainer, subFactions)
    -- Calculate the button width to fill the container horizontally with spacing
    local buttonWidth = (characterSlotContainer:GetWide() - 15 * 4) / 2 -- Adjust spacing as necessary

    -- Add a for loop to create three buttons horizontally
    for faction, factionData in pairs(subFactions) do
        local characterSlotButton = vgui.Create("DPanel", characterSlotContainer)
        characterSlotButton:SetWide(buttonWidth) -- Set the width of the button
        characterSlotButton:Dock(LEFT) -- Dock buttons to the left side of the container
        characterSlotButton:DockMargin(15, 15, 0, 15) -- Add spacing between buttons
        
        local buttonText = vgui.Create("DLabel", characterSlotButton)
        buttonText:SetText(factionData.dName) -- Set the text
        buttonText:SetFont("ResistanceRP.34N")
        buttonText:SizeToContents()
        buttonText:SetContentAlignment(5) -- Center the text horizontally
        buttonText:Dock(TOP) -- Dock the text label to the top of the panel
        buttonText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Background color
        end

        local iconButton = vgui.Create("DImageButton", characterSlotButton)
        iconButton:Dock(FILL) -- Dock the image button to fill the remaining space in the panel
        ResistanceRP.GetMaterialFromImage(iconButton, factionData.icon) -- Fetch and set the image from Imgur
        iconButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Background color
        end
        iconButton.DoClick = function()
            characterSlotContainer:Clear()
            self:CreateNewCharacter(factionData, characterSlotContainer)
        end
    end
end

function PANEL:CreateNewCharacter(factionData, characterSlotContainer)
    local formPanel = vgui.Create("EditablePanel", characterSlotContainer)
    formPanel:SetWide(characterSlotContainer:GetWide() * 0.575) -- Adjust the width as needed
    formPanel:Dock(LEFT)
    formPanel:DockMargin(10, 10, 10, 10)
    formPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, ResistanceRP.Colors.Background) -- Draw a colored rectangle for the background
    end

    local modelPanel = vgui.Create("DPanel", characterSlotContainer)
    modelPanel:SetWide(characterSlotContainer:GetWide() * 0.4) -- Adjust the width as needed
    modelPanel:Dock(RIGHT)
    modelPanel:DockMargin(10, 10, 10, 10)
    modelPanel:SetBackgroundColor(ResistanceRP.Colors.Background)

    -- Form Input Section
    local nameLabel = vgui.Create("DLabel", formPanel)
    nameLabel:SetText("Name:")
    nameLabel:SetFont("ResistanceRP.24N")
    nameLabel:SetTextColor(ResistanceRP.Colors.Text)
    nameLabel:Dock(TOP)
    nameLabel:DockMargin(15,15,15,0)
    
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
    for k, v in ipairs(factionData.playerModels) do
        modelDropdown:AddChoice(v)
    end
    modelViewer:SetModel(factionData.playerModels[1])
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
        ResistanceRP.Client.characters[name] = {
            charName = name,
            charAge = age,
            charEye = eyeColor,
            charBlood = bloodType,
            charHair = hairColor,
            charDesc = description,
            charPlayermodel = playerModel,
            charFaction = factionData.idName
        }
        net.Start("ResistanceRP.CreateCharacter")
            net.WriteString(name)
            net.WriteInt(age, 8) -- Assuming age is within byte range
            net.WriteString(eyeColor)
            net.WriteString(bloodType)
            net.WriteString(hairColor)
            net.WriteString(description)
            net.WriteString(playerModel)
            net.WriteString(charFaction)
        net.SendToServer()
        if(ResistanceRP.Client.Playing != nil) then ResistanceRP.Client.Playing:Stop() end
        ResistanceRP.Client.activeCharacter = ResistanceRP.Client.characters[name]
        self:Remove()
    end

end


vgui.Register("ResistanceRP.CharacterCreator", PANEL, "DPanel")