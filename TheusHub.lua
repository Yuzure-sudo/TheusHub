-- Blox Fruits Ultimate Script (Parte 1/10)
-- Interface e Sistemas Base

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Configurações Globais
getgenv().Config = {
    AutoFarm = false,
    FastAttack = false,
    AutoHaki = false,
    AutoStats = false,
    NoClip = false,
    RemoveDamageAnimation = true,
    BringMob = true,
    DistanceMob = 15,
    TweenSpeed = 325,
    SelectWeapon = "Combat",
    AutoRejoin = true,
    WhiteScreen = false,
    
    -- Stats
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    DemonFruit = false,
    
    -- Farming Method
    FarmMode = "Level",
    LockMob = false,
    SkipQuest = false,
    
    -- Auto Raid
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoAwaken = false,
    
    -- Auto Buy
    AutoBuyHaki = false,
    AutoBuySwords = false,
    AutoBuyFightingStyles = false,
    
    -- Fruit
    AutoStoreFruit = false,
    SelectedFruit = "None",
    FruitSniper = false,
    
    -- Misc
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    InfiniteStamina = false,
    NoDodgeCooldown = false
}

-- Interface Principal
local BloxFruits = Instance.new("ScreenGui")
BloxFruits.Name = "BloxFruits"
BloxFruits.Parent = game.CoreGui
BloxFruits.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = BloxFruits
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Ultimate"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.Size = UDim2.new(0, 150, 1, -30)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 150, 0, 30)
ContentContainer.Size = UDim2.new(1, -150, 1, -30)

