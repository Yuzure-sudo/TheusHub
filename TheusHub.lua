local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoHaki = false,
    NoClip = false,
    TweenSpeed = 300,
    AttackDelay = 0.1,
    Method = "Behind",
    Distance = 5,
    AutoKen = false
}

local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]
local realbhit = require(game.ReplicatedStorage.CombatFramework.RigLib)
local cooldownfastattack = tick()

local QuestData = {
    ["Bandit"] = {Level = 0, Quest = "BanditQuest1", QuestTitle = "Bandit", CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231), Monster = "Bandit", MonsterCFrame = CFrame.new(1158.19141, 16.7761021, 1598.75867)},
    ["Monkey"] = {Level = 14, Quest = "JungleQuest", QuestTitle = "Monkey", CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838), Monster = "Monkey", MonsterCFrame = CFrame.new(-1448.51806, 50.851993, 102.934296)},
    ["Gorilla"] = {Level = 20, Quest = "JungleQuest", QuestTitle = "Gorilla", CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838), Monster = "Gorilla", MonsterCFrame = CFrame.new(-1129.56152, 40.1456909, -525.127869)},
    ["Pirate"] = {Level = 35, Quest = "BuggyQuest1", QuestTitle = "Pirate", CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498), Monster = "Pirate", MonsterCFrame = CFrame.new(-1169.5365, 5.09531212, 3933.84082)},
    ["Brute"] = {Level = 55, Quest = "BuggyQuest1", QuestTitle = "Brute", CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498), Monster = "Brute", MonsterCFrame = CFrame.new(-1165.09985, 14.8172617, 4363.51514)},
    ["Desert Bandit"] = {Level = 60, Quest = "DesertQuest", QuestTitle = "Desert Bandit", CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359), Monster = "Desert Bandit", MonsterCFrame = CFrame.new(932.788025, 6.8503746, 4488.24609)},
    ["Desert Officer"] = {Level = 70, Quest = "DesertQuest", QuestTitle = "Desert Officer", CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359), Monster = "Desert Officer", MonsterCFrame = CFrame.new(1617.07886, 1.5542295, 4295.54932)},
    ["Snow Bandit"] = {Level = 90, Quest = "SnowQuest", QuestTitle = "Snow Bandit", CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796), Monster = "Snow Bandit", MonsterCFrame = CFrame.new(1412.92346, 55.3503647, -1260.62036)},
    ["Snowman"] = {Level = 100, Quest = "SnowQuest", QuestTitle = "Snowman", CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796), Monster = "Snowman", MonsterCFrame = CFrame.new(1376.86401, 105.559189, -1411.06897)},
    ["Chief Petty Officer"] = {Level = 120, Quest = "MarineQuest2", QuestTitle = "Chief Petty Officer", CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018), Monster = "Chief Petty Officer", MonsterCFrame = CFrame.new(-4882.8623, 22.6520386, 4255.53516)},
    ["Sky Bandit"] = {Level = 150, Quest = "SkyQuest", QuestTitle = "Sky Bandit", CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165), Monster = "Sky Bandit", MonsterCFrame = CFrame.new(-4959.51367, 365.39267, -2974.56812)},
    ["Dark Master"] = {Level = 175, Quest = "SkyQuest", QuestTitle = "Dark Master", CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165), Monster = "Dark Master", MonsterCFrame = CFrame.new(-5079.98096, 376.477356, -2194.17139)}
}

local TheusHub = Instance.new("ScreenGui")
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui
TheusHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = TheusHub
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainWindow.BorderSizePixel = 0
MainWindow.Position = UDim2.new(0.5, -250, 0.5, -175)
MainWindow.Size = UDim2.new(0, 500, 0, 350)
MainWindow.Active = true
MainWindow.Draggable = true

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainWindow
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

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

local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainWindow
TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0, 35)
TabButtons.Size = UDim2.new(0, 100, 1, -35)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainWindow
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 100, 0, 35)
ContentContainer.Size = UDim2.new(1, -100, 1, -35)

local function CreateTabButton(name)
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
        ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)

    return ToggleFrame
end

local function FastAttack()
    if not getgenv().Settings.FastAttack then return end
    
    pcall(function()
        local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
        local CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
        CameraShakerR:Stop()
        CombatFramework.activeController.attacking = false
        CombatFramework.activeController.timeToNextAttack = 0
        CombatFramework.activeController.increment = 3
        CombatFramework.activeController.hitboxMagnitude = 100
        CombatFramework.activeController.blocking = false
        CombatFramework.activeController.timeToNextBlock = 0
        CombatFramework.activeController.focusStart = 0
        CombatFramework.activeController.humanoid.AutoRotate = true
    end)
end

local function StartAutoFarm()
    spawn(function()
        while getgenv().Settings.AutoFarm do
            pcall(function()
                local currentQuest = GetCurrentQuest()
                if currentQuest then
                    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentQuest.CFrameQuest
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentQuest.Quest, currentQuest.Level)
                        wait(0.5)
                    end

                    for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if mob.Name == currentQuest.Monster and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            repeat
                                wait()
                                if getgenv().Settings.AutoHaki then
                                    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                    end
                                end
                                
                                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                mob.HumanoidRootPart.Transparency = 0.8
                                mob.Humanoid.JumpPower = 0
                                mob.Humanoid.WalkSpeed = 0
                                
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                
                                FastAttack()
                            until not getgenv().Settings.AutoFarm or not mob.Parent or mob.Humanoid.Health <= 0 or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                        end
                    end
                end
            end)
            wait()
        end
    end)
end

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

local FarmingTab = CreateTabButton("Farming")
local TeleportTab = CreateTabButton("Teleport")
local FakeTab = CreateTabButton("Fake")

local FarmingPage = CreateContentPage("Farming")
local TeleportPage = CreateContentPage("Teleport")
local FakePage = CreateContentPage("Fake")

local AutoFarmToggle = CreateToggle(FarmingPage, "Auto Farm", function(enabled)
    getgenv().Settings.AutoFarm = enabled
    if enabled then
        StartAutoFarm()
    end
end)

local FastAttackToggle = CreateToggle(FarmingPage, "Fast Attack", function(enabled)
    getgenv().Settings.FastAttack = enabled
end)

local AutoHakiToggle = CreateToggle(FarmingPage, "Auto Buso", function(enabled)
    getgenv().Settings.AutoHaki = enabled
end)

local function SwitchTab(tabName)
    for _, content in pairs(ContentContainer:GetChildren()) do
        content.Visible = content.Name == tabName.."Page"
    end
end

FarmingTab.MouseButton1Click:Connect(function() SwitchTab("Farming") end)
TeleportTab.MouseButton1Click:Connect(function() SwitchTab("Teleport") end)
FakeTab.MouseButton1Click:Connect(function() SwitchTab("Fake") end)

SwitchTab("Farming")

spawn(function()
    while wait() do
        if getgenv().Settings.FastAttack then
            FastAttack()
        end
    end
end)

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)