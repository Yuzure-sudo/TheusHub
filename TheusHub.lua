-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- Configurações
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoQuest = false,
    NoClip = false,
    AutoHaki = false,
    TweenSpeed = 350
}

-- Interface Principal
local TheusHub = Instance.new("ScreenGui")
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui
TheusHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = TheusHub
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainWindow.BorderSizePixel = 0
MainWindow.Position = UDim2.new(0.5, -250, 0.5, -175)
MainWindow.Size = UDim2.new(0, 500, 0, 350)
MainWindow.Active = true
MainWindow.Draggable = true

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainWindow
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Buttons
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainWindow
TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0, 35)
TabButtons.Size = UDim2.new(0, 100, 1, -35)

-- Função para criar botões de tab com estilo moderno
local function CreateTabButton(name, imageId)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabButtons
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (#TabButtons:GetChildren() - 1) * 40)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 12
    TabButton.AutoButtonColor = false

    -- Efeito hover
    TabButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    TabButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)

    return TabButton
end

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainWindow
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 100, 0, 35)
ContentContainer.Size = UDim2.new(1, -100, 1, -35)

-- Criar páginas de conteúdo
local function CreateContentPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name.."Page"
    Page.Parent = ContentContainer
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Page
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = Page
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    
    return Page
end

-- Criar Toggles modernos
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text.."Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
    ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local enabled = false
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        }):Play()
        callback(enabled)
    end)

    return ToggleFrame
end

-- Criar Tabs
local FramingTab = CreateTabButton("Framing")
local TeleportTab = CreateTabButton("Teleport")
local FakeTab = CreateTabButton("Fake")

-- Criar Pages
local FramingPage = CreateContentPage("Framing")
local TeleportPage = CreateContentPage("Teleport")
local FakePage = CreateContentPage("Fake")

-- Sistema de Switch Tab
local function SwitchTab(tabName)
    for _, page in pairs(ContentContainer:GetChildren()) do
        if page:IsA("ScrollingFrame") then
            page.Visible = page.Name == tabName.."Page"
        end
    end
end

FramingTab.MouseButton1Click:Connect(function() SwitchTab("Framing") end)
TeleportTab.MouseButton1Click:Connect(function() SwitchTab("Teleport") end)
FakeTab.MouseButton1Click:Connect(function() SwitchTab("Fake") end)

-- Mostrar primeira tab por padrão
SwitchTab("Framing")

