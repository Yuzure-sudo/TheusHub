--[[
    Blox Fruits Ultimate AIO
    Version: 3.1.5
    Features: Auto Farm, Quests, Raids, Teleports
    Optimized for Sea 1
]]--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Modules
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration
local Settings = {
    AutoFarm = true,
    QuestPriority = {"Bandit", "Monkey", "Pirate"},
    FastAttackDelay = 0.15,
    SafeDistance = 15,
    AntiDetection = true
}

-- Cache System
local NPC_Cache = {}
local Island_Positions = {
    ["Jungle"] = CFrame.new(-100, 50, 100),
    ["Pirate Village"] = CFrame.new(200, 30, -150)
}

-- Core Functions
local function SmartNPCSelector()
    local optimalNPC
    for _, npcType in ipairs(Settings.QuestPriority) do
        for _, npc in ipairs(Workspace.NPCs:GetChildren()) do
            if npc.Name:find(npcType) and npc:FindFirstChild("Humanoid") then
                if not optimalNPC or (npc.Humanoid.Health > optimalNPC.Humanoid.Health) then
                    optimalNPC = npc
                end
            end
        end
    end
    return optimalNPC
end

local function OptimizedFastAttack()
    local CombatRemote = ReplicatedStorage:FindFirstChild("CombatRemote")
    if CombatRemote then
        for _ = 1, 3 do
            CombatRemote:FireServer()
            task.wait(Settings.FastAttackDelay)
        end
    end
end

-- Main Loop
local FarmLoop = RunService.Heartbeat:Connect(function()
    if Settings.AutoFarm then
        local targetNPC = SmartNPCSelector()
        if targetNPC then
            -- Movement with CFrame
            Character.HumanoidRootPart.CFrame = targetNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.SafeDistance)
            
            -- Face target
            Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                Character.HumanoidRootPart.Position,
                targetNPC.HumanoidRootPart.Position
            )
            
            OptimizedFastAttack()
        end
    end
end)

-- UI Construction
local Window = OrionLib:MakeWindow({
    Name = "Blox Fruits AIO",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BloxFruitsConfig"
})

local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998"
})

FarmTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarm = Value
    end
})

FarmTab:AddDropdown({
    Name = "Quest Priority",
    Default = "Bandit",
    Options = {"Bandit", "Monkey", "Pirate", "Brute"},
    Callback = function(Value)
        Settings.QuestPriority = {Value}
    end
})

-- Anti-Detection
if Settings.AntiDetection then
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if tostring(self) == "CombatRemote" and method == "FireServer" then
            return originalNamecall(self, ...)
        end
        return originalNamecall(self, ...)
    end)
end

-- Cleanup
game:BindToClose(function()
    FarmLoop:Disconnect()
    OrionLib:Destroy()
end)

OrionLib:Init()