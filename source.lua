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

-- Sistema de Key
local function createLoadingScreen()
    local LoadingGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local KeyInput = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local LoadingBar = Instance.new("Frame")
    local BarFill = Instance.new("Frame")

    LoadingGui.Name = "TheusHubLoader"
    LoadingGui.Parent = game.CoreGui

    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = LoadingGui

    Title.Text = "Theus Hub"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Parent = MainFrame

    SubmitButton.Text = "Submit"
    SubmitButton.Size = UDim2.new(0.4, 0, 0, 30)
    SubmitButton.Position = UDim2.new(0.3, 0, 0.7, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SubmitButton.TextColor3 = Color3.new(1, 1, 1)
    SubmitButton.Parent = MainFrame

    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(0.8, 0, 0, 10)
    LoadingBar.Position = UDim2.new(0.1, 0, 0.9, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LoadingBar.Parent = MainFrame

    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    BarFill.Parent = LoadingBar

    return LoadingGui, BarFill, KeyInput, SubmitButton
end

local function checkKey(key)
    return key == "theusgostoso"
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

local function getQuestNPC()
    local level = getPlayerLevel()
    -- Adicione lógica para determinar o NPC de quest adequado com base no nível
    -- Este é um exemplo simplificado
    return workspace.QuestNPCs:FindFirstChild("QuestNPC")
end

-- Sistema de Teleporte
local IslandLocations = {
    ["Starter Island"] = Vector3.new(0, 0, 0),
    ["Marine Island"] = Vector3.new(1000, 0, 1000),
    ["Desert Island"] = Vector3.new(-1000, 0, -1000),
    -- Adicione mais ilhas conforme necessário
}

local function teleportTo(position)
    local humanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- ESP System
local function createESPElement(parent, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 5, 0, 5)
    frame.BackgroundColor3 = color
    frame.Parent = billboard

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.Text = parent.Name
    textLabel.Parent = billboard

    return billboard
end

local function updateESP()
    if Settings.ESP.Players then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                if not player.Character:FindFirstChild("ESP") then
                    createESPElement(player.Character, Color3.new(1, 0, 0))
                end
            end
        end
    end

    if Settings.ESP.Fruits then
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
                if not fruit:FindFirstChild("ESP") then
                    createESPElement(fruit, Color3.new(0, 1, 0))
                end
            end
        end
    end
end

-- Auto Farm
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

-- Auto Chest Farm
local function autoChestFarm()
    while Settings.ChestFarm do
        for _, chest in pairs(workspace:GetChildren()) do
            if chest.Name:find("Chest") then
                local targetPosition = chest.Position
                teleportTo(targetPosition)
                wait(1)
                -- Simulate chest collection
                fireserver("CollectChest", chest)
            end
        end
        wait(1)
    end
end

-- Interface Principal
local function createMainGUI()
    local GUI = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local ButtonsFrame = Instance.new("Frame")
    
    -- Adicione botões para todas as funcionalidades
    local buttons = {
        {name = "Auto Farm", callback = function() Settings.AutoFarm = not Settings.AutoFarm if Settings.AutoFarm then autoFarm() end end},
        {name = "ESP Players", callback = function() Settings.ESP.Players = not Settings.ESP.Players end},
        {name = "ESP Fruits", callback = function() Settings.ESP.Fruits = not Settings.ESP.Fruits end},
        {name = "Chest Farm", callback = function() Settings.ChestFarm = not Settings.ChestFarm if Settings.ChestFarm then autoChestFarm() end end}
    }

    -- Crie os botões dinamicamente
    for i, buttonInfo in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Text = buttonInfo.name
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Position = UDim2.new(0.05, 0, 0.1 + (i-1) * 0.1, 0)
        button.Parent = ButtonsFrame
        button.MouseButton1Click:Connect(buttonInfo.callback)
    end

    -- Adicione o menu de teleporte
    local TeleportMenu = Instance.new("Frame")
    local TeleportList = Instance.new("ScrollingFrame")
    
    for islandName, position in pairs(IslandLocations) do
        local teleportButton = Instance.new("TextButton")
        teleportButton.Text = islandName
        teleportButton.MouseButton1Click:Connect(function()
            teleportTo(position)
        end)
        teleportButton.Parent = TeleportList
    end

    return GUI
end

-- Inicialização
local LoadingGui, BarFill, KeyInput, SubmitButton = createLoadingScreen()

SubmitButton.MouseButton1Click:Connect(function()
    if checkKey(KeyInput.Text) then
        -- Animate loading bar
        TweenService:Create(BarFill, TweenInfo.new(1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        wait(1)
        LoadingGui:Destroy()
        
        -- Initialize main script
        local MainGUI = createMainGUI()
        MainGUI.Parent = game.CoreGui
        
        -- Start ESP update loop
        RunService.RenderStepped:Connect(updateESP)
    else
        KeyInput.Text = "Invalid Key!"
        wait(1)
        KeyInput.Text = ""
    end
end)

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
```

E aqui está o `loader.lua` atualizado:

```lua
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/source.lua"))()-- Configurações específicas do Blox Fruits
local QuestData = {
    [1] = {
        NPC = "Marine Recruiter",
        Quest = "MarineQuest",
        Mob = "Marine",
        Level = 1
    },
    [10] = {
        NPC = "Monkey",
        Quest = "MonkeyQuest",
        Mob = "Monkey",
        Level = 10
    },
    [15] = {
        NPC = "Gorilla",
        Quest = "GorillaQuest",
        Mob = "Gorilla",
        Level = 15
    },
    -- Adicione mais quests conforme o nível
}

-- Coordenadas exatas das ilhas
local IslandLocations = {
    ["Pirates Starter Island"] = Vector3.new(1071.2832, 16.3085, 1426.9067),
    ["Marine Starter Island"] = Vector3.new(-2573.3374, 6.8556, 2046.4116),
    ["Middle Town"] = Vector3.new(-655.824, 7.8522, 1436.7795),
    ["Jungle"] = Vector3.new(-1249.7722, 11.8522, 341.8347),
    ["Pirate Village"] = Vector3.new(-1122.3716, 4.7520, 3855.1777),
    ["Desert"] = Vector3.new(894.4332, 6.8557, 4390.8501),
    ["Frozen Village"] = Vector3.new(1389.7837, 87.3678, -1298.1067),
    ["MarineBase"] = Vector3.new(-4505.375, 20.687, 4260.568),
    ["Skylands"] = Vector3.new(-4970.21875, 717.707275, -2622.35449),
    ["Colosseum"] = Vector3.new(-1836.97, 44.8557, 1360.93)
}

-- Configurações de combate
local CombatSettings = {
    HoverHeight = 20,
    AttackSpeed = 0.1,
    AttackRange = 10,
    AutoEquipWeapon = true,
    SafeDistance = 15
}

-- Função melhorada para pegar quest
local function getQuestBasedOnLevel()
    local playerLevel = getPlayerLevel()
    local bestQuest = nil
    
    for reqLevel, questInfo in pairs(QuestData) do
        if playerLevel >= reqLevel then
            bestQuest = questInfo
        end
    end
    
    return bestQuest
end

-- Função para equipar melhor arma
local function equipBestWeapon()
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        local bestWeapon = nil
        local highestDamage = 0
        
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local damage = tool:FindFirstChild("Damage") and tool.Damage.Value or 0
                if damage > highestDamage then
                    highestDamage = damage
                    bestWeapon = tool
                end
            end
        end
        
        if bestWeapon then
            bestWeapon.Parent = Player.Character
        end
    end
end

-- Função melhorada de Auto Farm
local function enhancedAutoFarm()
    while Settings.AutoFarm do
        local currentQuest = getQuestBasedOnLevel()
        if currentQuest then
            -- Pegar quest
            local questNPC = workspace.NPCs:FindFirstChild(currentQuest.NPC)
            if questNPC then
                local npcPosition = questNPC.HumanoidRootPart.Position
                teleportTo(npcPosition)
                wait(1)
                -- Simular diálogo com NPC
                local args = {
                    [1] = "StartQuest",
                    [2] = currentQuest.Quest
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                wait(0.5)
            end
            
            -- Procurar e atacar mobs
            local mob = getNearestMob()
            if mob then
                if CombatSettings.AutoEquipWeapon then
                    equipBestWeapon()
                end
                
                -- Posicionar acima do mob
                local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, CombatSettings.HoverHeight, 0)
                local humanoidRootPart = Player.Character.HumanoidRootPart
                
                -- Tween para posição
                local tweenInfo = TweenInfo.new(
                    0.5,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                
                local tween = TweenService:Create(
                    humanoidRootPart,
                    tweenInfo,
                    {CFrame = CFrame.new(targetPosition)}
                )
                tween:Play()
                
                -- Auto attack melhorado
                for i = 1, 5 do
                    local args = {
                        [1] = "Combat",
                        [2] = mob.HumanoidRootPart.Position
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    wait(CombatSettings.AttackSpeed)
                end
            end
        end
        wait(0.1)
    end
end

-- Sistema de ESP melhorado
local function createAdvancedESP(object, espType)
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

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "Calculating..."
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = frame

    -- Atualizar distância
    RunService.RenderStepped:Connect(function()
        if object and object:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (object.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            distanceLabel.Text = string.format("%.0f studs", distance)
        end
    end)
end