-- Quest Data Sea 1 Completo
local QuestData = {
    ["Bandit"] = {
        Level = 0,
        Quest = "BanditQuest1",
        QuestTitle = "Bandit",
        CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231),
        Monster = "Bandit",
        MonsterCFrame = CFrame.new(1158.19141, 16.7761021, 1598.75867)
    },
    ["Monkey"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestTitle = "Monkey",
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838),
        Monster = "Monkey",
        MonsterCFrame = CFrame.new(-1448.51806, 50.851993, 102.934296)
    },
    ["Gorilla"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestTitle = "Gorilla",
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838),
        Monster = "Gorilla",
        MonsterCFrame = CFrame.new(-1129.56152, 40.1456909, -525.127869)
    },
    ["Pirate"] = {
        Level = 35,
        Quest = "BuggyQuest1",
        QuestTitle = "Pirate",
        CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
        Monster = "Pirate",
        MonsterCFrame = CFrame.new(-1169.5365, 5.09531212, 3933.84082)
    },
    ["Brute"] = {
        Level = 55,
        Quest = "BuggyQuest1",
        QuestTitle = "Brute",
        CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
        Monster = "Brute",
        MonsterCFrame = CFrame.new(-1165.09985, 14.8172617, 4363.51514)
    },
    ["Desert Bandit"] = {
        Level = 60,
        Quest = "DesertQuest",
        QuestTitle = "Desert Bandit",
        CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359),
        Monster = "Desert Bandit",
        MonsterCFrame = CFrame.new(932.788025, 6.8503746, 4488.24609)
    },
    ["Desert Officer"] = {
        Level = 70,
        Quest = "DesertQuest",
        QuestTitle = "Desert Officer",
        CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359),
        Monster = "Desert Officer",
        MonsterCFrame = CFrame.new(1617.07886, 1.5542295, 4295.54932)
    },
    ["Snow Bandit"] = {
        Level = 90,
        Quest = "SnowQuest",
        QuestTitle = "Snow Bandit",
        CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796),
        Monster = "Snow Bandit",
        MonsterCFrame = CFrame.new(1412.92346, 55.3503647, -1260.62036)
    },
    ["Snowman"] = {
        Level = 100,
        Quest = "SnowQuest",
        QuestTitle = "Snowman",
        CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796),
        Monster = "Snowman",
        MonsterCFrame = CFrame.new(1376.86401, 105.559189, -1411.06897)
    },
    ["Chief Petty Officer"] = {
        Level = 120,
        Quest = "MarineQuest2",
        QuestTitle = "Chief Petty Officer",
        CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018),
        Monster = "Chief Petty Officer",
        MonsterCFrame = CFrame.new(-4882.8623, 22.6520386, 4255.53516)
    },
    ["Sky Bandit"] = {
        Level = 150,
        Quest = "SkyQuest",
        QuestTitle = "Sky Bandit",
        CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165),
        Monster = "Sky Bandit",
        MonsterCFrame = CFrame.new(-4959.51367, 365.39267, -2974.56812)
    },
    ["Dark Master"] = {
        Level = 175,
        Quest = "SkyQuest",
        QuestTitle = "Dark Master",
        CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165),
        Monster = "Dark Master",
        MonsterCFrame = CFrame.new(-5079.98096, 376.477356, -2194.17139)
    },
    ["Prisoner"] = {
        Level = 190,
        Quest = "PrisonerQuest",
        QuestTitle = "Prisoner",
        CFrameQuest = CFrame.new(5310.61035, 0.350014925, 474.946594),
        Monster = "Prisoner",
        MonsterCFrame = CFrame.new(5099.29639, 0.351563841, 677.379699)
    },
    ["Dangerous Prisoner"] = {
        Level = 210,
        Quest = "PrisonerQuest",
        QuestTitle = "Dangerous Prisoner",
        CFrameQuest = CFrame.new(5310.61035, 0.350014925, 474.946594),
        Monster = "Dangerous Prisoner",
        MonsterCFrame = CFrame.new(5563.72754, 0.351563841, 827.980103)
    },
    ["Toga Warrior"] = {
        Level = 250,
        Quest = "ColosseumQuest",
        QuestTitle = "Toga Warrior",
        CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534),
        Monster = "Toga Warrior",
        MonsterCFrame = CFrame.new(-1779.97583, 44.6077499, -2736.35474)
    },
    ["Military Soldier"] = {
        Level = 300,
        Quest = "MagmaQuest",
        QuestTitle = "Military Soldier",
        CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998),
        Monster = "Military Soldier",
        MonsterCFrame = CFrame.new(-5363.01123, 41.5056877, 8548.47266)
    },
    ["Military Spy"] = {
        Level = 330,
        Quest = "MagmaQuest",
        QuestTitle = "Military Spy",
        CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998),
        Monster = "Military Spy",
        MonsterCFrame = CFrame.new(-5787.99023, 120.864456, 8762.25293)
    },
    ["Fishman Warrior"] = {
        Level = 375,
        Quest = "FishmanQuest",
        QuestTitle = "Fishman Warrior",
        CFrameQuest = CFrame.new(61122.65234, 18.4716396, 1568.16504),
        Monster = "Fishman Warrior",
        MonsterCFrame = CFrame.new(60946.6094, 48.6735229, 1525.91687)
    },
    ["Fishman Commando"] = {
        Level = 400,
        Quest = "FishmanQuest",
        QuestTitle = "Fishman Commando",
        CFrameQuest = CFrame.new(61122.65234, 18.4716396, 1568.16504),
        Monster = "Fishman Commando",
        MonsterCFrame = CFrame.new(61892.2031, 18.4716396, 1504.17896)
    },
    ["God's Guard"] = {
        Level = 450,
        Quest = "SkyExp1Quest",
        QuestTitle = "God's Guard",
        CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643),
        Monster = "God's Guard",
        MonsterCFrame = CFrame.new(-4716.95703, 853.089722, -1933.925427)
    },
    ["Shanda"] = {
        Level = 475,
        Quest = "SkyExp1Quest",
        QuestTitle = "Shanda",
        CFrameQuest = CFrame.new(-7863.63672, 5545.49316, -379.826324),
        Monster = "Shanda",
        MonsterCFrame = CFrame.new(-7685.12354, 5601.05127, -443.171509)
    },
    ["Royal Squad"] = {
        Level = 525,
        Quest = "SkyExp2Quest",
        QuestTitle = "Royal Squad",
        CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802),
        Monster = "Royal Squad",
        MonsterCFrame = CFrame.new(-7685.02051, 5606.87842, -1442.729)
    },
    ["Royal Soldier"] = {
        Level = 550,
        Quest = "SkyExp2Quest",
        QuestTitle = "Royal Soldier",
        CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802),
        Monster = "Royal Soldier",
        MonsterCFrame = CFrame.new(-7864.44775, 5661.94092, -1708.22351)
    },
    ["Galley Pirate"] = {
        Level = 625,
        Quest = "FountainQuest",
        QuestTitle = "Galley Pirate",
        CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678),
        Monster = "Galley Pirate",
        MonsterCFrame = CFrame.new(5595.06982, 41.5013695, 3961.47095)
    },
    ["Galley Captain"] = {
        Level = 650,
        Quest = "FountainQuest",
        QuestTitle = "Galley Captain",
        CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678),
        Monster = "Galley Captain",
        MonsterCFrame = CFrame.new(5658.5752, 38.5361786, 4928.93506)
    }
}