-- Funções de Interface
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.Position = UDim2.new(0, 0, 0, (#TabContainer:GetChildren()-1) * 40)
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name.."Page"
    TabPage.Parent = ContentContainer
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.ScrollBarThickness = 4
    TabPage.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabPage
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = TabPage
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    
    return TabButton, TabPage
end

local function CreateToggle(parent, text, config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text.."Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.Text = ""
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.TextSize = 14
    
    local ToggleText = Instance.new("TextLabel")
    ToggleText.Parent = ToggleFrame
    ToggleText.BackgroundTransparency = 1
    ToggleText.Position = UDim2.new(0, 10, 0, 0)
    ToggleText.Size = UDim2.new(1, -70, 1, 0)
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.Text = text
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.TextSize = 14
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config[config] = not Config[config]
        ToggleButton.BackgroundColor3 = Config[config] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
    
    return ToggleFrame
end

-- Criação das Tabs
local MainTab, MainPage = CreateTab("Main")
local StatsTab, StatsPage = CreateTab("Stats")
local TeleportTab, TeleportPage = CreateTab("Teleport")
local RaidTab, RaidPage = CreateTab("Raid")
local ShopTab, ShopPage = CreateTab("Shop")
local FruitTab, FruitPage = CreateTab("Fruit")
local MiscTab, MiscPage = CreateTab("Misc")
local SettingsTab, SettingsPage = CreateTab("Settings")

-- Sistema de Troca de Tabs
local function SwitchTab(tabName)
    for _, page in pairs(ContentContainer:GetChildren()) do
        if page:IsA("ScrollingFrame") then
            page.Visible = page.Name == tabName.."Page"
        end
    end
end

for _, button in pairs(TabContainer:GetChildren()) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            SwitchTab(button.Text)
        end)
    end
end

-- Mostrar primeira tab por padrão
SwitchTab("Main")

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Blox Fruits Ultimate Script (Parte 2/10 - Sistema de Farm e Quest)
local TweenService = game:GetService("TweenService")
local Interface = require(script.Parent:WaitForChild("Part9")) -- Carrega a interface da Parte 9

-- Tabela de Mobs e Quests
local MobsTable = {
    ['First Sea'] = {
        ['Bandit'] = {
            Quest = {
                Name = "BanditQuest1",
                LevelReq = 1,
                NameQuest = "Bandit Quest",
                QuestLabel = "Bandits (Lv. 1+)",
                CFrame = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            },
            Name = "Bandit",
            CFrameSpawn = CFrame.new(1158.19141, 16.7761021, 1598.75867)
        },
        ['Monkey'] = {
            Quest = {
                Name = "MonkeyQuest",
                LevelReq = 14,
                NameQuest = "Monkey Quest",
                QuestLabel = "Monkey (Lv. 14+)",
                CFrame = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            },
            Name = "Monkey",
            CFrameSpawn = CFrame.new(-1448.51806, 50.851993, 102.934296)
        },
        -- Adicionar mais mobs do First Sea aqui
    },
    ['Second Sea'] = {
        ['Marine Captain'] = {
            Quest = {
                Name = "MarineQuest2",
                LevelReq = 700,
                NameQuest = "Marine Captain Quest",
                QuestLabel = "Marine Captain (Lv. 700+)",
                CFrame = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
            },
            Name = "Marine Captain",
            CFrameSpawn = CFrame.new(-2510.79639, 71.7140732, -3066.06812)
        },
        -- Adicionar mais mobs do Second Sea aqui
    },
    ['Third Sea'] = {
        ['Pirate Millionaire'] = {
            Quest = {
                Name = "PirateMillionaireQuest",
                LevelReq = 1500,
                NameQuest = "Pirate Millionaire Quest",
                QuestLabel = "Pirate Millionaire (Lv. 1500+)",
                CFrame = CFrame.new(-290.074677, 42.9034653, 5581.58984)
            },
            Name = "Pirate Millionaire",
            CFrameSpawn = CFrame.new(-290.074677, 42.9034653, 5581.58984)
        },
        -- Adicionar mais mobs do Third Sea aqui
    }
}

-- Configurações de Farm
local FarmConfig = {
    FarmMode = "Auto", -- "Auto" ou "Manual"
    FarmTarget = nil, -- Inimigo alvo
    FarmDistance = 15, -- Distância de farm
    FarmSpeed = 50, -- Velocidade de farm
    FarmEnabled = false -- Flag para ativar/desativar farm
}

-- Configurações de Quest
local QuestConfig = {
    QuestEnabled = false, -- Flag para ativar/desativar quest
    CurrentQuest = nil, -- Quest atual
    QuestReward = 0 -- Recompensa da quest
}

-- Função para iniciar o farm
local function StartFarm()
    FarmConfig.FarmEnabled = true
    -- Lógica de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not FarmConfig.FarmEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0
        end
    end
end

-- Função para parar o farm
local function StopFarm()
    FarmConfig.FarmEnabled = false
    -- Lógica de parada de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Função para iniciar a quest
local function StartQuest()
    QuestConfig.QuestEnabled = true
    -- Lógica de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Level = Player.Data.Level.Value
    
    -- Encontrar Quest apropriada para o nível
    local CurrentSea = game.PlaceId == 2753915549 and "First Sea" or game.PlaceId == 4442272183 and "Second Sea" or "Third Sea"
    local CurrentQuest = nil
    local CurrentMob = nil
    
    for _, MobData in pairs(MobsTable[CurrentSea]) do
        if Level >= MobData.Quest.LevelReq then
            CurrentQuest = MobData.Quest
            CurrentMob = MobData
        end
    end
    
    if not CurrentQuest then return end
    
    -- Pegar Quest se não tiver
    if not Player.PlayerGui.Main.Quest.Visible then
        HumanoidRootPart.CFrame = CurrentQuest.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", CurrentQuest.Name, CurrentQuest.LevelReq)
        wait(0.5)
    end
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy.Name == CurrentMob.Name and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not QuestConfig.QuestEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0 or not Player.PlayerGui.Main.Quest.Visible
        end
    end
end

-- Função para parar a quest
local function StopQuest()
    QuestConfig.QuestEnabled = false
    -- Lógica de parada de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Criar botões de farm e quest na interface
local FarmButton = Interface.CreateTab("Farm")
FarmButton.MouseButton1Click:Connect(function()
    if FarmConfig.FarmEnabled then
        StopFarm()
    else
        StartFarm()
    end
end)

local QuestButton = Interface.CreateTab("Quest")
QuestButton.MouseButton1Click:Connect(function()
    if QuestConfig.QuestEnabled then
        StopQuest()
    else
        StartQuest()
    end
end)

-- Atualizar o status dos botões de farm e quest
local function UpdateFarmQuestStatus()
    if FarmConfig.FarmEnabled then
        FarmButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        FarmButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end

    if QuestConfig.QuestEnabled then
        QuestButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        QuestButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end
end

-- Loop principal
while true do
    wait(1)
    UpdateFarmQuestStatus()
    -- Lógica de farm e quest aqui
end

-- Blox Fruits Ultimate Script (Parte 3/10)
-- Sistemas de Raids e Dungeons

-- Configurações de Raid
local RaidConfig = {
    Raids = {
        "Flame",
        "Ice",
        "Quake",
        "Light",
        "Dark",
        "String",
        "Rumble",
        "Magma",
        "Human: Buddha",
        "Sand",
        "Bird: Phoenix",
        "Dough"
    },
    
    ChipNames = {
        ["Flame"] = "Flame",
        ["Ice"] = "Ice",
        ["Quake"] = "Quake",
        ["Light"] = "Light",
        ["Dark"] = "Dark",
        ["String"] = "String",
        ["Rumble"] = "Rumble",
        ["Magma"] = "Magma",
        ["Human: Buddha"] = "Human: Buddha",
        ["Sand"] = "Sand",
        ["Bird: Phoenix"] = "Bird: Phoenix",
        ["Dough"] = "Dough"
    }
}

-- Funções de Raid
function BuyChip()
    local args = {
        [1] = "RaidsNpc",
        [2] = "Select",
        [3] = Config.SelectedRaid
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function StartRaid()
    local args = {
        [1] = "Raid",
        [2] = "Start"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

local function GetRaidIsland()
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        if string.find(v.Name, "Island") then
            return v
        end
    end
end

-- Sistema de Auto Raid
function AutoRaid()
    if not Config.AutoRaid then return end
    
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Verificar se está em Raid
    if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible then
        -- Durante o Raid
        local RaidIsland = GetRaidIsland()
        if RaidIsland then
            HumanoidRootPart.CFrame = RaidIsland.CFrame * CFrame.new(0, 80, 0)
        end
        
        -- Atacar mobs do Raid
        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                repeat
                    wait()
                    
                    -- Auto Haki
                    if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                    end
                    
                    -- Bring Mob
                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    v.HumanoidRootPart.Transparency = 0.8
                    v.Humanoid.JumpPower = 0
                    v.Humanoid.WalkSpeed = 0
                    
                    HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    
                    if Config.FastAttack then
                        AttackFunction()
                    end
                    
                until not Config.AutoRaid or not v.Parent or v.Humanoid.Health <= 0
            end
        end
    else
        -- Fora do Raid
        if Player.Data.Level.Value >= 1100 then
            -- Comprar e usar chip
            BuyChip()
            wait(1)
            StartRaid()
        end
    end
end

-- Sistema de Auto Awakening
function AutoAwaken()
    if not Config.AutoAwaken then return end
    
    local args = {
        [1] = "Awakener",
        [2] = "Check"
    }
    
    local AwakeningStatus = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    
    if AwakeningStatus == true then
        local args = {
            [1] = "Awakener",
            [2] = "Awaken"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end

-- Interface de Raid
local RaidSection = Instance.new("Frame")
RaidSection.Name = "RaidSection"
RaidSection.Parent = RaidPage
RaidSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RaidSection.BorderSizePixel = 0
RaidSection.Size = UDim2.new(1, -20, 0, 200)

local RaidTitle = Instance.new("TextLabel")
RaidTitle.Name = "RaidTitle"
RaidTitle.Parent = RaidSection
RaidTitle.BackgroundTransparency = 1
RaidTitle.Position = UDim2.new(0, 10, 0, 5)
RaidTitle.Size = UDim2.new(1, -20, 0, 20)
RaidTitle.Font = Enum.Font.GothamBold
RaidTitle.Text = "Raid Settings"
RaidTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RaidTitle.TextSize = 14
RaidTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown para selecionar Raid
local RaidDropdown = Instance.new("Frame")
RaidDropdown.Name = "RaidDropdown"
RaidDropdown.Parent = RaidSection
RaidDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RaidDropdown.BorderSizePixel = 0
RaidDropdown.Position = UDim2.new(0, 10, 0, 35)
RaidDropdown.Size = UDim2.new(1, -20, 0, 30)

local RaidSelected = Instance.new("TextLabel")
RaidSelected.Name = "RaidSelected"
RaidSelected.Parent = RaidDropdown
RaidSelected.BackgroundTransparency = 1
RaidSelected.Size = UDim2.new(1, -30, 1, 0)
RaidSelected.Font = Enum.Font.GothamSemibold
RaidSelected.Text = Config.SelectedRaid
RaidSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
RaidSelected.TextSize = 14
RaidSelected.TextXAlignment = Enum.TextXAlignment.Left
RaidSelected.Position = UDim2.new(0, 10, 0, 0)

local DropdownButton = Instance.new("TextButton")
DropdownButton.Name = "DropdownButton"
DropdownButton.Parent = RaidDropdown
DropdownButton.BackgroundTransparency = 1
DropdownButton.Position = UDim2.new(1, -30, 0, 0)
DropdownButton.Size = UDim2.new(0, 30, 1, 0)
DropdownButton.Font = Enum.Font.GothamBold
DropdownButton.Text = "▼"
DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownButton.TextSize = 14

local DropdownContent = Instance.new("Frame")
DropdownContent.Name = "DropdownContent"
DropdownContent.Parent = RaidDropdown
DropdownContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DropdownContent.BorderSizePixel = 0
DropdownContent.Position = UDim2.new(0, 0, 1, 0)
DropdownContent.Size = UDim2.new(1, 0, 0, #RaidConfig.Raids * 30)
DropdownContent.Visible = false
DropdownContent.ZIndex = 2

-- Criar botões para cada Raid
for i, raid in ipairs(RaidConfig.Raids) do
    local RaidButton = Instance.new("TextButton")
    RaidButton.Name = raid
    RaidButton.Parent = DropdownContent
    RaidButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    RaidButton.BorderSizePixel = 0
    RaidButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
    RaidButton.Size = UDim2.new(1, 0, 0, 30)
    RaidButton.Font = Enum.Font.GothamSemibold
    RaidButton.Text = raid
    RaidButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RaidButton.TextSize = 14
    RaidButton.ZIndex = 2
    
    RaidButton.MouseButton1Click:Connect(function()
        Config.SelectedRaid = raid
        RaidSelected.Text = raid
        DropdownContent.Visible = false
    end)
end

DropdownButton.MouseButton1Click:Connect(function()
    DropdownContent.Visible = not DropdownContent.Visible
end)

-- Toggles de Raid
local AutoRaidToggle = CreateToggle(RaidSection, "Auto Raid", "AutoRaid")
local AutoAwakenToggle = CreateToggle(RaidSection, "Auto Awaken", "AutoAwaken")

-- Iniciar loops de Raid
spawn(function()
    while wait() do
        pcall(function()
            if Config.AutoRaid then
                AutoRaid()
            end
        end)
    end
end)

spawn(function()
    while wait(1) do
        pcall(function()
            if Config.AutoAwaken then
                AutoAwaken()
            end
        end)
    end
end)

-- Blox Fruits Ultimate Script (Parte 4/10)
-- Sistemas de Frutas e Sniper

-- Tabela de Frutas
local FruitTable = {
    ["Bomb Fruit"] = 100000,
    ["Spike Fruit"] = 180000,
    ["Chop Fruit"] = 250000,
    ["Spring Fruit"] = 350000,
    ["Kilo Fruit"] = 450000,
    ["Smoke Fruit"] = 550000,
    ["Spin Fruit"] = 650000,
    ["Flame Fruit"] = 750000,
    ["Bird: Falcon Fruit"] = 850000,
    ["Ice Fruit"] = 950000,
    ["Sand Fruit"] = 1050000,
    ["Dark Fruit"] = 1150000,
    ["Diamond Fruit"] = 1250000,
    ["Light Fruit"] = 1350000,
    ["Love Fruit"] = 1450000,
    ["Rubber Fruit"] = 1550000,
    ["Barrier Fruit"] = 1650000,
    ["Magma Fruit"] = 1750000,
    ["Door Fruit"] = 1850000,
    ["Quake Fruit"] = 1950000,
    ["Human: Buddha Fruit"] = 2050000,
    ["String Fruit"] = 2150000,
    ["Bird: Phoenix Fruit"] = 2250000,
    ["Rumble Fruit"] = 2350000,
    ["Paw Fruit"] = 2450000,
    ["Gravity Fruit"] = 2550000,
    ["Dough Fruit"] = 2650000,
    ["Shadow Fruit"] = 2750000,
    ["Venom Fruit"] = 2850000,
    ["Control Fruit"] = 2950000,
    ["Dragon Fruit"] = 3050000
}

-- Funções de Frutas
function GetFruits()
    local fruits = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if string.find(v.Name, "Fruit") then
            table.insert(fruits, v)
        end
    end
    return fruits
end

function CollectFruit(fruit)
    fruit.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end

function StoreFruit()
    local args = {
        [1] = "StoreFruit",
        [2] = "All"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Sistema de Auto Store Fruit
function AutoStoreFruit()
    if not Config.AutoStoreFruit then return end
    
    local fruits = GetFruits()
    for _, fruit in pairs(fruits) do
        CollectFruit(fruit)
        wait(1)
        StoreFruit()
    end
end

-- Sistema de Fruit Sniper
function FruitSniper()
    if not Config.FruitSniper then return end
    
    local args = {
        [1] = "GetFruits"
    }
    
    local AllFruits = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    
    for i,v in pairs(AllFruits) do
        if v.Name == Config.SelectedFruit then
            local args = {
                [1] = "LoadFruit",
                [2] = v.Name
            }
            
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end

-- Interface de Frutas
local FruitSection = Instance.new("Frame")
FruitSection.Name = "FruitSection"
FruitSection.Parent = FruitPage
FruitSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FruitSection.BorderSizePixel = 0
FruitSection.Size = UDim2.new(1, -20, 0, 300)

local FruitTitle = Instance.new("TextLabel")
FruitTitle.Name = "FruitTitle"
FruitTitle.Parent = FruitSection
FruitTitle.BackgroundTransparency = 1
FruitTitle.Position = UDim2.new(0, 10, 0, 5)
FruitTitle.Size = UDim2.new(1, -20, 0, 20)
FruitTitle.Font = Enum.Font.GothamBold
FruitTitle.Text = "Fruit Settings"
FruitTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitTitle.TextSize = 14
FruitTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown para selecionar Fruta
local FruitDropdown = Instance.new("Frame")
FruitDropdown.Name = "FruitDropdown"
FruitDropdown.Parent = FruitSection
FruitDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FruitDropdown.BorderSizePixel = 0
FruitDropdown.Position = UDim2.new(0, 10, 0, 35)
FruitDropdown.Size = UDim2.new(1, -20, 0, 30)

local FruitSelected = Instance.new("TextLabel")
FruitSelected.Name = "FruitSelected"
FruitSelected.Parent = FruitDropdown
FruitSelected.BackgroundTransparency = 1
FruitSelected.Size = UDim2.new(1, -30, 1, 0)
FruitSelected.Font = Enum.Font.GothamSemibold
FruitSelected.Text = Config.SelectedFruit
FruitSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitSelected.TextSize = 14
FruitSelected.TextXAlignment = Enum.TextXAlignment.Left
FruitSelected.Position = UDim2.new(0, 10, 0, 0)

local FruitDropButton = Instance.new("TextButton")
FruitDropButton.Name = "FruitDropButton"
FruitDropButton.Parent = FruitDropdown
FruitDropButton.BackgroundTransparency = 1
FruitDropButton.Position = UDim2.new(1, -30, 0, 0)
FruitDropButton.Size = UDim2.new(0, 30, 1, 0)
FruitDropButton.Font = Enum.Font.GothamBold
FruitDropButton.Text = "▼"
FruitDropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitDropButton.TextSize = 14

local FruitDropContent = Instance.new("ScrollingFrame")
FruitDropContent.Name = "FruitDropContent"
FruitDropContent.Parent = FruitDropdown
FruitDropContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FruitDropContent.BorderSizePixel = 0
FruitDropContent.Position = UDim2.new(0, 0, 1, 0)
FruitDropContent.Size = UDim2.new(1, 0, 0, 200)
FruitDropContent.Visible = false
FruitDropContent.ZIndex = 2
FruitDropContent.ScrollBarThickness = 4
FruitDropContent.CanvasSize = UDim2.new(0, 0, 0, #FruitTable * 30)

-- Criar botões para cada Fruta
local index = 0
for fruitName, _ in pairs(FruitTable) do
    local FruitButton = Instance.new("TextButton")
    FruitButton.Name = fruitName
    FruitButton.Parent = FruitDropContent
    FruitButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FruitButton.BorderSizePixel = 0
    FruitButton.Position = UDim2.new(0, 0, 0, index * 30)
    FruitButton.Size = UDim2.new(1, 0, 0, 30)
    FruitButton.Font = Enum.Font.GothamSemibold
    FruitButton.Text = fruitName
    FruitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FruitButton.TextSize = 14
    FruitButton.ZIndex = 2
    
    FruitButton.MouseButton1Click:Connect(function()
        Config.SelectedFruit = fruitName
        FruitSelected.Text = fruitName
        FruitDropContent.Visible = false
    end)
    
    index = index + 1
end

FruitDropButton.MouseButton1Click:Connect(function()
    FruitDropContent.Visible = not FruitDropContent.Visible
end)

-- Toggles de Frutas
local AutoStoreFruitToggle = CreateToggle(FruitSection, "Auto Store Fruit", "AutoStoreFruit")
local FruitSniperToggle = CreateToggle(FruitSection, "Fruit Sniper", "FruitSniper")

-- Iniciar loops de Frutas
spawn(function()
    while wait(1) do
        pcall(function()
            if Config.AutoStoreFruit then
                AutoStoreFruit()
            end
        end)
    end
end)

spawn(function()
    while wait(1) do
        pcall(function()
            if Config.FruitSniper then
                FruitSniper()
            end
        end)
    end
end)

-- Informações de Frutas
local FruitInfo = Instance.new("TextLabel")
FruitInfo.Name = "FruitInfo"
FruitInfo.Parent = FruitSection
FruitInfo.BackgroundTransparency = 1
FruitInfo.Position = UDim2.new(0, 10, 0, 250)
FruitInfo.Size = UDim2.new(1, -20, 0, 40)
FruitInfo.Font = Enum.Font.GothamSemibold
FruitInfo.Text = "Current Fruit: None"
FruitInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
FruitInfo.TextSize = 14
FruitInfo.TextXAlignment = Enum.TextXAlignment.Left

-- Atualizar informações de Frutas
spawn(function()
    while wait(1) do
        pcall(function()
            local plr = game.Players.LocalPlayer
            local CurrentFruit = "None"
            
            for i,v in pairs(plr.Backpack:GetChildren()) do
                if string.find(v.Name, "Fruit") then
                    CurrentFruit = v.Name
                end
            end
            
            for i,v in pairs(plr.Character:GetChildren()) do
                if string.find(v.Name, "Fruit") then
                    CurrentFruit = v.Name
                end
            end
            
            FruitInfo.Text = "Current Fruit: " .. CurrentFruit
        end)
    end
end)

-- Blox Fruits Ultimate Script (Parte 5/10)
-- Sistemas de Teleporte e Dungeons

-- Tabela de Localizações
local Locations = {
    ['First Sea'] = {
        ["Pirates Starter"] = CFrame.new(1071.2832, 16.3085976, 1426.86792),
        ["Marine Starter"] = CFrame.new(-2573.3374, 6.88881969, 2046.99817),
        ["Middle Town"] = CFrame.new(-655.824158, 7.88708115, 1436.67908),
        ["Jungle"] = CFrame.new(-1249.77222, 11.8870859, 341.356476),
        ["Pirate Village"] = CFrame.new(-1122.34998, 4.78708982, 3855.91992),
        ["Desert"] = CFrame.new(1094.14587, 6.47350502, 4192.88721),
        ["Frozen Village"] = CFrame.new(1198.00928, 27.0074959, -1211.73376),
        ["MarineFord"] = CFrame.new(-4505.375, 20.687294, 4260.55908),
        ["Colosseum"] = CFrame.new(-1428.35474, 7.38933945, -3014.37305),
        ["Sky 1st Floor"] = CFrame.new(-4970.21875, 717.707275, -2622.35449),
        ["Prison"] = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),
        ["Magma Village"] = CFrame.new(-5231.75879, 8.61593437, 8467.87695),
        ["UndeyWater City"] = CFrame.new(61163.8516, 11.7796879, 1819.78418),
        ["Fountain City"] = CFrame.new(5132.7124, 4.53632832, 4037.8562),
        ["House Cyborg's"] = CFrame.new(6262.72559, 71.3003616, 3998.23047),
        ["Shank's Room"] = CFrame.new(-1442.16553, 29.8788261, -28.3547478),
        ["Mob Island"] = CFrame.new(-2850.20068, 7.39224768, 5354.99268),
    },
    
    ['Second Sea'] = {
        ["First Spot"] = CFrame.new(82.9490662, 18.0710983, 2834.98779),
        ["Kingdom of Rose"] = game.CFrame.new(-394.983521, 118.503128, 1245.8446),
        ["Dark Arena"] = CFrame.new(3464.7163085938, 13.375151634216, -3368.90234375),
        ["Flamingo Mansion"] = CFrame.new(-390.096313, 331.886475, 673.464966),
        ["Flamingo Room"] = CFrame.new(2302.19019, 15.1778421, 663.811035),
        ["Green Zone"] = CFrame.new(-2372.14697, 72.9919434, -3166.51416),
        ["Cafe"] = CFrame.new(-385.250916, 73.0458984, 297.388397),
        ["Factory"] = CFrame.new(430.42569, 210.019623, -432.504791),
        ["Colosseum"] = CFrame.new(-1836.58191, 44.5890656, 1360.30652),
        ["Ghost Island"] = CFrame.new(-5571.84424, 195.182297, -795.432922),
        ["Ghost Island 2nd"] = CFrame.new(-5931.77979, 5.19706631, -1189.6908),
        ["Snow Mountain"] = CFrame.new(1384.68298, 453.569031, -4990.09766),
        ["Hot and Cold"] = CFrame.new(-6026.96484, 14.7461271, -5071.96338),
        ["Magma Side"] = CFrame.new(-5478.39209, 15.9775667, -5246.9126),
        ["Cursed Ship"] = CFrame.new(902.059143, 124.752518, 33071.8125),
        ["Ice Castle"] = CFrame.new(5400.40381, 28.21698, -6236.99219),
        ["Forgotten Island"] = CFrame.new(-3043.31543, 238.881271, -10191.5791),
        ["Usoapp Island"] = CFrame.new(4748.78857, 8.35370827, 2849.57959),
        ["Minisky Island"] = CFrame.new(-260.358917, 49325.7031, -35259.3008),
    },
    
    ['Third Sea'] = {
        ["Port Town"] = CFrame.new(-610.309692, 57.8323097, 6436.33594),
        ["Hydra Island"] = CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625),
        ["Great Tree"] = CFrame.new(2174.94873, 28.7312393, -6728.83154),
        ["Castle on the Sea"] = CFrame.new(-5477.62842, 313.794739, -2808.4585),
        ["Floating Turtle"] = CFrame.new(-10919.2998, 331.788452, -8637.57227),
        ["Mansion"] = CFrame.new(-12553.8125, 332.403961, -7621.91748),
        ["Secret Temple"] = CFrame.new(5217.35693, 6.56511116, 1100.88159),
        ["Friendly Arena"] = CFrame.new(5220.28955, 72.8193436, -1450.86304),
        ["Beautiful Pirate Domain"] = CFrame.new(5310.8095703125, 21.594484329224, 129.39053344727),
        ["Teler Park"] = CFrame.new(-9512.3623046875, 142.13258361816, 5548.845703125),
        ["Peanut Island"] = CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375),
        ["Ice Cream Island"] = CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625),
    }
}

-- Sistema de Dungeon
local DungeonConfig = {
    Dungeons = {
        "Flame",
        "Ice",
        "Quake",
        "Light",
        "Dark",
        "String",
        "Rumble",
        "Magma",
        "Human: Buddha",
        "Sand",
        "Bird: Phoenix",
        "Dough"
    },
    
    CurrentDungeon = "Flame",
    AutoDungeon = false,
    AutoRaid = false
}

-- Funções de Teleporte
function Teleport(pos)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if typeof(pos) == "CFrame" then
        humanoidRootPart.CFrame = pos
    else
        humanoidRootPart.CFrame = CFrame.new(pos)
    end
end

function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return "First Sea"
    elseif placeId == 4442272183 then
        return "Second Sea"
    elseif placeId == 7449423635 then
        return "Third Sea"
    end
    return "Unknown"
end

-- Interface de Teleporte
local TeleportSection = Instance.new("Frame")
TeleportSection.Name = "TeleportSection"
TeleportSection.Parent = TeleportPage
TeleportSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TeleportSection.BorderSizePixel = 0
TeleportSection.Size = UDim2.new(1, -20, 0, 400)

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Name = "TeleportTitle"
TeleportTitle.Parent = TeleportSection
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Position = UDim2.new(0, 10, 0, 5)
TeleportTitle.Size = UDim2.new(1, -20, 0, 20)
TeleportTitle.Font = Enum.Font.GothamBold
TeleportTitle.Text = "Teleport Locations"
TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportTitle.TextSize = 14
TeleportTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar ScrollingFrame para localizações
local LocationScroll = Instance.new("ScrollingFrame")
LocationScroll.Name = "LocationScroll"
LocationScroll.Parent = TeleportSection
LocationScroll.BackgroundTransparency = 1
LocationScroll.Position = UDim2.new(0, 10, 0, 35)
LocationScroll.Size = UDim2.new(1, -20, 1, -45)
LocationScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LocationScroll.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = LocationScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Criar botões para cada localização do mar atual
local function CreateLocationButtons()
    -- Limpar botões existentes
    for _, child in pairs(LocationScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local currentSea = GetCurrentSea()
    local locations = Locations[currentSea]
    
    for name, position in pairs(locations) do
        local LocationButton = Instance.new("TextButton")
        LocationButton.Name = name
        LocationButton.Parent = LocationScroll
        LocationButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        LocationButton.BorderSizePixel = 0
        LocationButton.Size = UDim2.new(1, 0, 0, 40)
        LocationButton.Font = Enum.Font.GothamSemibold
        LocationButton.Text = name
        LocationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        LocationButton.TextSize = 14
        
        LocationButton.MouseButton1Click:Connect(function()
            Teleport(position)
        end)
        
        -- Hover Effect
        LocationButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(LocationButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()
        end)
        
        LocationButton.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(LocationButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            }):Play()
        end)
    end
    
    -- Atualizar tamanho do canvas
    LocationScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- Atualizar botões quando o script inicia
CreateLocationButtons()

-- Sistema de Dungeon
local DungeonSection = Instance.new("Frame")
DungeonSection.Name = "DungeonSection"
DungeonSection.Parent = TeleportPage
DungeonSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DungeonSection.BorderSizePixel = 0
DungeonSection.Position = UDim2.new(0, 10, 0, 410)
DungeonSection.Size = UDim2.new(1, -20, 0, 150)

local DungeonTitle = Instance.new("TextLabel")
DungeonTitle.Name = "DungeonTitle"
DungeonTitle.Parent = DungeonSection
DungeonTitle.BackgroundTransparency = 1
DungeonTitle.Position = UDim2.new(0, 10, 0, 5)
DungeonTitle.Size = UDim2.new(1, -20, 0, 20)
DungeonTitle.Font = Enum.Font.GothamBold
DungeonTitle.Text = "Dungeon Settings"
DungeonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DungeonTitle.TextSize = 14
DungeonTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar Toggles para Dungeon
local AutoDungeonToggle = CreateToggle(DungeonSection, "Auto Dungeon", function(enabled)
    DungeonConfig.AutoDungeon = enabled
end)
AutoDungeonToggle.Position = UDim2.new(0, 10, 0, 35)

-- Dropdown para selecionar Dungeon
local DungeonDropdown = Instance.new("Frame")
DungeonDropdown.Name = "DungeonDropdown"
DungeonDropdown.Parent = DungeonSection
DungeonDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DungeonDropdown.BorderSizePixel = 0
DungeonDropdown.Position = UDim2.new(0, 10, 0, 85)
DungeonDropdown.Size = UDim2.new(1, -20, 0, 30)

-- Blox Fruits Ultimate Script (Parte 6/10)
-- Sistemas de Stats e Combate

-- Configurações de Combate
local CombatConfig = {
    Skills = {
        ["Z"] = {
            Enabled = false,
            HoldTime = 0,
            Delay = 1
        },
        ["X"] = {
            Enabled = false,
            HoldTime = 0,
            Delay = 1
        },
        ["C"] = {
            Enabled = false,
            HoldTime = 0,
            Delay = 1
        },
        ["V"] = {
            Enabled = false,
            HoldTime = 0,
            Delay = 1
        }
    },
    
    FastAttackDelay = 0.1,
    KenHakiEnabled = false,
    BusoHakiEnabled = false,
    AutoKen = false,
    SkillsDelay = 1,
    ComboType = "Normal" -- Normal, Advanced, Ultimate
}

-- Sistema de Stats
local StatsConfig = {
    AutoStats = false,
    StatType = "Melee", -- Melee, Defense, Sword, Gun, DevilFruit
    Points = 1,
    MaxPoints = 2300,
    Distribution = {
        Melee = 0,
        Defense = 0,
        Sword = 0,
        Gun = 0,
        DevilFruit = 0
    }
}

-- Funções de Combate
function ActivateSkill(skill)
    local VirtualUser = game:GetService('VirtualUser')
    VirtualUser:CaptureController()
    VirtualUser:SendKeyEvent(true, skill, false, game)
    if CombatConfig.Skills[skill].HoldTime > 0 then
        wait(CombatConfig.Skills[skill].HoldTime)
    end
    VirtualUser:SendKeyEvent(false, skill, false, game)
end

function ActivateBuso()
    local args = {
        [1] = "Buso"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function ActivateKen()
    local args = {
        [1] = "Ken"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Sistema de Fast Attack Avançado
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]
local realbhit = require(game.ReplicatedStorage.CombatFramework.RigLib)
local cooldownfastattack = tick()

function FastAttack()
    if not CombatConfig.FastAttackEnabled then return end
    
    pcall(function()
        if cooldownfastattack <= tick() then
            if CombatFrameworkR.activeController and CombatFrameworkR.activeController.equipped then
                for i = 1, 1 do
                    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
                        CombatFrameworkR.activeController,
                        {CombatFrameworkR.activeController.Humanoid, CombatFrameworkR.activeController.Humanoid}
                    )
                    if #bladehit > 0 then
                        local AcAttack8 = debug.getupvalue(CombatFramework.activeController.attack, 5)
                        local AcAttack9 = debug.getupvalue(CombatFramework.activeController.attack, 6)
                        local AcAttack7 = debug.getupvalue(CombatFramework.activeController.attack, 4)
                        local AcAttack10 = debug.getupvalue(CombatFramework.activeController.attack, 7)
                        local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                        local NumberAc13 = AcAttack7 * 798405
                        NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                        AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                        AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
                        AcAttack10 = AcAttack10 + 1
                        debug.setupvalue(CombatFramework.activeController.attack, 5, AcAttack8)
                        debug.setupvalue(CombatFramework.activeController.attack, 6, AcAttack9)
                        debug.setupvalue(CombatFramework.activeController.attack, 4, AcAttack7)
                        debug.setupvalue(CombatFramework.activeController.attack, 7, AcAttack10)
                        for k, v in pairs(CombatFrameworkR.activeController.anims.basic) do
                            v:Play(0.01,0.01,0.01)
                        end
                        if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and CombatFrameworkR.activeController.blades and CombatFrameworkR.activeController.blades[1] then 
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(CurrentWeapon()))
                            game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                        end
                    end
                end
            end
            cooldownfastattack = tick() + CombatConfig.FastAttackDelay
        end
    end)
end

-- Sistema de Auto Stats
function AutoStats()
    if not StatsConfig.AutoStats then return end
    
    local args = {
        [1] = "AddPoint",
        [2] = StatsConfig.StatType,
        [3] = StatsConfig.Points
    }
    
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Interface de Stats
local StatsSection = Instance.new("Frame")
StatsSection.Name = "StatsSection"
StatsSection.Parent = StatsPage
StatsSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StatsSection.BorderSizePixel = 0
StatsSection.Size = UDim2.new(1, -20, 0, 300)

local StatsTitle = Instance.new("TextLabel")
StatsTitle.Name = "StatsTitle"
StatsTitle.Parent = StatsSection
StatsTitle.BackgroundTransparency = 1
StatsTitle.Position = UDim2.new(0, 10, 0, 5)
StatsTitle.Size = UDim2.new(1, -20, 0, 20)
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.Text = "Stats Settings"
StatsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsTitle.TextSize = 14
StatsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar Toggles para Stats
local AutoStatsToggle = CreateToggle(StatsSection, "Auto Stats", function(enabled)
    StatsConfig.AutoStats = enabled
end)
AutoStatsToggle.Position = UDim2.new(0, 10, 0, 35)

-- Dropdown para selecionar Stat Type
local StatTypeDropdown = Instance.new("Frame")
StatTypeDropdown.Name = "StatTypeDropdown"
StatTypeDropdown.Parent = StatsSection
StatTypeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StatTypeDropdown.BorderSizePixel = 0
StatTypeDropdown.Position = UDim2.new(0, 10, 0, 85)
StatTypeDropdown.Size = UDim2.new(1, -20, 0, 30)

-- Interface de Combate
local CombatSection = Instance.new("Frame")
CombatSection.Name = "CombatSection"
CombatSection.Parent = StatsPage
CombatSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CombatSection.BorderSizePixel = 0
CombatSection.Position = UDim2.new(0, 0, 0, 310)
CombatSection.Size = UDim2.new(1, -20, 0, 250)

local CombatTitle = Instance.new("TextLabel")
CombatTitle.Name = "CombatTitle"
CombatTitle.Parent = CombatSection
CombatTitle.BackgroundTransparency = 1
CombatTitle.Position = UDim2.new(0, 10, 0, 5)
CombatTitle.Size = UDim2.new(1, -20, 0, 20)
CombatTitle.Font = Enum.Font.GothamBold
CombatTitle.Text = "Combat Settings"
CombatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatTitle.TextSize = 14
CombatTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar Toggles para Skills
for skill, config in pairs(CombatConfig.Skills) do
    local SkillToggle = CreateToggle(CombatSection, "Auto Skill " .. skill, function(enabled)
        CombatConfig.Skills[skill].Enabled = enabled
    end)
end

-- Loops principais
spawn(function()
    while wait() do
        pcall(function()
            if CombatConfig.FastAttackEnabled then
                FastAttack()
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if StatsConfig.AutoStats then
                AutoStats()
            end
        end)
    end
end)

spawn(function()
    while wait(CombatConfig.SkillsDelay) do
        pcall(function()
            for skill, config in pairs(CombatConfig.Skills) do
                if config.Enabled then
                    ActivateSkill(skill)
                    wait(config.Delay)
                end
            end
        end)
    end
end)

-- Sistema de Ken/Buso Haki
spawn(function()
    while wait(1) do
        pcall(function()
            if CombatConfig.BusoHakiEnabled then
                ActivateBuso()
            end
            if CombatConfig.KenHakiEnabled then
                ActivateKen()
            end
        end)
    end
end)

-- Blox Fruits Ultimate Script (Parte 7/10)
-- Sistemas de Shop e Item Sniper

-- Configurações de Shop
local ShopConfig = {
    AutoBuy = {
        Enabled = false,
        Items = {
            ["Black Leg"] = false,
            ["Electro"] = false,
            ["Fishman Karate"] = false,
            ["Dragon Claw"] = false,
            ["Superhuman"] = false,
            ["Death Step"] = false,
            ["Sharkman Karate"] = false,
            ["Electric Claw"] = false,
            ["Dragon Talon"] = false,
            ["Godhuman"] = false
        },
        Weapons = {
            ["Katana"] = false,
            ["Cutlass"] = false,
            ["Dual Katana"] = false,
            ["Iron Mace"] = false,
            ["Triple Katana"] = false,
            ["Pipe"] = false,
            ["Dual-Headed Blade"] = false,
            ["Bisento"] = false,
            ["Soul Cane"] = false
        },
        Haki = {
            ["Buso Haki"] = false,
            ["Soru"] = false,
            ["Ken Haki"] = false
        }
    },
    
    ItemSniper = {
        Enabled = false,
        Items = {},
        MaxPrice = 1000000
    }
}

-- Funções de Shop
function BuyItem(item)
    local args = {
        [1] = "BuyItem",
        [2] = item
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyFightingStyle(style)
    local args = {
        [1] = "BuyFightingStyle",
        [2] = style
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyHaki(haki)
    local args = {
        [1] = "BuyHaki",
        [2] = haki
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Sistema de Auto Buy
function AutoBuy()
    if not ShopConfig.AutoBuy.Enabled then return end
    
    -- Fighting Styles
    for style, enabled in pairs(ShopConfig.AutoBuy.Items) do
        if enabled then
            BuyFightingStyle(style)
        end
    end
    
    -- Weapons
    for weapon, enabled in pairs(ShopConfig.AutoBuy.Weapons) do
        if enabled then
            BuyItem(weapon)
        end
    end
    
    -- Haki
    for haki, enabled in pairs(ShopConfig.AutoBuy.Haki) do
        if enabled then
            BuyHaki(haki)
        end
    end
end

-- Interface de Shop
local ShopSection = Instance.new("Frame")
ShopSection.Name = "ShopSection"
ShopSection.Parent = ShopPage
ShopSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ShopSection.BorderSizePixel = 0
ShopSection.Size = UDim2.new(1, -20, 0, 500)

local ShopTitle = Instance.new("TextLabel")
ShopTitle.Name = "ShopTitle"
ShopTitle.Parent = ShopSection
ShopTitle.BackgroundTransparency = 1
ShopTitle.Position = UDim2.new(0, 10, 0, 5)
ShopTitle.Size = UDim2.new(1, -20, 0, 20)
ShopTitle.Font = Enum.Font.GothamBold
ShopTitle.Text = "Shop Settings"
ShopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ShopTitle.TextSize = 14
ShopTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar Tabs para diferentes categorias de shop
local ShopTabButtons = Instance.new("Frame")
ShopTabButtons.Name = "ShopTabButtons"
ShopTabButtons.Parent = ShopSection
ShopTabButtons.BackgroundTransparency = 1
ShopTabButtons.Position = UDim2.new(0, 10, 0, 35)
ShopTabButtons.Size = UDim2.new(1, -20, 0, 30)

local ShopTabContent = Instance.new("Frame")
ShopTabContent.Name = "ShopTabContent"
ShopTabContent.Parent = ShopSection
ShopTabContent.BackgroundTransparency = 1
ShopTabContent.Position = UDim2.new(0, 10, 0, 75)
ShopTabContent.Size = UDim2.new(1, -20, 1, -85)

-- Função para criar tabs de shop
local function CreateShopTab(name, items)
    -- Criar botão
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = ShopTabButtons
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0.33, -5, 1, 0)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    
    if name == "Fighting Styles" then
        TabButton.Position = UDim2.new(0, 0, 0, 0)
    elseif name == "Weapons" then
        TabButton.Position = UDim2.new(0.33, 5, 0, 0)
    else
        TabButton.Position = UDim2.new(0.66, 10, 0, 0)
    end
    
    -- Criar conteúdo
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Parent = ShopTabContent
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, #items * 40 + (#items-1) * 5)
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    
    -- Criar items
    for i, item in ipairs(items) do
        local ItemFrame = Instance.new("Frame")
        ItemFrame.Name = item.."Frame"
        ItemFrame.Parent = TabContent
        ItemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ItemFrame.BorderSizePixel = 0
        ItemFrame.Position = UDim2.new(0, 0, 0, (i-1) * 45)
        ItemFrame.Size = UDim2.new(1, 0, 0, 40)
        
        local ItemName = Instance.new("TextLabel")
        ItemName.Name = "ItemName"
        ItemName.Parent = ItemFrame
        ItemName.BackgroundTransparency = 1
        ItemName.Position = UDim2.new(0, 10, 0, 0)
        ItemName.Size = UDim2.new(1, -60, 1, 0)
        ItemName.Font = Enum.Font.GothamSemibold
        ItemName.Text = item
        ItemName.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemName.TextSize = 14
        ItemName.TextXAlignment = Enum.TextXAlignment.Left
        
        local BuyButton = Instance.new("TextButton")
        BuyButton.Name = "BuyButton"
        BuyButton.Parent = ItemFrame
        BuyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        BuyButton.BorderSizePixel = 0
        BuyButton.Position = UDim2.new(1, -50, 0.5, -15)
        BuyButton.Size = UDim2.new(0, 40, 0, 30)
        BuyButton.Font = Enum.Font.GothamBold
        BuyButton.Text = "Buy"
        BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        BuyButton.TextSize = 14
        
        -- Conectar função de compra
        BuyButton.MouseButton1Click:Connect(function()
            if name == "Fighting Styles" then
                BuyFightingStyle(item)
            elseif name == "Weapons" then
                BuyItem(item)
            else
                BuyHaki(item)
            end
        end)
    end
    
    -- Conectar switch de tab
    TabButton.MouseButton1Click:Connect(function()
        for _, content in pairs(ShopTabContent:GetChildren()) do
            content.Visible = content == TabContent
        end
        
        for _, button in pairs(ShopTabButtons:GetChildren()) do
            button.BackgroundColor3 = button == TabButton and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
        end
    end)
    
    return TabButton, TabContent
end

-- Criar tabs para cada categoria
local FightingStylesTab = CreateShopTab("Fighting Styles", {
    "Black Leg",
    "Electro",
    "Fishman Karate",
    "Dragon Claw",
    "Superhuman",
    "Death Step",
    "Sharkman Karate",
    "Electric Claw",
    "Dragon Talon",
    "Godhuman"
})

local WeaponsTab = CreateShopTab("Weapons", {
    "Katana",
    "Cutlass",
    "Dual Katana",
    "Iron Mace",
    "Triple Katana",
    "Pipe",
    "Dual-Headed Blade",
    "Bisento",
    "Soul Cane"
})

local HakiTab = CreateShopTab("Haki", {
    "Buso Haki",
    "Soru",
    "Ken Haki"
})

-- Mostrar primeira tab por padrão
FightingStylesTab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ShopTabContent:FindFirstChild("Fighting StylesContent").Visible = true

-- Loop de Auto Buy
spawn(function()
    while wait(1) do
        pcall(function()
            if ShopConfig.AutoBuy.Enabled then
                AutoBuy()
            end
        end)
    end
end)

-- Blox Fruits Ultimate Script (Parte 8/10)
-- Sistemas de Misc e Settings

-- Configurações de Misc
local MiscConfig = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
    InfiniteStamina = false,
    AutoRejoin = false,
    WhiteScreen = false,
    RemoveDamageAnimation = false,
    RemoveFog = false,
    FullBright = false,
    RemoveEffects = false,
    ESP = {
        Players = false,
        Fruits = false,
        Chests = false,
        Flowers = false
    }
}

-- Funções de Misc
function SetWalkSpeed(speed)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

function SetJumpPower(power)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = power
    end
end

function ToggleInfiniteJump()
    game:GetService("UserInputService").JumpRequest:connect(function()
        if MiscConfig.InfiniteJump then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end

function ToggleNoClip()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    spawn(function()
        while wait() do
            if MiscConfig.NoClip then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end

function ToggleInfiniteStamina()
    spawn(function()
        while wait() do
            if MiscConfig.InfiniteStamina then
                getrenv()._G.InfiniteEnergy = true
            else
                getrenv()._G.InfiniteEnergy = false
            end
        end
    end)
end

-- Sistema de ESP
local ESP = {
    Boxes = {},
    Enabled = false
}

function ESP:CreateBox(part)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false
    return box
end

function ESP:UpdateBox(box, part)
    if not part then
        box.Visible = false
        return
    end
    
    local camera = workspace.CurrentCamera
    local vector, onScreen = camera:WorldToViewportPoint(part.Position)
    
    if onScreen then
        box.Visible = true
        local size = part.Size * Vector3.new(1, 1.5, 0)
        local height = (camera.CFrame.Position - part.Position).Magnitude
        box.Size = Vector2.new(1000/height * size.X, 1000/height * size.Y)
        box.Position = Vector2.new(vector.X - box.Size.X/2, vector.Y - box.Size.Y/2)
    else
        box.Visible = false
    end
end

function ESP:Start()
    spawn(function()
        while wait() do
            if ESP.Enabled then
                -- ESP Players
                if MiscConfig.ESP.Players then
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            if not ESP.Boxes[player] then
                                ESP.Boxes[player] = ESP:CreateBox(player.Character.HumanoidRootPart)
                            end
                            ESP:UpdateBox(ESP.Boxes[player], player.Character.HumanoidRootPart)
                        end
                    end
                end
                
                -- ESP Fruits
                if MiscConfig.ESP.Fruits then
                    for _, fruit in pairs(workspace:GetChildren()) do
                        if string.find(fruit.Name, "Fruit") then
                            if not ESP.Boxes[fruit] then
                                ESP.Boxes[fruit] = ESP:CreateBox(fruit)
                            end
                            ESP:UpdateBox(ESP.Boxes[fruit], fruit)
                        end
                    end
                end
                
                -- ESP Chests
                if MiscConfig.ESP.Chests then
                    for _, chest in pairs(workspace:GetChildren()) do
                        if string.find(chest.Name, "Chest") then
                            if not ESP.Boxes[chest] then
                                ESP.Boxes[chest] = ESP:CreateBox(chest)
                            end
                            ESP:UpdateBox(ESP.Boxes[chest], chest)
                        end
                    end
                end
            else
                for _, box in pairs(ESP.Boxes) do
                    box.Visible = false
                end
            end
        end
    end)
end

-- Interface de Misc
local MiscSection = Instance.new("Frame")
MiscSection.Name = "MiscSection"
MiscSection.Parent = MiscPage
MiscSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiscSection.BorderSizePixel = 0
MiscSection.Size = UDim2.new(1, -20, 0, 400)

local MiscTitle = Instance.new("TextLabel")
MiscTitle.Name = "MiscTitle"
MiscTitle.Parent = MiscSection
MiscTitle.BackgroundTransparency = 1
MiscTitle.Position = UDim2.new(0, 10, 0, 5)
MiscTitle.Size = UDim2.new(1, -20, 0, 20)
MiscTitle.Font = Enum.Font.GothamBold
MiscTitle.Text = "Misc Settings"
MiscTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MiscTitle.TextSize = 14
MiscTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Criar Sliders
local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name.."Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    
    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Name = "Title"
    SliderTitle.Parent = SliderFrame
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Position = UDim2.new(0, 10, 0, 5)
    SliderTitle.Size = UDim2.new(1, -20, 0, 20)
    SliderTitle.Font = Enum.Font.GothamSemibold
    SliderTitle.Text = name
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.TextSize = 14
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "Bar"
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 10, 0, 35)
    SliderBar.Size = UDim2.new(1, -20, 0, 5)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new((default - min)/(max - min), -5, 0.5, -5)
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Text = ""
    
    local Value = default
    local Dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        Dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            Value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            SliderButton.Position = UDim2.new(pos, -5, 0.5, -5)
            callback(Value)
        end
    end)
    
    return SliderFrame, function()
        return Value
    end
end

-- Criar Sliders para WalkSpeed e JumpPower
local WalkSpeedSlider = CreateSlider(MiscSection, "WalkSpeed", 16, 500, MiscConfig.WalkSpeed, function(value)
    MiscConfig.WalkSpeed = value
    SetWalkSpeed(value)
end)
WalkSpeedSlider.Position = UDim2.new(0, 10, 0, 35)

local JumpPowerSlider = CreateSlider(MiscSection, "JumpPower", 50, 500, MiscConfig.JumpPower, function(value)
    MiscConfig.JumpPower = value
    SetJumpPower(value)
end)
JumpPowerSlider.Position = UDim2.new(0, 10, 0, 95)

-- Criar Toggles para outras configurações
local InfiniteJumpToggle = CreateToggle(MiscSection, "Infinite Jump", function(enabled)
    MiscConfig.InfiniteJump = enabled
end)
InfiniteJumpToggle.Position = UDim2.new(0, 10, 0, 155)

local NoClipToggle = CreateToggle(MiscSection, "NoClip", function(enabled)
    MiscConfig.NoClip = enabled
end)
NoClipToggle.Position = UDim2.new(0, 10, 0, 195)

local InfiniteStaminaToggle = CreateToggle(MiscSection, "Infinite Stamina", function(enabled)
    MiscConfig.InfiniteStamina = enabled
end)
InfiniteStaminaToggle.Position = UDim2.new(0, 10, 0, 235)

-- Iniciar sistemas
ToggleInfiniteJump()
ToggleNoClip()
ToggleInfiniteStamina()
ESP:Start()

-- Blox Fruits Ultimate Script (Parte 9/10 - Nova Interface 2)
local TweenService = game:GetService("TweenService")

-- Configurações de UI
local UIConfig = {
    MainColor = Color3.fromRGB(0, 170, 255),
    BackgroundColor = Color3.fromRGB(25, 25, 25),
    SecondaryColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14
}

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FsUltimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = UIConfig.BackgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

-- Arredondar cantos
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = UIConfig.SecondaryColor
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = UIConfig.Font
Title.Text = "Fs Ultimate"
Title.TextColor3 = UIConfig.TextColor
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = UIConfig.TextColor
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -12)
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = UIConfig.TextColor
MinimizeButton.TextSize = 14
MinimizeButton.AutoButtonColor = false

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Container das Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = UIConfig.SecondaryColor
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.Size = UDim2.new(0, 150, 1, -35)

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 10)
TabContainerCorner.Parent = TabContainer

-- Lista de Tabs
local TabList = Instance.new("ScrollingFrame")
TabList.Name = "TabList"
TabList.Parent = TabContainer
TabList.Active = true
TabList.BackgroundTransparency = 1
TabList.Position = UDim2.new(0, 0, 0, 10)
TabList.Size = UDim2.new(1, 0, 1, -20)
TabList.ScrollBarThickness = 0
TabList.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabList
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Função para criar botões de tab
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabList
    TabButton.BackgroundColor3 = UIConfig.AccentColor
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.Font = UIConfig.Font
    TabButton.Text = name
    TabButton.TextColor3 = UIConfig.TextColor
    TabButton.TextSize = UIConfig.TextSize
    TabButton.AutoButtonColor = false

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    -- Efeito hover
    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = UIConfig.MainColor
        }):Play()
    end)

    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = UIConfig.AccentColor
        }):Play()
    end)

    return TabButton
