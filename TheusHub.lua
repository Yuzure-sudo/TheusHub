--[[
    Theus Hub Premium - Blox Fruits Script
    Version: 2.3.1
    Compatibility: Fluxus, Hydrogen, Synapse
    Features: Auto Farm, Instant Kill, God Mode
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local function GetClosestNPC()
    local closest, distance = nil, math.huge
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local npcDistance = (Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if npcDistance < distance then
                closest = npc
                distance = npcDistance
            end
        end
    end
    return closest
end

local function InstantKill()
    local npc = GetClosestNPC()
    if npc then
        ReplicatedStorage.DamageEvent:FireServer(npc, math.huge)
        npc.Humanoid.Health = 0
    end
end

local function AutoFarm()
    while _G.AutoFarmEnabled and task.wait() do
        local npc = GetClosestNPC()
        if npc then
            Character:MoveTo(npc.HumanoidRootPart.Position)
            InstantKill()
        end
    end
end

local function GodMode()
    Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
end

local function CreateGUI()
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    local Window = Rayfield:CreateWindow({
        Name = "Theus Hub Premium",
        LoadingTitle = "Loading...",
        LoadingSubtitle = "by Theus",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "TheusHub",
            FileName = "Config"
        }
    })

    local MainTab = Window:CreateTab("Main")
    local CombatSection = MainTab:CreateSection("Combat")

    CombatSection:CreateToggle({
        Name = "Auto Farm",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarmEnabled = Value
            if Value then
                AutoFarm()
            end
        end
    })

    CombatSection:CreateToggle({
        Name = "Instant Kill",
        CurrentValue = false,
        Callback = function(Value)
            _G.InstantKillEnabled = Value
            if Value then
                RunService.Heartbeat:Connect(InstantKill)
            end
        end
    })

    CombatSection:CreateToggle({
        Name = "God Mode",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                GodMode()
            end
        end
    })

    local PlayerTab = Window:CreateTab("Player")
    local MovementSection = PlayerTab:CreateSection("Movement")

    MovementSection:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 500},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 16,
        Callback = function(Value)
            Humanoid.WalkSpeed = Value
        end
    })

    MovementSection:CreateSlider({
        Name = "Jump Power",
        Range = {50, 500},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 50,
        Callback = function(Value)
            Humanoid.JumpPower = Value
        end
    })

    Rayfield:Notify({
        Title = "Theus Hub Loaded",
        Content = "Successfully injected!",
        Duration = 5,
        Image = 4483362458
    })
end

CreateGUI()

-- Anti-detection measures
local function Cleanup()
    getgenv().TheusHub = nil
    script:Destroy()
end

game:BindToClose(Cleanup)

if not hookmetamethod then
    game:Shutdown()
    return
end

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if tostring(self) == "DamageEvent" and method == "FireServer" then
        return originalNamecall(self, ...)
    end
    return originalNamecall(self, ...)
end)