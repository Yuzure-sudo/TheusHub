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

-- Sistema de Auto Chest Farm melhorado
local ChestSettings = {
    MinimumDistance = 50,
    MaximumDistance = 5000,
    CollectDelay = 1,
    IgnoreList = {},
    ChestTypes = {
        "Chest",
        "Chest1",
        "Chest2",
        "Chest3"
    }
}

local function isChest(object)
    for _, chestType in ipairs(ChestSettings.ChestTypes) do
        if object.Name:find(chestType) then
            return true
        end
    end
    return false
end

local function enhancedChestFarm()
    while Settings.ChestFarm do
        local nearestChest = nil
        local shortestDistance = ChestSettings.MaximumDistance

        for _, object in pairs(workspace:GetChildren()) do
            if isChest(object) and not ChestSettings.IgnoreList[object] then
                local distance = (object.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance and distance > ChestSettings.MinimumDistance then
                    shortestDistance = distance
                    nearestChest = object
                end
            end
        end

        if nearestChest then
            -- Tween para o baú
            local tweenInfo = TweenInfo.new(
                (shortestDistance/1000), -- Tempo baseado na distância
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            
            local tween = TweenService:Create(
                Player.Character.HumanoidRootPart,
                tweenInfo,
                {CFrame = CFrame.new(nearestChest.Position + Vector3.new(0, 2, 0))}
            )
            tween:Play()
            tween.Completed:Wait()

            -- Tentar coletar o baú
            local args = {
                [1] = "CollectChest",
                [2] = nearestChest
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            
            -- Adicionar à lista de ignorados
            ChestSettings.IgnoreList[nearestChest] = true
            wait(ChestSettings.CollectDelay)
        else
            wait(1)
        end
    end
end

-- Sistema de Frutas melhorado
local FruitSettings = {
    AutoCollect = false,
    NotifyOnSpawn = true,
    MinimumDistance = 50,
    MaximumDistance = 5000,
    CollectDelay = 1
}

local function isFruit(object)
    return object.Name:find("Fruit") ~= nil
end

local function notifyFruit(fruitName, position)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(0.7, 0, 0.8 - (#workspace:GetChildren() * 0.05), 0)
    notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notification.BackgroundTransparency = 0.5
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Text = fruitName .. " spawned!"
    notification.Parent = game.CoreGui
    
    game:GetService("Debris"):AddItem(notification, 5)
end

-- Monitor de Frutas
workspace.ChildAdded:Connect(function(child)
    if isFruit(child) and FruitSettings.NotifyOnSpawn then
        notifyFruit(child.Name, child.Position)
        
        if FruitSettings.AutoCollect then
            local distance = (child.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance < FruitSettings.MaximumDistance then
                local tweenInfo = TweenInfo.new(
                    (distance/1000),
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                
                local tween = TweenService:Create(
                    Player.Character.HumanoidRootPart,
                    tweenInfo,
                    {CFrame = CFrame.new(child.Position + Vector3.new(0, 2, 0))}
                )
                tween:Play()
            end
        end
    end
end)

-- Interface melhorada
local function createEnhancedGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TheusHubEnhanced"
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
    
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "Tabs"
    TabsFrame.Size = UDim2.new(1, 0, 0, 30)
    TabsFrame.Position = UDim2.new(0, 0, 0, 40)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = MainFrame
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, -70)
    ContentFrame.Position = UDim2.new(0, 0, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Criar tabs
    local tabs = {
        {name = "Farm", content = {
            {type = "toggle", text = "Auto Farm", callback = function(value) 
                Settings.AutoFarm = value 
                if value then enhancedAutoFarm() end 
            end},
            {type = "toggle", text = "Chest Farm", callback = function(value) 
                Settings.ChestFarm = value 
                if value then enhancedChestFarm() end 
            end},
            {type = "toggle", text = "Auto Fruit", callback = function(value) 
                FruitSettings.AutoCollect = value 
            end}
        }},
        {name = "Teleport", content = IslandLocations},
        {name = "Combat", content = {
            {type = "slider", text = "Attack Speed", min = 0.1, max = 2, default = CombatSettings.AttackSpeed},
            {type = "slider", text = "Hover Height", min = 10, max = 50, default = CombatSettings.HoverHeight}
        }},
        {name = "ESP", content = {
            {type = "toggle", text = "Player ESP", callback = function(value) Settings.ESP.Players = value end},
            {type = "toggle", text = "Fruit ESP", callback = function(value) Settings.ESP.Fruits = value end}
        }}
    }    -- Função para criar botão de tab
    local function createTab(name, index)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
        TabButton.Position = UDim2.new((index-1)/#tabs, 0, 0, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabsFrame
        return TabButton
    end

    -- Função para criar conteúdo
    local function createContent(contentInfo)
        local Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1, -20, 1, -10)
        Container.Position = UDim2.new(0, 10, 0, 5)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 4
        Container.Visible = false
        Container.Parent = ContentFrame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = Container

        for i, item in ipairs(contentInfo) do
            if item.type == "toggle" then
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(1, 0, 0, 40)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                ToggleButton.Text = item.text
                ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.Parent = Container

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = ToggleButton

                local ToggleState = false
                ToggleButton.MouseButton1Click:Connect(function()
                    ToggleState = not ToggleState
                    ToggleButton.BackgroundColor3 = ToggleState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
                                        if item.callback then
                        item.callback(ToggleState)
                    end
                end)
            elseif item.type == "slider" then
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 60)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                SliderFrame.Parent = Container

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = SliderFrame

                local SliderText = Instance.new("TextLabel")
                SliderText.Size = UDim2.new(1, 0, 0, 30)
                SliderText.BackgroundTransparency = 1
                SliderText.Text = item.text .. ": " .. item.default
                SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderText.Font = Enum.Font.Gotham
                SliderText.Parent = SliderFrame

                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(0.9, 0, 0, 4)
                SliderBar.Position = UDim2.new(0.05, 0, 0.7, 0)
                SliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                SliderBar.Parent = SliderFrame

                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((item.default - item.min)/(item.max - item.min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                SliderFill.Parent = SliderBar

                local UICorner2 = Instance.new("UICorner")
                UICorner2.CornerRadius = UDim.new(1, 0)
                UICorner2.Parent = SliderBar

                local UICorner3 = Instance.new("UICorner")
                UICorner3.CornerRadius = UDim.new(1, 0)
                UICorner3.Parent = SliderFill

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local dragging = true
                        
                        local function update()
                            local mousePos = UserInputService:GetMouseLocation().X
                            local barPos = SliderBar.AbsolutePosition.X
                            local barWidth = SliderBar.AbsoluteSize.X
                            local percent = math.clamp((mousePos - barPos) / barWidth, 0, 1)
                            local value = item.min + (item.max - item.min) * percent
                            
                            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                            SliderText.Text = item.text .. ": " .. string.format("%.1f", value)
                            
                            if item.callback then
                                item.callback(value)
                            end
                        end

                        RunService.RenderStepped:Connect(function()
                            if dragging then
                                update()
                            end
                        end)

                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)
            end
        end

        return Container
    end

    -- Criar todas as tabs e conteúdo
    local tabButtons = {}
    local tabContents = {}
    
    for i, tab in ipairs(tabs) do
        local button = createTab(tab.name, i)
        local content = createContent(tab.content)
        
        tabButtons[tab.name] = button
        tabContents[tab.name] = content
        
        button.MouseButton1Click:Connect(function()
            for _, btn in pairs(tabButtons) do
                btn.BackgroundTransparency = 1
            end
            for _, cont in pairs(tabContents) do
                cont.Visible = false
            end
            
            button.BackgroundTransparency = 0.8
            content.Visible = true
        end)
        
        if i == 1 then
            button.BackgroundTransparency = 0.8
            content.Visible = true
        end
    end

    -- Tornar a interface arrastável
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Inicializar
createEnhancedGUI()

-- Começar loops de atualização
RunService.RenderStepped:Connect(function()
    if Settings.ESP.Players or Settings.ESP.Fruits then
        updateESP()
    end
end)

-- Retornar configurações para acesso externo
return {
    Settings = Settings,
    CombatSettings = CombatSettings,
    FruitSettings = FruitSettings,
    ChestSettings = ChestSettings
}