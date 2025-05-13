-- Wirtz Scripts - Blox Fruits Ultimate
-- Versão: 4.0.1 Premium

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

getgenv().Settings = {
    Main = {
        AutoFarm = false,
        FastAttack = false,
        AutoQuest = false,
        SelectedMob = "Bandit [Lv. 5]",
        Distance = 5,
        AutoHaki = false,
        Mastery = false
    },
    Fruits = {
        AutoSniper = false,
        StoreFruit = false,
        ESP = false
    },
    Combat = {
        KillAura = false,
        AutoSkills = false,
        PerfectBlock = false
    },
    Player = {
        Speed = 16,
        Jump = 50,
        NoClip = false,
        GodMode = false
    },
    Raids = {
        AutoRaid = false,
        AutoChip = false,
        AutoAwaken = false
    },
    Misc = {
        AutoStats = false,
        ChestFarm = false,
        HopServer = false
    }
}

local Window = OrionLib:MakeWindow({
    Name = "Wirtz Scripts Premium",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "WirtzConfig"
})

-- Main Farm Functions
local function GetMob()
    local nearestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == Settings.Main.SelectedMob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

local function Attack()
    if Settings.Main.FastAttack then
        local args = {
            [1] = "Combat",
            [2] = "MouseButton1"
        }
        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
    end
end

local function EnableBuso()
    if not Player.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

local function AutoFarm()
    spawn(function()
        while Settings.Main.AutoFarm do
            pcall(function()
                local mob = GetMob()
                if mob then
                    if Settings.Main.AutoHaki then EnableBuso() end
                    
                    local targetPos = mob.HumanoidRootPart.Position
                    local tweenInfo = TweenInfo.new(
                        (Player.Character.HumanoidRootPart.Position - targetPos).magnitude/300,
                        Enum.EasingStyle.Linear
                    )
                    
                    local tween = TweenService:Create(
                        Player.Character.HumanoidRootPart,
                        tweenInfo,
                        {CFrame = CFrame.new(targetPos) * CFrame.new(0,Settings.Main.Distance,0)}
                    )
                    tween:Play()
                    
                    repeat
                        Attack()
                        wait()
                    until not Settings.Main.AutoFarm or not mob or mob.Humanoid.Health <= 0
                end
            end)
            wait()
        end
    end)
end

-- Tabs
local MainTab = Window:MakeTab({Name = "Principal", Icon = "rbxassetid://4483345998"})
local FruitTab = Window:MakeTab({Name = "Frutas", Icon = "rbxassetid://4483345998"})
local CombatTab = Window:MakeTab({Name = "Combate", Icon = "rbxassetid://4483345998"})
local RaidTab = Window:MakeTab({Name = "Raids", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

-- Main Tab
MainTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        Settings.Main.AutoFarm = Value
        if Value then AutoFarm() end
    end
})

MainTab:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(Value)
        Settings.Main.FastAttack = Value
    end
})

MainTab:AddToggle({
    Name = "Auto Haki",
    Default = false,
    Callback = function(Value)
        Settings.Main.AutoHaki = Value
    end
})

MainTab:AddDropdown({
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
        "Snow Bandit [Lv. 90]"
    },
    Callback = function(Value)
        Settings.Main.SelectedMob = Value
    end
})

-- Player Tab
PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255,0,0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        Settings.Player.Speed = Value
        Player.Character.Humanoid.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255,0,0),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        Settings.Player.Jump = Value
        Player.Character.Humanoid.JumpPower = Value
    end    
})

PlayerTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value)
        Settings.Player.NoClip = Value
        if Value then
            RunService.Stepped:Connect(function()
                if Settings.Player.NoClip then
                    pcall(function()
                        Player.Character.Humanoid:ChangeState(11)
                    end)
                end
            end)
        end
    end
})

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Initialize
OrionLib:Init()

OrionLib:MakeNotification({
    Name = "Wirtz Scripts",
    Content = "Script injetado com sucesso!",
    Image = "rbxassetid://4483345998",
    Time = 5
})