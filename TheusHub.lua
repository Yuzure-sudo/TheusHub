local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Blox Fruits Script", "DarkTheme")

-- Auto Farm
local farmTab = window:NewTab("Auto Farm")
local farmSection = farmTab:NewSection("Auto Farm")

farmSection:NewToggle("Auto Farm Level", "Automatically farms nearby enemies", function(state)
    getgenv().autoFarm = state
    while autoFarm do
        task.wait()
        pcall(function()
            for _, v in pairs(WS.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ClickButton", "Z")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ClickButton", "X")
                end
            end
        end)
    end
end)

-- Auto Raid
local raidTab = window:NewTab("Auto Raid")
local raidSection = raidTab:NewSection("Auto Raid")

raidSection:NewToggle("Auto Raid", "Automatically starts and completes raids", function(state)
    getgenv().autoRaid = state
    while autoRaid do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Flame")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UnlockStats")
        end)
    end
end)

-- Teleports
local teleportTab = window:NewTab("Teleports")
local teleportSection = teleportTab:NewSection("Teleports")

local islands = {
    "Jungle",
    "Pirate Village",
    "Desert",
    "Snow Island",
    "MarineFord",
    "Colosseum",
    "Sky Island 1",
    "Sky Island 2",
    "Sky Island 3"
}

for _, island in pairs(islands) do
    teleportSection:NewButton(island, "Teleport to " .. island, function()
        local cf = WS[island].CFrame
        character.HumanoidRootPart.CFrame = cf
    end)
end

-- Auto Buy Fruits
local fruitTab = window:NewTab("Auto Fruits")
local fruitSection = fruitTab:NewSection("Auto Buy Fruits")

fruitSection:NewToggle("Auto Buy Random Fruit", "Automatically buys random fruits", function(state)
    getgenv().autoBuyFruit = state
    while autoBuyFruit do
        task.wait(1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
        end)
    end
end)

-- Auto Collect Items
local collectTab = window:NewTab("Auto Collect")
local collectSection = collectTab:NewSection("Auto Collect Items")

collectSection:NewToggle("Auto Collect Chests", "Automatically collects chests", function(state)
    getgenv().autoCollect = state
    while autoCollect do
        task.wait()
        pcall(function()
            for _, v in pairs(WS:GetChildren()) do
                if v.Name:find("Chest") then
                    character.HumanoidRootPart.CFrame = v.CFrame
                    fireproximityprompt(v.ProximityPrompt)
                end
            end
        end)
    end
end)

-- Auto Stats
local statsTab = window:NewTab("Auto Stats")
local statsSection = statsTab:NewSection("Auto Stats")

statsSection:NewToggle("Auto Melee", "Automatically upgrades melee stats", function(state)
    getgenv().autoMelee = state
    while autoMelee do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
        end)
    end
end)

statsSection:NewToggle("Auto Defense", "Automatically upgrades defense stats", function(state)
    getgenv().autoDefense = state
    while autoDefense do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
        end)
    end
end)

-- Auto Boss
local bossTab = window:NewTab("Auto Boss")
local bossSection = bossTab:NewSection("Auto Boss")

bossSection:NewToggle("Auto Kill Boss", "Automatically kills bosses", function(state)
    getgenv().autoBoss = state
    while autoBoss do
        task.wait()
        pcall(function()
            for _, v in pairs(WS.Enemies:GetChildren()) do
                if v.Name:find("Boss") and v:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ClickButton", "Z")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ClickButton", "X")
                end
            end
        end)
    end
end)

-- Auto Dungeon
local dungeonTab = window:NewTab("Auto Dungeon")
local dungeonSection = dungeonTab:NewSection("Auto Dungeon")

dungeonSection:NewToggle("Auto Dungeon", "Automatically completes dungeons", function(state)
    getgenv().autoDungeon = state
    while autoDungeon do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RequestEntrance", Vector3.new(-12463.874, 374.914, -7553.148))
        end)
    end
end)

-- Auto Bounty
local bountyTab = window:NewTab("Auto Bounty")
local bountySection = bountyTab:NewSection("Auto Bounty")

bountySection:NewToggle("Auto Bounty", "Automatically collects bounty", function(state)
    getgenv().autoBounty = state
    while autoBounty do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bounty")
        end)
    end
end)

-- Auto Buy Haki
local hakiTab = window:NewTab("Auto Haki")
local hakiSection = hakiTab:NewSection("Auto Buy Haki")

hakiSection:NewToggle("Auto Buy Haki", "Automatically buys Haki", function(state)
    getgenv().autoHaki = state
    while autoHaki do
        task.wait()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki")
        end)
    end
end)

-- Anti-Kick
local miscTab = window:NewTab("Misc")
local miscSection = miscTab:NewSection("Misc")

miscSection:NewToggle("Anti-Kick", "Prevents being kicked", function(state)
    getgenv().antiKick = state
    if antiKick then
        player.OnTeleport:Connect(function()
            queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/your-repo/main.lua'))()")
        end)
    end
end)