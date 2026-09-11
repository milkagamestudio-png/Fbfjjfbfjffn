-- This file was modified for mobile support + custom ESP
-- Original: discord.gg/syncrypt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local n1 = 100
local n2 = 1
local u12 = false
local u13 = true
local u14 = false
local u15 = true
local u16 = false
local u17 = false
local u18 = false
local u19 = false
local s1 = "Counter Blox"
local u21 = false
local n3 = 100
local u23 = false
local u24 = false
local u25 = false
local n4 = 1
local u27 = false
local u28 = false
local u29 = false

-- ============================================================
-- VARIABLES POUR ESP PERSONNALISÉ
-- ============================================================
local espEnabled = false
local espTeamCheck = false
local espBox = true
local espName = true
local espHealth = true
local espDistance = true
local espHighlight = true
local espTracer = false
local espSkeleton = false
local espTextSize = 13
local espMaxDistance = 5000
local espColor = Color3.fromRGB(255, 50, 50)
local espTeamColor = Color3.fromRGB(50, 255, 50)
local espFillColor = Color3.fromRGB(255, 50, 50)
local espFillTransparency = 0.7
local espHighlightColor = Color3.fromRGB(255, 50, 50)
local espHighlightTransparency = 0.5
local espOutlineColor = Color3.fromRGB(0, 0, 0)
local espOutlineTransparency = 0

-- Cache pour les ESP
local espCache = {}
local espConnections = {}

-- ============================================================
-- FONCTIONS ESP
-- ============================================================

-- Créer les drawings pour un joueur
local function createESP(player)
    if espCache[player] then return end
    
    local drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        HeadDot = Drawing.new("Circle"),
    }
    
    -- Configuration Box
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Transparency = 0.8
    drawings.Box.Color = espColor
    drawings.Box.Visible = false
    
    -- Configuration Box Outline
    drawings.BoxOutline.Thickness = 3
    drawings.BoxOutline.Filled = false
    drawings.BoxOutline.Transparency = 0.8
    drawings.BoxOutline.Color = espOutlineColor
    drawings.BoxOutline.Visible = false
    
    -- Configuration Name
    drawings.Name.Size = espTextSize
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.OutlineColor = Color3.new(0, 0, 0)
    drawings.Name.Color = Color3.new(255, 255, 255)
    drawings.Name.Font = 2 -- UI font
    drawings.Name.Visible = false
    
    -- Configuration HealthBar
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
    drawings.HealthBar.Transparency = 0.3
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    drawings.HealthBar.Visible = false
    
    drawings.HealthBarOutline.Thickness = 1
    drawings.HealthBarOutline.Filled = false
    drawings.HealthBarOutline.Transparency = 0.3
    drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)
    drawings.HealthBarOutline.Visible = false
    
    -- Configuration HealthText
    drawings.HealthText.Size = espTextSize - 2
    drawings.HealthText.Center = true
    drawings.HealthText.Outline = true
    drawings.HealthText.OutlineColor = Color3.new(0, 0, 0)
    drawings.HealthText.Color = Color3.new(255, 255, 255)
    drawings.HealthText.Font = 2
    drawings.HealthText.Visible = false
    
    -- Configuration Distance
    drawings.Distance.Size = espTextSize
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.OutlineColor = Color3.new(0, 0, 0)
    drawings.Distance.Color = Color3.new(200, 200, 200)
    drawings.Distance.Font = 2
    drawings.Distance.Visible = false
    
    -- Configuration Tracer
    drawings.Tracer.Thickness = 1
    drawings.Tracer.Transparency = 1
    drawings.Tracer.Color = espColor
    drawings.Tracer.Visible = false
    
    -- Configuration HeadDot
    drawings.HeadDot.Thickness = 1
    drawings.HeadDot.Filled = true
    drawings.HeadDot.NumSides = 12
    drawings.HeadDot.Radius = 4
    drawings.HeadDot.Transparency = 0.5
    drawings.HeadDot.Color = espColor
    drawings.HeadDot.Visible = false
    
    espCache[player] = drawings
end

-- Supprimer les drawings d'un joueur
local function removeESP(player)
    if espCache[player] then
        for _, drawing in pairs(espCache[player]) do
            drawing:Remove()
        end
        espCache[player] = nil
    end
end

