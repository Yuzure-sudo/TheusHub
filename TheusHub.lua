-- Blox Fruits Auto Farm Script (Sea 1) v4.0
-- Otimizado para 2025

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "BF Auto Farm Sea 1", HidePremium = false})

-- Configurações Principais
getgenv().Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoSkill = false,
    FastAttack = false,
    AutoHaki = false,
    SelectedMob = "Bandit [Lv. 5]",
    Distance = 5
}

-- Serviços do Jogo
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Interface Principal
local FarmTab = Window:MakeTab({
    Name = "Principal",
    Icon = "rbxassetid://4483345998"
})

FarmTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarm = Value
        if Value then
            StartAutoFarm()
        end
    end
})

FarmTab:AddToggle({
    Name = "Auto Quest",
    Default = false,
    Callback = function(Value)
        Settings.AutoQuest = Value
    end
})

FarmTab:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(Value)
        Settings.FastAttack = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Haki",
    Default = false,
    Callback = function(Value)
        Settings.AutoHaki = Value
    end
})

FarmTab:AddDropdown({
    Name = "Selecionar Mob",
    Default = "Bandit [Lv. 5]",
    Options = {
        "Bandit [Lv. 5]",
        "Monkey [Lv. 14]",
        "Gorilla [Lv. 20]",
        "Pirate [Lv. 35]",
        "Brute [Lv. 45]",
        "Desert Bandit [Lv. 60]",
        "Desert Officer [Lv. 70]",
        "Snow Bandit [Lv. 90]",
        "Snowman [Lv. 100]"
    },
    Callback = function(Value)
        Settings.SelectedMob = Value
    end
})

-- Sistema Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Funções Principais
function GetQuest()
    local args = {
        [1] = "StartQuest",
        [2] = GetQuestName(),
        [3] = GetQuestLevel()
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function GetMob()
    local Mob = nil
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == Settings.SelectedMob and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            Mob = v
            break
        end
    end
    return Mob
end

function Teleport(Position)
    LocalPlayer.Character.HumanoidRootPart.CFrame = Position
end

function Attack()
    if Settings.FastAttack then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
    end
end

function AutoHaki()
    if Settings.AutoHaki then
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end
end

-- Sistema Principal de Farm
function StartAutoFarm()
    spawn(function()
        while Settings.AutoFarm do
            if Settings.AutoQuest then
                GetQuest()
            end
            
            local Mob = GetMob()
            if Mob then
                repeat
                    AutoHaki()
                    Attack()
                    Teleport(Mob.HumanoidRootPart.CFrame * CFrame.new(0,Settings.Distance,0))
                    wait()
                until not Settings.AutoFarm or not Mob or Mob.Humanoid.Health <= 0
            end
            wait()
        end
    end)
end

-- Sistema de Skills
local SkillsTab = Window:MakeTab({
    Name = "Skills",
    Icon = "rbxassetid://4483345998"
})

SkillsTab:AddToggle({
    Name = "Auto Skills",
    Default = false,
    Callback = function(Value)
        Settings.AutoSkill = Value
        if Value then
            StartAutoSkill()
        end
    end
})

function StartAutoSkill()
    spawn(function()
        while Settings.AutoSkill do
            if Settings.AutoFarm then
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                    wait(1)
                end)
            end
            wait(1)
        end
    end)
end

-- Sistema de Teleporte
local TeleportTab = Window:MakeTab({
    Name = "Teleporte",
    Icon = "rbxassetid://4483345998"
})

local Locations = {
    ["Cidade Inicial"] = CFrame.new(1042.1501464844, 16.299360275269, 1444.3442382813),
    ["Marine Base"] = CFrame.new(-2573.3374023438, 6.8556680679321, 2046.4749755859),
    ["Middle Town"] = CFrame.new(-655.824462890625, 7.857785701751709, 1436.7272949219),
    ["Jungle"] = CFrame.new(-1249.77392578125, 11.852051734924316, 341.7265625),
    ["Pirate Village"] = CFrame.new(-1122.34716796875, 4.787090301513672, 3855.440185546875),
    ["Desert"] = CFrame.new(1094.14587402344, 6.8521223068237, 4192.88671875),
    ["Snow Island"] = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469)
}

for LocationName, Position in pairs(Locations) do
    TeleportTab:AddButton({
        Name = LocationName,
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = Position
        end
    })
end

-- Sistema de Stats
local StatsTab = Window:MakeTab({
    Name = "Stats",
    Icon = "rbxassetid://4483345998"
})

StatsTab:AddToggle({
    Name = "Auto Stats",
    Default = false,
    Callback = function(Value)
        Settings.AutoStats = Value
        if Value then
            StartAutoStats()
        end
    end
})

function StartAutoStats()
    spawn(function()
        while Settings.AutoStats do
            local args = {
                [1] = "AddPoint",
                [2] = "Melee",
                [3] = 1
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            wait(0.1)
        end
    end)
end

-- Configurações Extras
local MiscTab = Window:MakeTab({
    Name = "Extras",
    Icon = "rbxassetid://4483345998"
})

MiscTab:AddSlider({
    Name = "Distância do Mob",
    Min = 0,
    Max = 10,
    Default = 5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        Settings.Distance = Value
    end    
})

-- Inicialização do Script
OrionLib:Init()

-- Notificação de Início
OrionLib:MakeNotification({
    Name = "Script Carregado",
    Content = "Auto Farm Sea 1 iniciado com sucesso!",
    Image = "rbxassetid://4483345998",
    Time = 5
})