end

-- Criar as tabs
local tabs = {"Main", "Stats", "Teleport", "Raid", "Shop", "Fruit", "Misc", "Settings"}
for i, tabName in ipairs(tabs) do
    CreateTab(tabName)
end

-- Container de Conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = UIConfig.SecondaryColor
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 150, 0, 35)
ContentContainer.Size = UDim2.new(1, -150, 1, -35)

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentContainer

-- Funcionalidade dos botões
local minimized = false
local originalSize = MainFrame.Size

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 600, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(originalSize, "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Efeitos dos botões
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    }):Play()
end)

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    }):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    }):Play()
end)

-- Ajustar tamanho da lista de tabs
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Blox Fruits Ultimate Script (Parte 10/10)
-- Inicialização e Configurações Gerais

-- Configurações Globais
getgenv().Config = {
    AutoFarm = false,
    AutoQuest = false,
    SelectedMob = "Bandit",
    FastAttack = false,
    AutoHaki = false,
    AutoStats = false,
    StatType = "Melee",
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoAwaken = false,
    FruitSniper = false,
    SelectedFruit = "None",
    AutoStoreFruit = false,
    WhiteScreen = false,
    FPSBoost = false
}

-- Sistema de Salvamento
local SaveManager = {
    FolderName = "BloxFruitsUltimate",
    FileName = "Config.json",
    
    Save = function(self)
        local json = game:GetService("HttpService"):JSONEncode(getgenv().Config)
        if not isfolder(self.FolderName) then
            makefolder(self.FolderName)
        end
        writefile(self.FolderName .. "/" .. self.FileName, json)
    end,
    
    Load = function(self)
        if not isfolder(self.FolderName) then
            makefolder(self.FolderName)
        end
        
        if isfile(self.FolderName .. "/" .. self.FileName) then
            local json = readfile(self.FolderName .. "/" .. self.FileName)
            local data = game:GetService("HttpService"):JSONDecode(json)
            
            for key, value in pairs(data) do
                getgenv().Config[key] = value
            end
        end
    end
}