-- Créer un Highlight pour un joueur
local function createHighlight(player)
    if not player.Character then return end
    
    local existing = player.Character:FindFirstChild("MilkaESP_Highlight")
    if existing then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MilkaESP_Highlight"
    highlight.Adornee = player.Character
    highlight.FillColor = espHighlightColor
    highlight.FillTransparency = espHighlightTransparency
    highlight.OutlineColor = espColor
    highlight.OutlineTransparency = espOutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
end

-- Supprimer le Highlight
local function removeHighlight(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("MilkaESP_Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Mettre à jour l'ESP pour un joueur
local function updateESP(player)
    if not espEnabled then
        removeESP(player)
        removeHighlight(player)
        return
    end
    
    if player == LocalPlayer then return end
    if not player.Character then
        removeESP(player)
        return
    end
    
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not rootPart or not head then
        removeESP(player)
        return
    end
    
    if humanoid.Health <= 0 then
        removeESP(player)
        return
    end
    
    -- Team check
    if espTeamCheck and player.Team == LocalPlayer.Team then
        removeESP(player)
        removeHighlight(player)
        return
    end
    
    -- Créer les drawings si nécessaire
    if not espCache[player] then
        createESP(player)
    end
    
    local drawings = espCache[player]
    
    -- Vérifier la distance
    local distance = (rootPart.Position - CurrentCamera.CFrame.Position).Magnitude
    if distance > espMaxDistance then
        for _, d in pairs(drawings) do
            d.Visible = false
        end
        return
    end
    
    -- Calculer la position à l'écran
    local rootPos, rootOnScreen = CurrentCamera:WorldToViewportPoint(rootPart.Position)
    local headPos, headOnScreen = CurrentCamera:WorldToViewportPoint(head.Position)
    
    if not rootOnScreen or not headOnScreen then
        for _, d in pairs(drawings) do
            d.Visible = false
        end
        return
    end
    
    -- Couleurs selon l'équipe
    local isEnemy = player.Team ~= LocalPlayer.Team
    local mainColor = isEnemy and espColor or espTeamColor
    
    -- Calculer la taille de la box
    local boxHeight = math.abs(headPos.Y - rootPos.Y) * 2
    local boxWidth = boxHeight * 0.6
    local boxX = rootPos.X - boxWidth / 2
    local boxY = headPos.Y - boxHeight * 0.1
    
    -- Mettre à jour la Box
    if espBox then
        drawings.Box.Visible = true
        drawings.Box.Size = Vector2.new(boxWidth, boxHeight)
        drawings.Box.Position = Vector2.new(boxX, boxY)
        drawings.Box.Color = mainColor
        
        drawings.BoxOutline.Visible = true
        drawings.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
        drawings.BoxOutline.Position = Vector2.new(boxX, boxY)
    else
        drawings.Box.Visible = false
        drawings.BoxOutline.Visible = false
    end
    
    -- Mettre à jour le Name
    if espName then
        drawings.Name.Visible = true
        drawings.Name.Text = player.Name
        drawings.Name.Position = Vector2.new(rootPos.X, boxY - espTextSize - 4)
        drawings.Name.Size = espTextSize
    else
        drawings.Name.Visible = false
    end
    
    -- Mettre à jour la Health Bar
    if espHealth then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local healthBarHeight = boxHeight
        local healthBarWidth = 3
        local healthBarX = boxX - healthBarWidth - 4
        local healthBarY = boxY
        
        -- Outline
        drawings.HealthBarOutline.Visible = true
        drawings.HealthBarOutline.Size = Vector2.new(healthBarWidth, healthBarHeight)
        drawings.HealthBarOutline.Position = Vector2.new(healthBarX, healthBarY)
        
        -- Barre de vie (remplie de bas en haut)
        local filledHeight = healthBarHeight * healthPercent
        drawings.HealthBar.Visible = true
        drawings.HealthBar.Size = Vector2.new(healthBarWidth, filledHeight)
        drawings.HealthBar.Position = Vector2.new(healthBarX, healthBarY + (healthBarHeight - filledHeight))
        
        -- Couleur selon le pourcentage
        if healthPercent > 0.7 then
            drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.3 then
            drawings.HealthBar.Color = Color3.fromRGB(255, 165, 0)
        else
            drawings.HealthBar.Color = Color3.fromRGB(255, 0, 0)
        end
        
        -- Texte de vie
        drawings.HealthText.Visible = true
        drawings.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        drawings.HealthText.Position = Vector2.new(rootPos.X, boxY + boxHeight + 2)
        drawings.HealthText.Size = espTextSize - 2
    else
        drawings.HealthBar.Visible = false
        drawings.HealthBarOutline.Visible = false
        drawings.HealthText.Visible = false
    end
    
    -- Mettre à jour la Distance
    if espDistance then
        drawings.Distance.Visible = true
        drawings.Distance.Text = string.format("[%d studs]", math.floor(distance))
        drawings.Distance.Position = Vector2.new(rootPos.X, boxY + boxHeight + espTextSize + 4)
        drawings.Distance.Size = espTextSize
    else
        drawings.Distance.Visible = false
    end
    
    -- Mettre à jour le Tracer
    if espTracer then
        drawings.Tracer.Visible = true
        drawings.Tracer.From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)
        drawings.Tracer.To = Vector2.new(rootPos.X, boxY + boxHeight)
        drawings.Tracer.Color = mainColor
    else
        drawings.Tracer.Visible = false
    end
    
    -- Mettre à jour le Head Dot
    if espSkeleton then
        drawings.HeadDot.Visible = true
        drawings.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
        drawings.HeadDot.Color = mainColor
    else
        drawings.HeadDot.Visible = false
    end
    
    -- Mettre à jour le Highlight
    if espHighlight then
        if not character:FindFirstChild("MilkaESP_Highlight") then
            createHighlight(player)
        end
        local highlight = character:FindFirstChild("MilkaESP_Highlight")
        if highlight then
            highlight.FillColor = mainColor
            highlight.OutlineColor = mainColor
            highlight.FillTransparency = espHighlightTransparency
            highlight.OutlineTransparency = espOutlineTransparency
        end
    else
        removeHighlight(player)
    end
end

-- Boucle de mise à jour ESP
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        -- Nettoyer tout
        for player, _ in pairs(espCache) do
            removeESP(player)
        end
        for _, player in pairs(Players:GetPlayers()) do
            removeHighlight(player)
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        pcall(updateESP, player)
    end
end)

