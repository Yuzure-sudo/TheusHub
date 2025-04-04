local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Hub", "DarkTheme")

-- Variáveis Globais e Configurações
getgenv().AutoFarm = false
getgenv().TweenSpeed = 250
getgenv().AutoMelee = false
getgenv().AutoDefense = false
getgenv().AutoSword = false
getgenv().AutoGun = false
getgenv().AutoDevilFruit = false

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Quest Data Sea 1
local QuestData = {
    ["1-9"] = {
        Monster = "Bandit [Lv. 5]",
        Quest = "BanditQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905),
        CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516)
    },
    ["10-14"] = {
        Monster = "Monkey [Lv. 14]",
        Quest = "JungleQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1772.4093017578, 60.860641479492, 54.872589111328)
    },
    ["15-29"] = {
        Monster = "Gorilla [Lv. 20]",
        Quest = "JungleQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664)
    },
    ["30-39"] = {
        Monster = "Pirate [Lv. 35]",
        Quest = "BuggyQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211),
        CFrameMon = CFrame.new(-1219.32324, 4.75205183, 3915.63452)
    },
    ["40-59"] = {
        Monster = "Brute [Lv. 45]",
        Quest = "BuggyQuest1",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211),
        CFrameMon = CFrame.new(-1146.49646, 96.0936813, 4312.1333)
    },
    ["60-74"] = {
        Monster = "Desert Bandit [Lv. 60]",
        Quest = "DesertQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168),
        CFrameMon = CFrame.new(932.788818, 6.4503746, 4488.24609)
    },
    ["75-89"] = {
        Monster = "Desert Officer [Lv. 70]",
        Quest = "DesertQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168),
        CFrameMon = CFrame.new(1580.03198, 4.61375761, 4366.86426)
    },
    ["90-99"] = {
        Monster = "Snow Bandit [Lv. 90]",
        Quest = "SnowQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482),
        CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905)
    },
    ["100-119"] = {
        Monster = "Snowman [Lv. 100]",
        Quest = "SnowQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482),
        CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905)
    },
    ["120-149"] = {
        Monster = "Chief Petty Officer [Lv. 120]",
        Quest = "MarineQuest2",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-5035.0835, 28.6520386, 4325.29443),
        CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516)
    },
}

-- Funções Utilitárias Base
function Tween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local distance = (targetCFrame.Position - humanoidRootPart.Position).Magnitude
    
    local tweenInfo = TweenInfo.new(
        distance/getgenv().TweenSpeed,
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0,
        false
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return tween
end

-- Sistema de Auto Farm Principal
function AutoFarmQuest()
    if getgenv().AutoFarm then
        pcall(function()
            local PlayerLevel = LocalPlayer.Data.Level.Value
            local QuestInfo
            
            -- Determina qual tabela de quests usar baseado no nível
            for range, info in pairs(QuestData) do
                local min, max = range:match("(%d+)-(%d+)")
                if PlayerLevel >= tonumber(min) and PlayerLevel <= tonumber(max) then
                    QuestInfo = info
                    break
                end
            end
            
            if QuestInfo then
                if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(QuestInfo.CFrameQuest)
                    wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestInfo.Quest, QuestInfo.QuestLv)
                    wait(0.5)
                end
                
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == QuestInfo.Monster and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            mob.HumanoidRootPart.Size = Vector3.new(60,60,60)
                            mob.HumanoidRootPart.Transparency = 0.8
                            mob.Humanoid.JumpPower = 0
                            mob.Humanoid.WalkSpeed = 0
                            mob.HumanoidRootPart.CanCollide = false
                            mob.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,-50)
                            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until not getgenv().AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent
                    end
                end
                
                if not workspace.Enemies:FindFirstChild(QuestInfo.Monster) then
                    Tween(QuestInfo.CFrameMon)
                end
            end
        end)
    end
end

-- Sistema de Auto Stats
function AutoStats()
    spawn(function()
        while wait() do
            if getgenv().AutoMelee then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if getgenv().AutoDefense then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if getgenv().AutoSword then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if getgenv().AutoGun then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if getgenv().AutoDevilFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end
    end)
end

-- Sistema de Auto Haki
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Sistema de Auto Skills
function AutoSkills()
    spawn(function()
        while wait() do
            if getgenv().AutoFarm then
                pcall(function()
                    local args = {
                        [1] = "Z",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "X",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "C",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "V",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                end)
            end
        end
    end)
end

-- Interface
local MainTab = Window:NewTab("Main")
local FarmTab = Window:NewTab("Farm")
local StatsTab = Window:NewTab("Stats")

-- Main Section
local MainSection = MainTab:NewSection("Overview")
MainSection:NewLabel("Welcome to Theus Hub!")
MainSection:NewLabel("This hub provides various features to enhance your gameplay.")

-- Farm Section
local FarmSection = FarmTab:NewSection("Auto Farm")
FarmSection:NewToggle("Auto Farm", "Automatically farms with quests", function(state)
    getgenv().AutoFarm = state
end)

FarmSection:NewSlider("Tween Speed", "Adjust the tween speed", 500, 50, function(value)
    getgenv().TweenSpeed = value
end)

-- Stats Section
local StatsSection = StatsTab:NewSection("Auto Stats")
StatsSection:NewToggle("Auto Melee", "", function(state)
    getgenv().AutoMelee = state
end)

StatsSection:NewToggle("Auto Defense", "", function(state)
    getgenv().AutoDefense = state
end)

StatsSection:NewToggle("Auto Sword", "", function(state)
    getgenv().AutoSword = state
end)

StatsSection:NewToggle("Auto Gun", "", function(state)
    getgenv().AutoGun = state
end)

StatsSection:NewToggle("Auto Devil Fruit", "", function(state)
    getgenv().AutoDevilFruit = state
end)