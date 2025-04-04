local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Hub Premium", "BloodTheme")

-- Main Tab
local Main = Window:NewTab("🎮 Main")
local MainSection = Main:NewSection("Auto Farm")

-- Auto Farm Toggle
MainSection:NewToggle("⚔️ Auto Farm Level", "Auto farms with quests", function(state)
    getgenv().AutoFarm = state
end)

-- Stats Tab
local Stats = Window:NewTab("📊 Stats")
local StatsSection = Stats:NewSection("Auto Stats")

local StatsList = {
    {name = "Melee", icon = "👊"},
    {name = "Defense", icon = "🛡️"},
    {name = "Sword", icon = "⚔️"},
    {name = "Gun", icon = "🔫"},
    {name = "Demon Fruit", icon = "🍎"}
}

for _, stat in ipairs(StatsList) do
    StatsSection:NewToggle(stat.icon .. " Auto " .. stat.name, "", function(state)
        getgenv()["Auto" .. stat.name] = state
    end)
end

-- Teleport Tab
local Teleport = Window:NewTab("🌍 Teleport")
local TeleportSection = Teleport:NewSection("Quick Travel")

local Islands = {
    ["🏝️ Starter Island"] = CFrame.new(1071.2832, 16.3085976, 1426.86792),
    ["⚓ Marine Island"] = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156),
    ["🌴 Jungle Island"] = CFrame.new(-1332.1394, 11.8529119, 492.35907),
    ["🏴‍☠️ Pirate Island"] = CFrame.new(-1139.59717, 4.75205183, 3825.16211)
}

TeleportSection:NewDropdown("Select Location", "", {"🏝️ Starter Island", "⚓ Marine Island", "🌴 Jungle Island", "🏴‍☠️ Pirate Island"}, function(currentOption)
    _G.SelectedIsland = currentOption
end)

-- Combat Tab
local Combat = Window:NewTab("⚔️ Combat")
local CombatSection = Combat:NewSection("Combat Options")

CombatSection:NewToggle("🔥 Auto Buso", "", function(state)
    getgenv().AutoBuso = state
end)

-- Visual Tab
local Visual = Window:NewTab("👁️ Visual")
local VisualSection = Visual:NewSection("Game Visual")

VisualSection:NewToggle("Remove Fog", "", function(state)
    getgenv().NoFog = state
end)

-- Settings Tab
local Settings = Window:NewTab("⚙️ Settings")
local SettingsSection = Settings:NewSection("UI Settings")

SettingsSection:NewKeybind("Toggle UI", "Hide/Show UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

return Window