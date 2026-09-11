-- This file was generated at discord.gg/syncrypt

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
local v39 = v38:CreateTab("🎯 Aimbot", nil)
v39:CreateSection("Contrôles Aimbot")
local v40 = u15
v39:CreateToggle({
	Name = "AimBot",
	CurrentValue = v40,
	Flag = "AimBotToggle",
	Callback = function(p2)
    u15 = p2
end
})
local v41 = u16
v39:CreateToggle({
	Name = "Aim Assist",
	CurrentValue = v41,
	Flag = "AimAssistToggle",
	Callback = function(p3)
    u16 = p3
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
	Range = {
		20,
		500
	},
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
	Range = {
		0.1,
		100
	},
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
end
})
local v51 = n3
v39:CreateSlider({
	Name = "Hit Chance",
	Range = {
		0,
		100
	},
	Increment = 1,
	Suffix = "%",
	CurrentValue = v51,
	Flag = "HitChanceSlider",
	Callback = function(p10)
    n3 = p10
end
})
local v52 = v38:CreateTab("🔫 Gun", nil)
v52:CreateSection("Contrôles Gun")
local v53 = u23
v52:CreateToggle({
	Name = "No Recoil",
	CurrentValue = v53,
	Flag = "NoRecoilToggle",
	Callback = function(p11)
    u23 = p11
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
end
})
local v56 = v38:CreateTab("🧍 Player", nil)
v56:CreateSection("Contrôles Player")
local v57 = u25
v56:CreateToggle({
	Name = "Hitbox Changer",
	CurrentValue = v57,
	Flag = "HitboxChangerToggle",
	Callback = function(p13)
    u25 = p13
end
})
local v58 = n4
v56:CreateSlider({
	Name = "Hitbox Size",
	Range = {
		1,
		5
	},
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
local v66 = v38:CreateTab("👁\239\184\143 Visual", nil)
v66:CreateSection("Contrôles Visual")
v66:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "ESPToggle",
	Callback = function(p20)
    if p20 then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cool83birdcarfly02six/UNIVERSALESPLTX/main/README.md", true))()
    end
end
})
local v67 = u29
v66:CreateToggle({
	Name = "FPS Boost",
	CurrentValue = v67,
	Flag = "FPSBoostToggle",
	Callback = function(p21)
    u29 = p21

    if p21 then
        local t3 = {}
        local _ = Terrain.WaterWaveSize
        local _ = Terrain.WaterWaveSpeed
        local _ = Terrain.WaterReflectance
        local _ = Terrain.WaterTransparency
        local _ = Lighting.GlobalShadows
        local _ = Lighting.FogEnd
        local _ = Lighting.Brightness
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
local v68 = v38:CreateTab("🛠 Exploit", nil)
v68:CreateSection("Options Exploit")
local u69 = false
local v70 = u69
v68:CreateToggle({
	Name = "Spoof Name",
	CurrentValue = v70,
	Flag = "SpoofNameToggle",
	Callback = function(p22)
    u69 = p22

    if u69 then
        getgenv().name = "MilkaServiceLover"

        local LocalPlayer2 = game.Players.LocalPlayer

        local function v121(p23)
            if p23.ClassName == "TextLabel" then
                if string.find(p23.Text, LocalPlayer2.Name) then
                    p23.Text = p23.Text:gsub(LocalPlayer2.Name, name)
                end

                p23:GetPropertyChangedSignal("Text"):Connect(function()
                    p23.Text = p23.Text:gsub(LocalPlayer2.Name, name)
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
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local Decal = Instance.new("Decal")

    Decal.Name = "juisdfj0i32i0eidsuf0iok"
    Decal.Parent = ReplicatedStorage
end
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
