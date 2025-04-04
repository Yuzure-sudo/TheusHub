-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Quest Data
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
    ["150-174"] = {
        Monster = "Sky Bandit [Lv. 150]",
        Quest = "SkyQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353)
    },
    ["175-199"] = {
        Monster = "Dark Master [Lv. 175]",
        Quest = "SkyQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-5148.65576, 315.896149, -2966.29443)
    },
    ["200-249"] = {
        Monster = "Prisoner [Lv. 190]",
        Quest = "PrisonQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514),
        CFrameMon = CFrame.new(5433.39307, 88.7827377, 514.986877)
    },
    ["250-299"] = {
        Monster = "Dangerous Prisoner [Lv. 210]",
        Quest = "PrisonQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514),
        CFrameMon = CFrame.new(5433.39307, 88.7827377, 514.986877)
    },
    ["300-349"] = {
        Monster = "Imposter [Lv. 300]",
        Quest = "SkyQ4est",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-4970.74219, 371.542358, -2931.52637),
        CFrameMon = CFrame.new(-5444.5625, 601.207275, -2972.15723)
    },
    ["350-374"] = {
        Monster = "Posessed Mink [Lv. 340]",
        Quest = "ColosseumQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1577.58059, 7.38933945, -2984.53564),
        CFrameMon = CFrame.new(-1887.58472, 88.2324295, -3021.78467)
    },
    ["375-399"] = {
        Monster = "Galley Pirate [Lv. 360]",
        Quest = "ColosseumQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1577.58059, 7.38933945, -2984.53564),
        CFrameMon = CFrame.new(-1876.91589, 73.0770416, -2789.8958)
    },
    ["400-449"] = {
        Monster = "Raider [Lv. 400]",
        Quest = "IceSideQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-5418.92236, 10.9001846, -5296.53223),
        CFrameMon = CFrame.new(-5552.69336, 60.7770386, -5484.03906)
    },
    ["450-499"] = {
        Monster = "Arctic Warrior [Lv. 425]",
        Quest = "IceSideQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-5418.92236, 10.9001846, -5296.53223),
        CFrameMon = CFrame.new(-5984.18115, 82.3534927, -5833.93506)
    },
    ["500-599"] = {
        Monster = "Snow Lurker [Lv. 500]",
        Quest = "FrostQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107),
        CFrameMon = CFrame.new(5518.00684, 60.5559731, -6828.80518)
    },
    ["600-699"] = {
        Monster = "Sea Soldier [Lv. 600]",
        Quest = "FrostQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107),
        CFrameMon = CFrame.new(5659.5002, 111.874153, -6479.60547)
    },
    ["700-749"] = {
        Monster = "Water Fighter [Lv. 675]",
        Quest = "DeepForestIsland3Quest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-10580.9102, 330.379028, -8667.68262),
        CFrameMon = CFrame.new(-10557.6943, 412.466034, -9722.3853)
    },
    ["750-799"] = {
        Monster = "Fishman Warrior [Lv. 725]",
        Quest = "DeepForestIsland3Quest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-10580.9102, 330.379028, -8667.68262),
        CFrameMon = CFrame.new(-10523.1875, 392.87973, -10510.6309)
    },
    ["800-849"] = {
        Monster = "Fishman Commando [Lv. 750]",
        Quest = "FishmanQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(61123.0859, 18.5066795, 1570.18018),
        CFrameMon = CFrame.new(61163.8516, 28.7774258, 1819.76708)
    },
    ["850-899"] = {
        Monster = "God's Guard [Lv. 975]",
        Quest = "FishmanQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(61123.0859, 18.5066795, 1570.18018),
        CFrameMon = CFrame.new(8787.17969, 143.610001, 4288.6377)
    }
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
                            
                            -- Sistema de FastStack
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
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1

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