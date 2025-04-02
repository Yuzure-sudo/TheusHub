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
        Mobs = false
    },
    ChestFarm = false,
    AttackSpeed = 0.01, -- Velocidade de ataque aumentada
    HoverHeight = 20
}

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

        -- Animação da barra de progresso
        local function animateLoading()
            local tween = TweenService:Create(Progress, 
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, 0, 1, 0)}
            )
            tween:Play()
            wait(2.5)
            LoadingGui:Destroy()
            createMainGUI()
        end

        animateLoading()
    end

    LoginButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "THEUSHUB" then -- Chave de exemplo
            showLoadingScreen()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end
    end)

    return LoginGui
end

-- Funções de Utilidade
local function getPlayerLevel()
    return Player.Data.Level.Value
end

local function getNearestMob()
    local nearestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

-- Sistema de Auto Farm Melhorado
local function autoFarm()
    while Settings.AutoFarm do
        local mob = getNearestMob()
        if mob then
            local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.HoverHeight, 0)
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            -- Auto attack rápido
            for i = 1, 5 do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(), workspace.CurrentCamera.CFrame)
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                wait(Settings.AttackSpeed)
            end
        end
        wait(Settings.AttackSpeed)
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

-- Sistema de Farm de Baús
local function chestFarm()
    local function collectChest(chest)
        if chest and chest:FindFirstChild("Interaction") then
            Player.Character.HumanoidRootPart.CFrame = chest.CFrame
            wait(0.5)
            fireproximityprompt(chest.Interaction)
        end
    end

    while Settings.ChestFarm do
        for _, chest in pairs(workspace:GetDescendants()) do
            if chest:IsA("Model") and chest.Name:lower():find("chest") then
                collectChest(chest)
            end
        end
        wait(1)
    end
end

-- Interface Principal
local function createMainGUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "TheusHubMain"
    MainGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    -- Scroll Frame para Botões
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
    ScrollFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.Parent = MainFrame

    -- Função para criar botões
    local function createButton(text, position, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 40)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18
        Button.Font = Enum.Font.Gotham
        Button.Parent = ScrollFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Button

        Button.MouseButton1Click:Connect(callback)
        return Button
    end

    -- Botões
    local buttonY = 0
    local buttonSpacing = 50

    -- Auto Farm
    createButton("Auto Farm: OFF", UDim2.new(0.05, 0, 0, buttonY), function()
        Settings.AutoFarm = not Settings.AutoFarm
        if Settings.AutoFarm then
            spawn(autoFarm)
        end
    end)
    buttonY = buttonY + buttonSpacing

    -- ESP
    createButton("ESP Mobs: OFF", UDim2.new(0.05, 0, 0, buttonY), function()
        Settings.ESP.Mobs = not Settings.ESP.Mobs
    end)
    buttonY = buttonY + buttonSpacing

    -- Chest Farm
    createButton("Chest Farm: OFF", UDim2.new(0.05, 0, 0, buttonY), function()
        Settings.ChestFarm = not Settings.ChestFarm
        if Settings.ChestFarm then
            spawn(chestFarm)
        end
    end)
    buttonY = buttonY + buttonSpacing

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, buttonY)
end

-- Inicialização
createLoginScreen()-- Sistema de Atualização e Monitoramento
RunService.Heartbeat:Connect(function()
    if Settings.ESP.Mobs then
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if not mob:FindFirstChild("ESP") and mob:FindFirstChild("HumanoidRootPart") then
                local esp = createESP(mob)
                esp.Parent = mob
                esp.Name = "ESP"
                esp.Adornee = mob.HumanoidRootPart
            end
        end
    end
end)

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Sistema de Proteção
local function setupProtection()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and self.Name == "ReportPlayer" then
            return
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

setupProtection()

-- Otimizações
settings().Physics.PhysicsEnvironmentalThrottle = 1
settings().Rendering.QualityLevel = 1

-- Inicialização de Variáveis Globais
_G.TheusHub = {
    Settings = Settings,
    Functions = {
        AutoFarm = autoFarm,
        ChestFarm = chestFarm,
        CreateESP = createESP
    }
}