-- Sistema de Notificações
local NotificationSystem = {
    Create = function(self, title, text, duration)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Parent = ScreenGui
        Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Notification.Position = UDim2.new(1, -320, 1, -90)
        Notification.Size = UDim2.new(0, 300, 0, 80)
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Notification
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Notification
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Font = Enum.Font.GothamBold
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local Message = Instance.new("TextLabel")
        Message.Name = "Message"
        Message.Parent = Notification
        Message.BackgroundTransparency = 1
        Message.Position = UDim2.new(0, 10, 0, 30)
        Message.Size = UDim2.new(1, -20, 0, 40)
        Message.Font = Enum.Font.GothamSemibold
        Message.Text = text
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextSize = 14
        Message.TextWrapped = true
        Message.TextXAlignment = Enum.TextXAlignment.Left
        Message.TextYAlignment = Enum.TextYAlignment.Top
        
        -- Animação
        Notification:TweenPosition(
            UDim2.new(1, -320, 1, -90),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.5,
            true
        )
        
        -- Auto destruir
        game:GetService("Debris"):AddItem(Notification, duration or 3)
    end
}

-- Sistema de Anti AFK
local AntiAFK = {
    Start = function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
}

-- Sistema de Performance
local PerformanceBooster = {
    Enable = function()
        if Config.FPSBoost then
            settings().Rendering.QualityLevel = 1
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                end
            end
        end
        
        if Config.WhiteScreen then
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end
}

