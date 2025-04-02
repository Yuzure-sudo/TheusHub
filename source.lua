-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configurações
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    ESP = {
        Players = false,
        Mobs = false,
        Chests = false
    },
    ChestFarm = false,
    AttackSpeed = 0.01,
    HoverHeight = 20,
    AutoSkill = false,
    FastAttack = false,
    NoClip = false
}

-- Funções de Utilidade
local function getNearestMob()
    local nearestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and 
           mob:FindFirstChild("HumanoidRootPart") and 
           mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

-- Auto Farm
local function autoFarm()
    while Settings.AutoFarm do
        local mob = getNearestMob()
        if mob and mob:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleporte suave
            local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.HoverHeight, 0)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {
                CFrame = CFrame.new(targetPosition, mob.HumanoidRootPart.Position)
            })
            tween:Play()
            
            -- Sistema de ataque ultra-rápido
            for i = 1, 10 do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(), workspace.CurrentCamera.CFrame)
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                wait(Settings.AttackSpeed)
            end
        end
        wait()
    end
end

-- Sistema ESP
local function createESP(object)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = BillboardGui

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = object.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextScaled = true
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Frame

    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceLabel.TextScaled = true
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.Parent = Frame

    RunService.RenderStepped:Connect(function()
        if object and object:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (object.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
            DistanceLabel.Text = math.floor(distance) .. " studs"
        end
    end)

    return BillboardGui
end

-- Tela de Login
local function createLoginScreen()
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "TheusHubLogin"
    LoginGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = LoginGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0.1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 30
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 18
    KeyInput.Parent = MainFrame

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = KeyInput

    local LoginButton = Instance.new("TextButton")
    LoginButton.Size = UDim2.new(0.8, 0, 0, 40)
    LoginButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    LoginButton.Text = "Login"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.Font = Enum.Font.GothamBold
    LoginButton.TextSize = 18
    LoginButton.Parent = MainFrame

    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = LoginButton

    -- Animação de carregamento
    local function showLoadingScreen()
        LoginGui:Destroy()
        
        local LoadingGui = Instance.new("ScreenGui")
        LoadingGui.Name = "TheusHubLoading"
        LoadingGui.Parent = game.CoreGui

        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
        LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        LoadingFrame.BorderSizePixel = 0
        LoadingFrame.Parent = LoadingGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 15)
        UICorner.Parent = LoadingFrame

        local LoadingText = Instance.new("TextLabel")
        LoadingText.Size = UDim2.new(1, 0, 0, 30)
        LoadingText.Position = UDim2.new(0, 0, 0.2, 0)
        LoadingText.BackgroundTransparency = 1
        LoadingText.Text = "Loading..."
        LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
        LoadingText.TextSize = 24
        LoadingText.Font = Enum.Font.GothamBold
        LoadingText.Parent = LoadingFrame

        local LoadingBar = Instance.new("Frame")
        LoadingBar.Size = UDim2.new(0.8, 0, 0, 10)
        LoadingBar.Position = UDim2.new(0.1, 0, 0.6, 0)
        LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        LoadingBar.BorderSizePixel = 0
        LoadingBar.Parent = LoadingFrame

        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(1, 0)
        UICorner2.Parent = LoadingBar

        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(0, 0, 1, 0)
        Progress.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        Progress.BorderSizePixel = 0
        Progress.Parent = LoadingBar

        local UICorner3 = Instance.new("UICorner")
        UICorner3.CornerRadius = UDim.new(1, 0)
        UICorner3.Parent = Progress

        local function animateLoading()
            local tween = TweenService:Create(Progress, 
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, 0, 1, 0)}
            )
            tween:Play()
            
            tween.Completed:Connect(function()
                wait(0.5)
                LoadingGui:Destroy()
                createMainGUI()
            end)
        end

        animateLoading()
    end

    LoginButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "THEUSHUB" then
            showLoadingScreen()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end
    end)