-- Nettoyage quand un joueur quitte
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Nettoyage quand un joueur réapparaît
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then
            updateESP(player)
        end
    end)
end)

-- ============================================================
-- FONCTIONS MOBILE
-- ============================================================

local mobileButtons = {}
local mobileGui = nil
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Créer un bouton mobile
local function createMobileButton(name, text, position, size, color, callback)
    if not mobileGui then return nil end
    
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Parent = mobileGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Support tactile
    button.TouchTap:Connect(function()
        callback()
    end)
    
    table.insert(mobileButtons, button)
    return button
end

-- Créer le GUI mobile
local function createMobileGUI()
    if mobileGui then return end
    
    mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "MilkaMobileControls"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.DisplayOrder = 100
    
    local parent = LocalPlayer:WaitForChild("PlayerGui")
    mobileGui.Parent = parent
    
    -- Bouton principal (toggle menu)
    local mainButton = Instance.new("TextButton")
    mainButton.Name = "MainToggle"
    mainButton.Text = "🎯"
    mainButton.Size = UDim2.new(0, 50, 0, 50)
    mainButton.Position = UDim2.new(0, 10, 0.5, -25)
    mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextSize = 24
    mainButton.BorderSizePixel = 0
    mainButton.Parent = mobileGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 150)
    stroke.Thickness = 2
    stroke.Parent = mainButton
    
    -- Panneau de contrôles
    local panel = Instance.new("Frame")
    panel.Name = "ControlPanel"
    panel.Size = UDim2.new(0, 60, 0, 0)
    panel.Position = UDim2.new(0, 10, 0.5, -25)
    panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    panel.BackgroundTransparency = 0.1
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Parent = mobileGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = panel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(60, 60, 90)
    panelStroke.Thickness = 1
    panelStroke.Parent = panel
    
    -- Liste des boutons
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = panel
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = panel
    
    -- Animation du panneau
    local panelOpen = false
    local function togglePanel()
        panelOpen = not panelOpen
        if panelOpen then
            panel.Visible = true
            panel.Size = UDim2.new(0, 60, 0, 0)
            local targetSize = UDim2.new(0, 60, 0, #mobileButtons * 46 + 20)
            panel:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true)
        else
            local targetSize = UDim2.new(0, 60, 0, 0)
            panel:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true, function()
                panel.Visible = false
            end)
        end
    end
    
    mainButton.MouseButton1Click:Connect(togglePanel)
    mainButton.TouchTap:Connect(togglePanel)
    
    -- Créer les boutons dans le panneau
    local yOffset = 0
    
    -- Aimbot toggle
    createMobileButton("AimbotBtn", "🎯", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u15 = not u15
        mobileButtons[1].BackgroundColor3 = u15 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- Aim Assist toggle
    createMobileButton("AimAssistBtn", "🤖", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u16 = not u16
        mobileButtons[2].BackgroundColor3 = u16 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- Silent Aim toggle
    createMobileButton("SilentAimBtn", "🔇", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u21 = not u21
        mobileButtons[3].BackgroundColor3 = u21 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- ESP toggle
    createMobileButton("ESPBtn", "👁", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        espEnabled = not espEnabled
        mobileButtons[4].BackgroundColor3 = espEnabled and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- Hitbox toggle
    createMobileButton("HitboxBtn", "📦", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u25 = not u25
        mobileButtons[5].BackgroundColor3 = u25 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- No Recoil toggle
    createMobileButton("NoRecoilBtn", "🔫", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u23 = not u23
        mobileButtons[6].BackgroundColor3 = u23 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    yOffset = yOffset + 46
    
    -- No Spread toggle
    createMobileButton("NoSpreadBtn", "📐", UDim2.new(0, 0, 0, yOffset), UDim2.new(0, 44, 0, 40), nil, function()
        u24 = not u24
        mobileButtons[7].BackgroundColor3 = u24 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50)
    end)
    
    return mobileGui
end

-- Bouton de tir mobile (si pas de souris)
local function createMobileFireButton()
    if not mobileGui then return end
    
    local fireButton = Instance.new("TextButton")
    fireButton.Name = "FireButton"
    fireButton.Text = "🔥"
    fireButton.Size = UDim2.new(0, 70, 0, 70)
    fireButton.Position = UDim2.new(1, -90, 1, -90)
    fireButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fireButton.BackgroundTransparency = 0.3
    fireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fireButton.TextSize = 32
    fireButton.BorderSizePixel = 0
    fireButton.Parent = mobileGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = fireButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 100, 100)
    stroke.Thickness = 2
    stroke.Parent = fireButton
    
    -- Simuler un clic gauche
    fireButton.MouseButton1Down:Connect(function()
        u12 = true
    end)
    
    fireButton.MouseButton1Up:Connect(function()
        u12 = false
    end)
    
    fireButton.TouchLongPress:Connect(function()
        u12 = true
    end)
    
    fireButton.TouchTap:Connect(function()
        u12 = false
    end)
    
    -- Pour le maintien tactile
    fireButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            u12 = true
        end
    end)
    
    fireButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            u12 = false
        end
    end)
end

-- Initialiser le mobile
if isMobile then
    createMobileGUI()
    createMobileFireButton()
    
    -- Mettre à jour les couleurs initiales
    task.wait(0.5)
    if mobileButtons[1] then mobileButtons[1].BackgroundColor3 = u15 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[2] then mobileButtons[2].BackgroundColor3 = u16 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[3] then mobileButtons[3].BackgroundColor3 = u21 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[4] then mobileButtons[4].BackgroundColor3 = espEnabled and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[5] then mobileButtons[5].BackgroundColor3 = u25 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[6] then mobileButtons[6].BackgroundColor3 = u23 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    if mobileButtons[7] then mobileButtons[7].BackgroundColor3 = u24 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
end

-- ============================================================
-- SUITE DU SCRIPT ORIGINAL
-- ============================================================

local Humanoid
local HumanoidRootPart
local function v32(p1)
    Humanoid = p1:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
end
local Character = LocalPlayer.Character
if not Character then
    Character = LocalPlayer.CharacterAdded:Wait()
end
v32(Character)
LocalPlayer.CharacterAdded:Connect(v32)

local drawing = Drawing.new("Circle")
drawing.Color = Color3.fromRGB(180, 90, 255)
drawing.Thickness = 2
drawing.NumSides = 64
drawing.Filled = false
drawing.Radius = n1
drawing.Visible = u13

local v35 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local t1 = {
	Enabled = true,
	FolderName = nil,
	FileName = "StarTradeGuiConfig"
}
local t2 = {
	Enabled = false
}
local v38 = v35:CreateWindow({
	Name = "Milka Service",
	Icon = 0,
	LoadingTitle = "Milka Service",
	LoadingSubtitle = "by Milka",
	Theme = "Default",
	ConfigurationSaving = t1,
	Discord = t2,
	KeySystem = true,
	KeySettings = {
		Title = "Key System",
		Subtitle = "Entrez votre clé pour continuer",
		Note = "Achete une key sur https://discord.gg/eSmbeahKTS",
		FileName = "StarTradeKey",
		SaveKey = false,
		GrabKeyFromSite = false,
		Key = { "H3P9X-2L7M8-K5Q1Z-T0R4B-F8N3D-V7C2J-M9X6A" }
	}
})

-- Onglet Aimbot
local v39 = v38:CreateTab("🎯 Aimbot", nil)
v39:CreateSection("Contrôles Aimbot")
local v40 = u15
v39:CreateToggle({
	Name = "AimBot",
	CurrentValue = v40,
	Flag = "AimBotToggle",
	Callback = function(p2)
        u15 = p2
        if mobileButtons[1] then mobileButtons[1].BackgroundColor3 = p2 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})
local v41 = u16
v39:CreateToggle({
	Name = "Aim Assist",
	CurrentValue = v41,
	Flag = "AimAssistToggle",
	Callback = function(p3)
        u16 = p3
        if mobileButtons[2] then mobileButtons[2].BackgroundColor3 = p3 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})
local CreateToggle = v39.CreateToggle
local v43 = u17
CreateToggle(v39, {
	Name = "Team Check",
	CurrentValue = v43,
	Flag = "TeamCheckToggle",
	Callback = function(p4)
        u17 = p4
    end
})
local v44 = u18
v39:CreateToggle({
	Name = "Wall Check",
	CurrentValue = v44,
	Flag = "WallCheckToggle",
	Callback = function(p5)
        u18 = p5
    end
})
local CreateSlider = v39.CreateSlider
local v46 = n1
CreateSlider(v39, {
	Name = "FOV",
	Range = { 20, 500 },
	Increment = 1,
	Suffix = "px",
	CurrentValue = v46,
	Flag = "FOVSlider",
	Callback = function(p6)
        n1 = p6
        drawing.Radius = n1
    end
})
local v47 = n2
v39:CreateSlider({
	Name = "Smoothness",
	Range = { 0.1, 100 },
	Increment = 0.1,
	Suffix = "",
	CurrentValue = v47,
	Flag = "SmoothnessSlider",
	Callback = function(p7)
        n2 = p7
    end
})
local v48 = u13
v39:CreateToggle({
	Name = "Afficher FOV",
	CurrentValue = v48,
	Flag = "ShowFOVToggle",
	Callback = function(p8)
        u13 = p8
        drawing.Visible = u13
    end
})
local CreateToggle2 = v39.CreateToggle
local v50 = u21
CreateToggle2(v39, {
	Name = "Silent Aim",
	CurrentValue = v50,
	Flag = "SilentAimToggle",
	Callback = function(p9)
        u21 = p9
        if mobileButtons[3] then mobileButtons[3].BackgroundColor3 = p9 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})
local v51 = n3
v39:CreateSlider({
	Name = "Hit Chance",
	Range = { 0, 100 },
	Increment = 1,
	Suffix = "%",
	CurrentValue = v51,
	Flag = "HitChanceSlider",
	Callback = function(p10)
        n3 = p10
    end
})

-- Onglet Gun
local v52 = v38:CreateTab("🔫 Gun", nil)
v52:CreateSection("Contrôles Gun")
local v53 = u23
v52:CreateToggle({
	Name = "No Recoil",
	CurrentValue = v53,
	Flag = "NoRecoilToggle",
	Callback = function(p11)
        u23 = p11
        if mobileButtons[6] then mobileButtons[6].BackgroundColor3 = p11 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})
local CreateToggle3 = v52.CreateToggle
local v55 = u24
CreateToggle3(v52, {
	Name = "No Spread",
	CurrentValue = v55,
	Flag = "NoSpreadToggle",
	Callback = function(p12)
        u24 = p12
        if mobileButtons[7] then mobileButtons[7].BackgroundColor3 = p12 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})

-- Onglet Player
local v56 = v38:CreateTab("🧍 Player", nil)
v56:CreateSection("Contrôles Player")
local v57 = u25
v56:CreateToggle({
	Name = "Hitbox Changer",
	CurrentValue = v57,
	Flag = "HitboxChangerToggle",
	Callback = function(p13)
        u25 = p13
        if mobileButtons[5] then mobileButtons[5].BackgroundColor3 = p13 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
    end
})
local v58 = n4
v56:CreateSlider({
	Name = "Hitbox Size",
	Range = { 1, 5 },
	Increment = 0.1,
	Suffix = "x",
	CurrentValue = v58,
	Flag = "HitboxSizeSlider",
	Callback = function(p14)
        n4 = p14
    end
})
local CreateToggle4 = v56.CreateToggle
local v60 = u27
CreateToggle4(v56, {
	Name = "Touch Fling",
	CurrentValue = v60,
	Flag = "TouchFlingToggle",
	Callback = function(p15)
        u27 = p15
    end
})
local v61 = u28
v56:CreateToggle({
	Name = "WallHop",
	CurrentValue = v61,
	Flag = "WallHopToggle",
	Callback = function(p16)
        u28 = p16
    end
})

-- Onglet Auto
local v62 = v38:CreateTab("🤖 Auto", nil)
v62:CreateSection("Contrôles Automatiques")
local v63 = u14
v62:CreateToggle({
	Name = "TigerBot",
	CurrentValue = v63,
	Flag = "TigerBotToggle",
	Callback = function(p17)
        u14 = p17
    end
})

-- Onglet Game
local v64 = v38:CreateTab("🎮 Game", nil)
v64:CreateSection("Choisir le jeu et activer les cheats")
v64:CreateDropdown({
	Name = "Select Game",
	Options = { "Counter Blox" },
	CurrentOption = "Counter Blox",
	Flag = "GameDropdown",
	Callback = function(p18)
        s1 = p18
    end
})
local v65 = u19
v64:CreateToggle({
	Name = "Auto Shift (Left Ctrl)",
	CurrentValue = v65,
	Flag = "AutoShiftToggle",
	Callback = function(p19)
        u19 = p19
    end
})

-- Onglet Visual (avec ESP personnalisé)
local v66 = v38:CreateTab("👁 Visual", nil)
v66:CreateSection("ESP Personnalisé")

v66:CreateToggle({
	Name = "ESP Enabled",
	CurrentValue = false,
	Flag = "ESPToggle",
	Callback = function(p20)
        espEnabled = p20
        if mobileButtons[4] then mobileButtons[4].BackgroundColor3 = p20 and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(40, 40, 50) end
        -- Nettoyer si désactivé
        if not p20 then
            for player, _ in pairs(espCache) do
                removeESP(player)
            end
            for _, player in pairs(Players:GetPlayers()) do
                removeHighlight(player)
            end
        end
    end
})

v66:CreateToggle({
	Name = "Team Check ESP",
	CurrentValue = false,
	Flag = "ESPTeamCheckToggle",
	Callback = function(p21)
        espTeamCheck = p21
    end
})

v66:CreateToggle({
	Name = "Box",
	CurrentValue = true,
	Flag = "ESPBoxToggle",
	Callback = function(p22)
        espBox = p22
    end
})

v66:CreateToggle({
	Name = "Name",
	CurrentValue = true,
	Flag = "ESPNameToggle",
	Callback = function(p23)
        espName = p23
    end
})

v66:CreateToggle({
	Name = "Health Bar",
	CurrentValue = true,
	Flag = "ESPHealthToggle",
	Callback = function(p24)
        espHealth = p24
    end
})

v66:CreateToggle({
	Name = "Distance",
	CurrentValue = true,
	Flag = "ESPDistanceToggle",
	Callback = function(p25)
        espDistance = p25
    end
})

v66:CreateToggle({
	Name = "Highlight",
	CurrentValue = true,
	Flag = "ESPHighlightToggle",
	Callback = function(p26)
        espHighlight = p26
    end
})

v66:CreateToggle({
	Name = "Tracer",
	CurrentValue = false,
	Flag = "ESPTracerToggle",
	Callback = function(p27)
        espTracer = p27
    end
})

v66:CreateToggle({
	Name = "Head Dot",
	CurrentValue = false,
	Flag = "ESPHeadDotToggle",
	Callback = function(p28)
        espSkeleton = p28
    end
})

v66:CreateSlider({
	Name = "Max Distance",
	Range = { 100, 10000 },
	Increment = 100,
	Suffix = " studs",
	CurrentValue = 5000,
	Flag = "ESPMaxDistanceSlider",
	Callback = function(p29)
        espMaxDistance = p29
    end
})

v66:CreateSlider({
	Name = "Text Size",
	Range = { 8, 24 },
	Increment = 1,
	Suffix = "px",
	CurrentValue = 13,
	Flag = "ESPTextSizeSlider",
	Callback = function(p30)
        espTextSize = p30
    end
})

v66:CreateSlider({
	Name = "Highlight Transparency",
	Range = { 0, 1 },
	Increment = 0.05,
	Suffix = "",
	CurrentValue = 0.5,
	Flag = "ESPHighlightTransparencySlider",
	Callback = function(p31)
        espHighlightTransparency = p31
    end
})

v66:CreateSection("FPS Boost")
local v67 = u29
v66:CreateToggle({
	Name = "FPS Boost",
	CurrentValue = v67,
	Flag = "FPSBoostToggle",
	Callback = function(p32)
        u29 = p32
        if p32 then
            local t3 = {}
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 10000000000
            Lighting.Brightness = 0
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            for v110, v111 in pairs(game:GetDescendants()) do
                local v112 = v111:IsA("BasePart")
                if not v112 then
                    v112 = v111:IsA("UnionOperation")
                    if not v112 then
                        v112 = v111:IsA("CornerWedgePart")
                        if not v112 then
                            v112 = v111:IsA("TrussPart")
                        end
                    end
                end
                if v112 then
                    t3[v111] = v111.Material
                    v111.Material = Enum.Material.SmoothPlastic
                    v111.Reflectance = 0
                elseif v111:IsA("MeshPart") then
                    t3[v111] = v111.Material
                    v111.Material = Enum.Material.SmoothPlastic
                    v111.Reflectance = 0
                    v111.TextureID = ""
                else
                    local v113 = v111:IsA("Decal")
                    if not v113 then
                        v113 = v111:IsA("Texture")
                    end
                    if v113 then
                        v111:Destroy()
                    else
                        local v114 = v111:IsA("ParticleEmitter")
                        if not v114 then
                            v114 = v111:IsA("Trail")
                        end
                        if v114 then
                            v111.Lifetime = NumberRange.new(0)
                        elseif v111:IsA("Explosion") then
                            v111.BlastPressure = 1
                            v111.BlastRadius = 1
                        else
                            local v115 = v111:IsA("Fire")
                            if not v115 then
                                v115 = v111:IsA("SpotLight")
                                if not v115 then
                                    v115 = v111:IsA("Smoke")
                                end
                            end
                            if v115 then
                                v111.Enabled = false
                            end
                        end
                    end
                end
            end
            for _, child in pairs(Lighting:GetChildren()) do
                local v118 = child:IsA("BlurEffect")
                if not v118 then
                    v118 = child:IsA("SunRaysEffect")
                    if not v118 then
                        v118 = child:IsA("ColorCorrectionEffect")
                        if not v118 then
                            v118 = child:IsA("BloomEffect")
                            if not v118 then
                                v118 = child:IsA("DepthOfFieldEffect")
                            end
                        end
                    end
                end
                if v118 then
                    child.Enabled = false
                end
            end
        end
    end
})

-- Onglet Exploit
local v68 = v38:CreateTab("🛠 Exploit", nil)
v68:CreateSection("Options Exploit")
local u69 = false
local v70 = u69
v68:CreateToggle({
	Name = "Spoof Name",
	CurrentValue = v70,
	Flag = "SpoofNameToggle",
	Callback = function(p33)
        u69 = p33
        if u69 then
            getgenv().name = "MilkaServiceLover"
            local LocalPlayer2 = game.Players.LocalPlayer
            local function v121(p34)
                if p34.ClassName == "TextLabel" then
                    if string.find(p34.Text, LocalPlayer2.Name) then
                        p34.Text = p34.Text:gsub(LocalPlayer2.Name, name)
                    end
                    p34:GetPropertyChangedSignal("Text"):Connect(function()
                        p34.Text = p34.Text:gsub(LocalPlayer2.Name, name)
                    end)
                end
            end
            local _next = next
            local v123, v124 = game:GetDescendants()
            while true do
                local v125
                v124, v125 = _next(v123, v124)
                if not v124 then
                    break
                end
                v121(v125)
            end
            game.DescendantAdded:Connect(function(descendant)
                v121(descendant)
            end)
        end
    end
})

-- ============================================================
-- INPUTS
-- ============================================================

local RightShift = Enum.KeyCode.RightShift
local u72 = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == RightShift then
        u72 = not u72
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        u12 = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        u12 = false
    end
end)

-- ============================================================
-- AIMBOT
-- ============================================================

local function v73()
    local v129 = n1
    local Head
    local vector2 = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    for _, player in pairs(Players:GetPlayers()) do
        local v134 = player ~= LocalPlayer
        if v134 then
            v134 = player.Character
            if v134 then
                v134 = player.Character:FindFirstChild("Head")
            end
        end
        if not v134 then
            continue
        end
        local v135 = u17
        if v135 then
            v135 = player.Team == LocalPlayer.Team
        end
        if v135 then
            continue
        end
        local v136, v137 = CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
        if not v137 then
            continue
        end
        local Magnitude = (Vector2.new(v136.X, v136.Y) - vector2).Magnitude
        if not (Magnitude < v129) then
            continue
        end
        if u18 then
            local ray = Ray.new(CurrentCamera.CFrame.Position, player.Character.Head.Position - CurrentCamera.CFrame.Position)
            local PartOnRayWithIgnoreList = workspace:FindPartOnRayWithIgnoreList(ray, { LocalPlayer.Character })
            if PartOnRayWithIgnoreList then
                PartOnRayWithIgnoreList = PartOnRayWithIgnoreList.Parent ~= player.Character
            end
            if PartOnRayWithIgnoreList then
                continue
            end
        end
        v129 = Magnitude
        Head = player.Character.Head
    end
    return Head
end

local function v74()
    if not HumanoidRootPart then
        return false
    end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 2, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function v75()
    local v143 = not u28
    if not v143 then
        v143 = false
        if not v143 then
            v143 = not Humanoid or not HumanoidRootPart
        end
    end
    if v143 then
        return
    end
    while u28 and v74() do
        Humanoid.Jump = true
        HumanoidRootPart.Velocity = Vector3.new(0, 60, 0)
        task.wait(0)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, -0.6108652381980153, 0)
        task.wait(0.4)
    end