-- Sistema de Webhooks
local WebhookSystem = {
    URL = "YOUR_WEBHOOK_URL_HERE",
    
    Send = function(self, message)
        local data = {
            ["content"] = message
        }
        
        local headers = {
            ["content-type"] = "application/json"
        }
        
        request({
            Url = self.URL,
            Method = "POST",
            Headers = headers,
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end
}

-- Sistema de Auto Rejoin
local AutoRejoin = {
    Enable = function()
        if Config.AutoRejoin then
            game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == 'ErrorPrompt' then
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
                end
            end)
        end
    end
}

-- Inicialização
do
    -- Carregar configurações salvas
    SaveManager:Load()
    
    -- Iniciar sistemas
    AntiAFK:Start()
    AutoRejoin.Enable()
    PerformanceBooster.Enable()
    
    -- Notificação inicial
    NotificationSystem:Create(
        "Script Loaded",
        "Blox Fruits Ultimate has been successfully loaded!",
        5
    )
    
    -- Auto save
    spawn(function()
        while wait(60) do
            SaveManager:Save()
        end
    end)
    
    -- Webhook de início
    WebhookSystem:Send("🎮 Script started by " .. game.Players.LocalPlayer.Name)
end

-- Detectar jogo correto
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    NotificationSystem:Create(
        "Wrong Game",
        "This script is only for Blox Fruits!",
        5
    )
    return
end

-- Verificações de segurança
local secure = true
local checks = {
    function()
        return not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
    end,
    function()
        return game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    end
}

for _, check in pairs(checks) do
    if not check() then
        secure = false
        break
    end
end

if not secure then
    NotificationSystem:Create(
        "Security Warning",
        "Possible detection detected. Please rejoin!",
        5
    )
    return
end

-- Finalização
NotificationSystem:Create(
    "Ready",
    "All systems initialized. Good gaming!",
    5
)

-- Exportar funções globais
getgenv().NotifyUser = function(title, text, duration)
    NotificationSystem:Create(title, text, duration)
end

getgenv().SaveConfig = function()
    SaveManager:Save()
end

getgenv().LoadConfig = function()
    SaveManager:Load()
end

-- Retornar API
return {
    Config = getgenv().Config,
    NotificationSystem = NotificationSystem,
    SaveManager = SaveManager,
    WebhookSystem = WebhookSystem,
    PerformanceBooster = PerformanceBooster
}