-- Função para pegar a quest atual baseada no nível
local function GetCurrentQuest()
    local playerLevel = game.Players.LocalPlayer.Data.Level.Value
    local currentQuest = nil
    
    for _, quest in pairs(QuestData) do
        if playerLevel >= quest.Level then
            currentQuest = quest
        end
    end
    
    return currentQuest
end

-- Funções de Utilidade
local function GetDistance(targetPosition)
    local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        return (humanoidRootPart.Position - targetPosition).Magnitude
    end
    return math.huge
end

local function Tween(targetCFrame)
    local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local distance = GetDistance(targetCFrame.Position)
        local tweenInfo = TweenInfo.new(distance/getgenv().Settings.TweenSpeed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- Sistema de Auto Farm
local function StartAutoFarm()
    spawn(function()
        while getgenv().Settings.AutoFarm do
            pcall(function()
                local currentQuest = GetCurrentQuest()
                if currentQuest then
                    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                        -- Pegar Quest
                        Tween(currentQuest.CFrameQuest)
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentQuest.Quest, currentQuest.Level)
                        wait(0.5)
                    end

                    -- Farm Mobs
                    for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if mob.Name == currentQuest.Monster and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            repeat
                                wait()
                                if getgenv().Settings.AutoHaki then
                                    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                    end
                                end
                                
                                if getgenv().Settings.AutoKen then
                                    if not game.Players.LocalPlayer.Character:FindFirstChild("HasKen") then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenHaki")
                                    end
                                end
                                
                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 0.8
                                mob.Humanoid.JumpPower = 0
                                mob.Humanoid.WalkSpeed = 0
                                
                                Tween(mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                
                                if getgenv().Settings.FastAttack then
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                end
                            until not getgenv().Settings.AutoFarm or not mob.Parent or mob.Humanoid.Health <= 0 or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                        end
                    end
                end
            end)
            wait()
        end
    end)
end

-- Adicionando Toggles na Interface
-- Farming Page
local AutoFarmToggle = CreateToggle(FramingPage, "Auto Farm", function(enabled)
    getgenv().Settings.AutoFarm = enabled
    if enabled then
        StartAutoFarm()
    end
end)

local FastAttackToggle = CreateToggle(FramingPage, "Fast Attack", function(enabled)
    getgenv().Settings.FastAttack = enabled
end)

local AutoHakiToggle = CreateToggle(FramingPage, "Auto Buso", function(enabled)
    getgenv().Settings.AutoHaki = enabled
end)

local AutoKenToggle = CreateToggle(FramingPage, "Auto Ken", function(enabled)
    getgenv().Settings.AutoKen = enabled
end)

-- Teleport Page
local function CreateTeleportButton(name, cframe)
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Name = name.."Button"
    TeleportButton.Parent = TeleportPage
    TeleportButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Size = UDim2.new(1, 0, 0, 40)
    TeleportButton.Font = Enum.Font.GothamSemibold
    TeleportButton.Text = name
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 14
    
    TeleportButton.MouseButton1Click:Connect(function()
        Tween(cframe)
    end)
    
    return TeleportButton
end

-- Adicionar botões de teleporte para todas as áreas importantes
local TeleportLocations = {
    ["First Island"] = CFrame.new(1041.79712, 16.1520348, 1426.06348),
    ["Marine Base"] = CFrame.new(-4914.8212890625, 50.963626861572266, 4281.0498046875),
    ["Middle Town"] = CFrame.new(-655.824158, 7.88708115, 1436.67908),
    ["Jungle"] = CFrame.new(-1249.77222, 11.8870859, 341.356476),
    ["Pirate Village"] = CFrame.new(-1122.34998, 4.78708982, 3855.91992),
    ["Desert"] = CFrame.new(1094.14587, 6.47350502, 4192.88721),
    ["Frozen Village"] = CFrame.new(1198.00928, 27.0074959, -1211.73376),
    ["MarineFord"] = CFrame.new(-4882.8623, 22.6520386, 4255.53516),
    ["Colosseum"] = CFrame.new(-1836.58191, 44.5890656, -2969.25659),
    ["Sky Island 1"] = CFrame.new(-4970.21875, 717.707275, -2622.35449),
    ["Sky Island 2"] = CFrame.new(-7994.5127, 5756.34229, -2088.54688),
    ["Sky Island 3"] = CFrame.new(-7925.48389, 5550.76074, -863.114502),
    ["Prison"] = CFrame.new(4875.330078125, 5.6519818305969238, 734.85021972656),
    ["Magma Village"] = CFrame.new(-5231.75879, 8.61593437, 8467.87695),
    ["Underwater City"] = CFrame.new(61163.8516, 11.7796879, 1819.78418),
    ["Fountain City"] = CFrame.new(5132.7124, 4.53632832, 4037.8562)
}

for name, cframe in pairs(TeleportLocations) do
    CreateTeleportButton(name, cframe)
end

-- Fake Page
local function CreateFakeButton(name, callback)
    local FakeButton = Instance.new("TextButton")
    FakeButton.Name = name.."Button"
    FakeButton.Parent = FakePage
    FakeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    FakeButton.BorderSizePixel = 0
    FakeButton.Size = UDim2.new(1, 0, 0, 40)
    FakeButton.Font = Enum.Font.GothamSemibold
    FakeButton.Text = name
    FakeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FakeButton.TextSize = 14
    
    FakeButton.MouseButton1Click:Connect(callback)
    
    return FakeButton
end

-- Adicionar botões fake
CreateFakeButton("Fake Level", function()
    -- Implementar lógica de fake level
end)

CreateFakeButton("Fake Beli", function()
    -- Implementar lógica de fake beli
end)

CreateFakeButton("Fake Fragment", function()
    -- Implementar lógica de fake fragment
end)

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)