local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Criação da UI centralizada
local Window = Library.CreateLib("Theus Hub Premium", "BloodTheme")

-- Tabs Principais
local Main = Window:NewTab("🎮 Main")
local Stats = Window:NewTab("📊 Stats")
local Combat = Window:NewTab("⚔️ Combat")
local Sword = Window:NewTab("🗡️ Sword")
local Quest = Window:NewTab("📜 Quest")
local Fruit = Window:NewTab("🍎 Fruit")
local Teleport = Window:NewTab("🌍 Teleport")
local Raid = Window:NewTab("⚔️ Raid")
local Shop = Window:NewTab("🛍️ Shop")
local Misc = Window:NewTab("⚙️ Misc")

-- Main Section
local MainSection = Main:NewSection("Auto Farm")
MainSection:NewToggle("Auto Farm Level", "Auto farms with quests", function(state)
    getgenv().AutoFarm = state
end)

MainSection:NewToggle("Auto Farm Nearest", "Farms nearest mob", function(state)
    getgenv().AutoFarmNearest = state
end)

-- Stats Section
local StatsSection = Stats:NewSection("Auto Stats")
local StatsList = {
    {name = "Melee", icon = "👊"},
    {name = "Defense", icon = "🛡️"},
    {name = "Sword", icon = "⚔️"},
    {name = "Gun", icon = "🔫"},
    {name = "Devil Fruit", icon = "🍎"}
}

for _, stat in ipairs(StatsList) do
    StatsSection:NewToggle(stat.icon .. " Auto " .. stat.name, "", function(state)
        getgenv()["Auto" .. stat.name] = state
    end)
end

-- Combat Section
local CombatSection = Combat:NewSection("Fighting Styles")
CombatSection:NewToggle("Auto Black Leg", "", function(state)
    getgenv().AutoBlackLeg = state
end)

CombatSection:NewToggle("Auto Death Step", "", function(state)
    getgenv().AutoDeathStep = state
end)

CombatSection:NewToggle("Auto Electric Claw", "", function(state)
    getgenv().AutoElectricClaw = state
end)

CombatSection:NewToggle("Auto Dragon Claw", "", function(state)
    getgenv().AutoDragonClaw = state
end)

CombatSection:NewToggle("Auto Superhuman", "", function(state)
    getgenv().AutoSuperhuman = state
end)

-- Sword Section
local SwordSection = Sword:NewSection("Sword Quests")
SwordSection:NewToggle("Auto Saber", "", function(state)
    getgenv().AutoSaber = state
end)

SwordSection:NewToggle("Auto Rengoku", "", function(state)
    getgenv().AutoRengoku = state
end)

SwordSection:NewToggle("Auto Pole", "", function(state)
    getgenv().AutoPole = state
end)

SwordSection:NewToggle("Auto Triple Katana", "", function(state)
    getgenv().AutoTripleKatana = state
end)

-- Quest Section
local QuestSection = Quest:NewSection("Special Quests")
QuestSection:NewToggle("Auto Shanks Quest", "", function(state)
    getgenv().AutoShanks = state
end)

QuestSection:NewToggle("Auto Ken Haki Quest", "", function(state)
    getgenv().AutoKenQuest = state
end)

QuestSection:NewToggle("Auto Bartilo Quest", "", function(state)
    getgenv().AutoBartilo = state
end)

-- Fruit Section
local FruitSection = Fruit:NewSection("Devil Fruits")
FruitSection:NewToggle("Auto Random Fruit", "", function(state)
    getgenv().AutoRandomFruit = state
end)

FruitSection:NewToggle("Auto Store Fruit", "", function(state)
    getgenv().AutoStoreFruit = state
end)

FruitSection:NewToggle("Auto Buy Devil Fruit", "", function(state)
    getgenv().AutoBuyFruit = state
end)

-- Teleport Section
local TeleportSection = Teleport:NewSection("Islands")
local Islands = {
    "Starter Island",
    "Marine Island",
    "Jungle Island",
    "Pirate Island",
    "Desert Island",
    "Snow Island",
    "MarineFord",
    "Colosseum",
    "Sky Island 1",
    "Sky Island 2",
    "Prison",
    "Magma Island",
    "Under Water Island",
    "Fountain City"
}

TeleportSection:NewDropdown("Select Island", "", Islands, function(currentOption)
    getgenv().SelectedIsland = currentOption
end)

TeleportSection:NewButton("Teleport", "", function()
    TeleportToIsland()
end)

-- Raid Section
local RaidSection = Raid:NewSection("Dungeon")
RaidSection:NewToggle("Auto Raid", "", function(state)
    getgenv().AutoRaid = state
end)

RaidSection:NewToggle("Auto Buy Chip", "", function(state)
    getgenv().AutoBuyChip = state
end)

RaidSection:NewDropdown("Select Raid", "", {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}, function(currentOption)
    getgenv().SelectedRaid = currentOption
end)

-- Shop Section
local ShopSection = Shop:NewSection("Auto Buy")
ShopSection:NewToggle("Auto Buy Combat", "", function(state)
    getgenv().AutoBuyCombat = state
end)

ShopSection:NewToggle("Auto Buy Abilities", "", function(state)
    getgenv().AutoBuyAbilities = state
end)

ShopSection:NewToggle("Auto Buy Legendary Sword", "", function(state)
    getgenv().AutoBuyLegendary = state
end)

-- Misc Section
local MiscSection = Misc:NewSection("Extra Features")
MiscSection:NewButton("Server Hop", "", function()
    HopServer()
end)

MiscSection:NewToggle("Anti AFK", "", function(state)
    getgenv().AntiAFK = state
end)

MiscSection:NewToggle("Remove Fog", "", function(state)
    getgenv().NoFog = state
end)

MiscSection:NewKeybind("Toggle UI", "Hide/Show UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Settings Section
local SettingsSection = Misc:NewSection("Settings")
SettingsSection:NewSlider("Tween Speed", "", 500, 50, function(value)
    getgenv().TweenSpeed = value
end)

SettingsSection:NewColorPicker("UI Color", "", Color3.fromRGB(255,255,255), function(color)
    -- Atualizar cor da UI
end)