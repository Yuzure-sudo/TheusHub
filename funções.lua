-- Variáveis Globais e Configurações
getgenv().AutoFarm = false
getgenv().TweenSpeed = 250
getgenv().AutoFarmBone = false
getgenv().AutoEliteHunter = false
getgenv().AutoFactory = false
getgenv().AutoNewWorld = false
getgenv().AutoThirdWorld = false
getgenv().AutoBartilo = false
getgenv().AutoRengoku = false
getgenv().AutoEctoplasm = false
getgenv().AutoBudySword = false
getgenv().AutoFarmBoss = false
getgenv().AutoFarmAllBoss = false
getgenv().AutoFarmFruitMastery = false
getgenv().AutoFarmGunMastery = false
getgenv().AutoHolyTorch = false
getgenv().AutoCombo = false
getgenv().AutoSeaBeast = false
getgenv().AutoPole = false
getgenv().AutoSaber = false
getgenv().AutoSuperhuman = false
getgenv().AutoSharkman = false
getgenv().AutoDeathStep = false
getgenv().AutoElectricClaw = false
getgenv().AutoDragonTalon = false
getgenv().AutoGodhuman = false
getgenv().AutoStoreFruit = false

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
    ["150-174"] = {
        Monster = "Sky Bandit [Lv. 150]",
        Quest = "SkyQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353)
    },
    ["175-189"] = {
        Monster = "Dark Master [Lv. 175]",
        Quest = "SkyQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456)
    },
    ["190-209"] = {
        Monster = "Prisoner [Lv. 190]",
        Quest = "PrisonerQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(5310.61035, 0.350014925, 474.946594),
        CFrameMon = CFrame.new(5093.04199, -0.144462526, 478.985931)
    },