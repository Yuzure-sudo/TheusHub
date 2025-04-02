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
        Fruits = false
    },
    ChestFarm = false,
    AttackSpeed = 0.1,
    HoverHeight = 20
}

-- Coordenadas das Ilhas
local IslandLocations = {
    ["Pirates Starter Island"] = Vector3.new(1071.2832, 16.3085, 1426.9067),
    ["Marine Starter Island"] = Vector3.new(-2573.3374, 6.8556, 2046.4116),
    ["Middle Town"] = Vector3.new(-655.824, 7.8522, 1436.7795),
    ["Jungle"] = Vector3.new(-1249.7722, 11.8522, 341.8347),
    ["Pirate Village"] = Vector3.new(-1122.3716, 4.7520, 3855.1777),
    ["Desert"] = Vector3.new(894.4332, 6.8557, 4390.8501),
    ["Frozen Village"] = Vector3.new(1389.7837, 87.3678, -1298.1067)
}

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

-- Sistema de Auto Farm
local function autoFarm()
    while Settings.AutoFarm do
        local mob = getNearestMob()
        if mob then
            local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.HoverHeight, 0)
            local humanoidRootPart = Player.Character.HumanoidRootPart
            
            -- Teleport above mob
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            -- Auto attack
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(), workspace.CurrentCamera.CFrame)
        end
        wait(Settings.AttackSpeed)
    end
end

-- Sistema de ESP
local function createESP(object, espType)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP"
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    esp.AlwaysOnTop = true
    esp.Parent = object

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.Parent = esp

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = object.Name
    nameLabel.TextColor3 = (espType == "player" and Color3.new(1, 0, 0)) or 
                          (espType == "fruit" and Color3.new(0, 1, 0)) or 
                          Color3.new(1, 1, 1)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
end

-- Interface Principal
local function createMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TheusHub"
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.8, 0, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Theus Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    -- Botões
    local function createButton(text, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.8, 0, 0, 30)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.Parent = MainFrame
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        return button
    end
    
    -- Auto Farm Button
    createButton("Auto Farm", UDim2.new(0.1, 0, 0.2, 0), function()
        Settings.AutoFarm = not Settings.AutoFarm
        if Settings.AutoFarm then
            autoFarm()
        end
    end)
    
    -- ESP Button
    createButton("ESP Players", UDim2.new(0.1, 0, 0.3, 0), function()
        Settings.ESP.Players = not Settings.ESP.Players
    end)
    
    -- Chest Farm Button
    createButton("Chest Farm", UDim2.new(0.1, 0, 0.4, 0), function()
        Settings.ChestFarm = not Settings.ChestFarm
    end)
end

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)-- Sistema de Chest Farm
local function chestFarm()
    while Settings.ChestFarm do
        for _, chest in pairs(workspace:GetChildren()) do
            if chest.Name:find("Chest") and chest:FindFirstChild("Hitbox") then
                local targetPosition = chest.Hitbox.Position + Vector3.new(0, 2, 0)
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                wait(0.5)
                
                -- Tentar coletar o baú
                local args = {
                    [1] = "CollectChest",
                    [2] = chest
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end
        wait(1)
    end
end

-- Sistema de Teleporte
local function createTeleportMenu()
    local TeleportFrame = Instance.new("Frame")
    TeleportFrame.Name = "TeleportMenu"
    TeleportFrame.Size = UDim2.new(0, 200, 0, 300)
    TeleportFrame.Position = UDim2.new(0, 0, 0.5, -150)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TeleportFrame.Visible = false
    TeleportFrame.Parent = game.CoreGui:FindFirstChild("TheusHub").MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = TeleportFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "Teleport Menu"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TeleportFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -40)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 35)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.Parent = TeleportFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollingFrame

    for islandName, position in pairs(IslandLocations) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = islandName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.Parent = ScrollingFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = button

        button.MouseButton1Click:Connect(function()
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
        end)
    end

    return TeleportFrame
end

-- Update ESP
local function updateESP()
    if Settings.ESP.Players then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character and not player.Character:FindFirstChild("ESP") then
                createESP(player.Character, "player")
            end
        end
    end

    if Settings.ESP.Fruits then
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") and not fruit:FindFirstChild("ESP") then
                createESP(fruit, "fruit")
            end
        end
    end
end

-- Monitor de Frutas
workspace.ChildAdded:Connect(function(child)
    if child.Name:find("Fruit") and Settings.ESP.Fruits then
        createESP(child, "fruit")
    end
end)

-- Inicialização
local function init()
    createMainGUI()
    local teleportMenu = createTeleportMenu()
    
    -- Botão de Teleporte
    local teleportButton = Instance.new("TextButton")
    teleportButton.Size = UDim2.new(0.8, 0, 0, 30)
    teleportButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    teleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    teleportButton.Text = "Teleport Menu"
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.Font = Enum.Font.Gotham
    teleportButton.Parent = game.CoreGui:FindFirstChild("TheusHub").MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = teleportButton

    teleportButton.MouseButton1Click:Connect(function()
        teleportMenu.Visible = not teleportMenu.Visible
    end)

    -- Update Loop
    RunService.RenderStepped:Connect(function()
        if Settings.ESP.Players or Settings.ESP.Fruits then
            updateESP()
        end
    end)
end

-- Iniciar o script
init()

-- Retornar configurações para acesso externo
return {
    Settings = Settings,
    IslandLocations = IslandLocations
}