end

RunService.RenderStepped:Connect(function()
    drawing.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    drawing.Radius = n1
    drawing.Visible = u13

    if u15 then
        local v144 = v73()
        if v144 then
            local CFramePosition = CurrentCamera.CFrame.Position
            local Position = v144.Position
            local n5 = 0
            if u16 then
                n5 = 0.05
            elseif u12 then
                n5 = 1 / n2
            end
            if u12 or u16 then
                local v148 = CurrentCamera
                local _CFrame = CFrame
                local Lerp = CFramePosition.Lerp
                v148.CFrame = _CFrame.new(CFramePosition, Lerp(CFramePosition, Position, n5))
            end
            if u14 and u12 then
                mouse1press()
                wait()
                mouse1release()
            end
            if u21 then
                if not (math.random(0, 100) <= n3) then
                end
            end
            local v151 = u19
            if v151 then
                v151 = s1 == "Counter Blox" and true
            end
            if v151 then
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                        wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
                    end
                end)
            end
        end
    end

    if u28 then
        v75()
    end

    if u25 then
        for _, player in pairs(Players:GetPlayers()) do
            local v154 = player ~= LocalPlayer
            if v154 then
                v154 = player.Character
                if v154 then
                    v154 = player.Character:FindFirstChild("Head")
                end
            end
            if v154 then
                if player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Size = Vector3.new(n4, n4, n4)
                end
                player.Character.Head.Size = Vector3.new(n4, n4, n4)
            end
        end
    end

    if u23 then
        for _, descendant in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            local v157 = descendant.Name == "Recoil"
            if not v157 then
                v157 = descendant.Name == "RecoilControl"
            end
            if v157 then
                descendant.Value = 0
            end
        end
    end

    if u24 then
        for _, descendant in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            local v160 = descendant.Name == "MaxSpread"
            if not v160 then
                v160 = descendant.Name == "Spread"
                if not v160 then
                    v160 = descendant.Name == "SpreadControl"
                end
            end
            if v160 then
                descendant.Value = 0
            end
        end
    end
end)

-- Anti-AFK
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local Decal = Instance.new("Decal")
    Decal.Name = "juisdfj0i32i0eidsuf0iok"
    Decal.Parent = ReplicatedStorage
end

-- Touch Fling
local co
local function v78()
    local LocalPlayer3 = Players.LocalPlayer
    local n6 = 0.1
    while u27 do
        RunService.Heartbeat:Wait()
        local Character2 = LocalPlayer3.Character
        if Character2 then
            Character2 = LocalPlayer3.Character:FindFirstChild("HumanoidRootPart")
        end
        if Character2 then
            local Character2Velocity = Character2.Velocity
            Character2.Velocity = Character2Velocity * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            Character2.Velocity = Character2Velocity
            RunService.Stepped:Wait()
            Character2.Velocity = Character2Velocity + Vector3.new(0, n6, 0)
            n6 = -n6
        end
    end
end

RunService.RenderStepped:Connect(function()
    local v165 = u27
    if v165 then
        v165 = not co
        if not v165 then
            v165 = coroutine.status(co) == "dead"
        end
    end
    if v165 then
        co = coroutine.create(v78)
        coroutine.resume(co)
    end
end)