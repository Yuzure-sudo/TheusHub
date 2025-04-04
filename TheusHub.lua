-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Variáveis Locais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações
_G.AutoFarm = false
_G.AutoStats = false
_G.TweenSpeed = 350
_G.SelectedStat = "Melee"
_G.FastAttack = false
_G.AutoHaki = false

-- Quest Data Sea 1
local QuestData = {
    ["Bandit"] = {
        Level = 0,
        Quest = "BanditQuest1",
        QuestTitle = "Bandit",
        CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544),
        Monster = "Bandit",
        LevelRequirement = 0,
        Reward = 150
    },
    ["Monkey"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestTitle = "Monkey",
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        Monster = "Monkey",
        LevelRequirement = 14,
        Reward = 800
    },
    ["Gorilla"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestTitle = "Gorilla",
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        Monster = "Gorilla",
        LevelRequirement = 20,
        Reward = 1200
    },
    ["Pirate"] = {
        Level = 35,
        Quest = "BuggyQuest1",
        QuestTitle = "Pirate",
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506),
        Monster = "Pirate",
        LevelRequirement = 35,
        Reward = 3000
    },
    ["Brute"] = {
        Level = 55,
        Quest = "BuggyQuest1",
        QuestTitle = "Brute",
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506),
        Monster = "Brute",
        LevelRequirement = 55,
        Reward = 4500
    },
    ["Desert Bandit"] = {
        Level = 60,
        Quest = "DesertQuest",
        QuestTitle = "Desert Bandit",
        CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),
        Monster = "Desert Bandit",
        LevelRequirement = 60,
        Reward = 5000
    },
    ["Desert Officer"] = {
        Level = 70,
        Quest = "DesertQuest",
        QuestTitle = "Desert Officer",
        CFrameQuest = CFrame.new(894.488647, 5.14000225, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),
        Monster = "Desert Officer",
        LevelRequirement = 70,
        Reward = 6500
    },
    ["Snow Bandit"] = {
        Level = 90,
        Quest = "SnowQuest",
        QuestTitle = "Snow Bandit",
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -0, -0.937287986, 0, 1, -0, 0.937287986, 0, 0.348555952),
        Monster = "Snow Bandit",
        LevelRequirement = 90,
        Reward = 8000
    },
    ["Snowman"] = {
        Level = 100,
        Quest = "SnowQuest",
        QuestTitle = "Snowman",
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -0, -0.937287986, 0, 1, -0, 0.937287986, 0, 0.348555952),
        Monster = "Snowman",
        LevelRequirement = 100,
        Reward = 9000
    }
}

-- Funções Utilitárias
local function GetDistance(targetPosition)
    return (HumanoidRootPart.Position - targetPosition).Magnitude
end

local function Tween(targetPosition)
    local distance = GetDistance(targetPosition)
    local time = distance/_G.TweenSpeed
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    return tween
end

-- Sistema de Auto Farm
local function GetCurrentQuest()
    local playerLevel = Player.Data.Level.Value
    for _, questInfo in pairs(QuestData) do
        if playerLevel >= questInfo.LevelRequirement then
            return questInfo
        end
    end
    return QuestData["Bandit"] -- Quest padrão
end

local function CheckQuest()
    local currentQuest = GetCurrentQuest()
    if not Player.PlayerGui.Main.Quest.Visible then
        Tween(currentQuest.CFrameQuest.Position)
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentQuest.Quest, currentQuest.LevelRequirement)
    end
end

local function GetMonster()
    local currentQuest = GetCurrentQuest()
    local monsters = workspace.Enemies:GetChildren()
    for _, monster in pairs(monsters) do
        if monster.Name == currentQuest.Monster and monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") and monster.Humanoid.Health > 0 then
            return monster
        end
    end
    return nil
end

-- Fast Attack System
local function EnableFastAttack()
    local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
    local CombatFrameworkR = getupvalues(CombatFramework)[2]
    local CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
    CameraShakerR:Stop()
    
    spawn(function()
        while _G.FastAttack do
            pcall(function()
                CombatFrameworkR.activeController.hitboxMagnitude = 55
                CombatFrameworkR.activeController.timeToNextAttack = 0
                CombatFrameworkR.activeController.attacking = false
                CombatFrameworkR.activeController.increment = 3
            end)
            wait(0.1)
        end
    end)
end

-- Auto Stats System
local function AutoStats()
    while _G.AutoStats do
        local args = {[1] = _G.SelectedStat}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", unpack(args))
        wait(0.1)
    end
end

-- Auto Haki System
local function AutoHaki()
    while _G.AutoHaki do
        if not Player.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
        wait(1)
    end
end

-- Main Farm Loop
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local monster = GetMonster()
                
                if monster then
                    repeat
                        wait()
                        Tween(monster.HumanoidRootPart.Position + Vector3.new(0,30,0))
                        monster.HumanoidRootPart.Size = Vector3.new(60,60,60)
                        monster.HumanoidRootPart.Transparency = 1
                        monster.Humanoid.JumpPower = 0
                        monster.Humanoid.WalkSpeed = 0
                        if _G.AutoHaki then
                            if not Player.Character:FindFirstChild("HasBuso") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                            end
                        end
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
                    until not monster.Parent or monster.Humanoid.Health <= 0 or not _G.AutoFarm
                else
                    local questCFrame = GetCurrentQuest().CFrameQuest
                    Tween(questCFrame.Position)
                end
            end)
        end
    end
end)

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)