end-- Interface Principal
local function createMainGUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "TheusHubMain"
    MainGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    -- Barra Superior
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local UICornerTop = Instance.new("UICorner")
    UICornerTop.CornerRadius = UDim.new(0, 15)
    UICornerTop.Parent = TopBar

    -- Botão Fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0.92, 0, 0.1, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar

    local UICornerClose = Instance.new("UICorner")
    UICornerClose.CornerRadius = UDim.new(1, 0)
    UICornerClose.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        MainGui:Destroy()
    end)

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.15, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "THEUS HUB V2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TopBar

    -- Conteúdo Principal
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
    ContentFrame.Position = UDim2.new(0.025, 0, 0.12, 0)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.Parent = MainFrame

    local UICornerContent = Instance.new("UICorner")
    UICornerContent.CornerRadius = UDim.new(0, 10)
    UICornerContent.Parent = ContentFrame

    -- Função para criar botões
    local function createToggleButton(text, position)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 40)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = ContentFrame

        local UICornerButton = Instance.new("UICorner")
        UICornerButton.CornerRadius = UDim.new(0, 8)
        UICornerButton.Parent = Button

        local StatusIndicator = Instance.new("Frame")
        StatusIndicator.Size = UDim2.new(0, 12, 0, 12)
        StatusIndicator.Position = UDim2.new(0.95, -15, 0.5, -6)
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusIndicator.Parent = Button

        local UICornerStatus = Instance.new("UICorner")
        UICornerStatus.CornerRadius = UDim.new(1, 0)
        UICornerStatus.Parent = StatusIndicator

        return Button, StatusIndicator
    end

    -- Criando Botões
    local buttonSpacing = 50
    local currentY = 10

    -- Auto Farm
    local autoFarmButton, autoFarmStatus = createToggleButton("Auto Farm", UDim2.new(0.05, 0, 0, currentY))
    autoFarmButton.MouseButton1Click:Connect(function()
        Settings.AutoFarm = not Settings.AutoFarm
        autoFarmStatus.BackgroundColor3 = Settings.AutoFarm and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        if Settings.AutoFarm then
            spawn(autoFarm)
        end
    end)
    currentY = currentY + buttonSpacing

    -- Fast Attack
    local fastAttackButton, fastAttackStatus = createToggleButton("Fast Attack", UDim2.new(0.05, 0, 0, currentY))
    fastAttackButton.MouseButton1Click:Connect(function()
        Settings.FastAttack = not Settings.FastAttack
        fastAttackStatus.BackgroundColor3 = Settings.FastAttack and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)
    currentY = currentY + buttonSpacing

    -- Auto Skill
    local autoSkillButton, autoSkillStatus = createToggleButton("Auto Skill", UDim2.new(0.05, 0, 0, currentY))
    autoSkillButton.MouseButton1Click:Connect(function()
        Settings.AutoSkill = not Settings.AutoSkill
        autoSkillStatus.BackgroundColor3 = Settings.AutoSkill and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)
    currentY = currentY + buttonSpacing

    -- ESP Mobs
    local espMobsButton, espMobsStatus = createToggleButton("ESP Mobs", UDim2.new(0.05, 0, 0, currentY))
    espMobsButton.MouseButton1Click:Connect(function()
        Settings.ESP.Mobs = not Settings.ESP.Mobs
        espMobsStatus.BackgroundColor3 = Settings.ESP.Mobs and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)
    currentY = currentY + buttonSpacing

    -- Chest Farm
    local chestFarmButton, chestFarmStatus = createToggleButton("Chest Farm", UDim2.new(0.05, 0, 0, currentY))
    chestFarmButton.MouseButton1Click:Connect(function()
        Settings.ChestFarm = not Settings.ChestFarm
        chestFarmStatus.BackgroundColor3 = Settings.ChestFarm and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        if Settings.ChestFarm then
            spawn(chestFarm)
        end
    end)
    currentY = currentY + buttonSpacing

    -- No Clip
    local noClipButton, noClipStatus = createToggleButton("No Clip", UDim2.new(0.05, 0, 0, currentY))
    noClipButton.MouseButton1Click:Connect(function()
        Settings.NoClip = not Settings.NoClip
        noClipStatus.BackgroundColor3 = Settings.NoClip and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)
    currentY = currentY + buttonSpacing

    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, currentY + 10)
end

-- Anti AFK
local function setupAntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Inicialização
createLoginScreen()
setupAntiAFK()