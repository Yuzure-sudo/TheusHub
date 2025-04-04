local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Hub Premium", "DarkTheme")

-- Função para centralizar a janela
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TheusHubWindow"

local function CenterWindow()
    local TweenService = game:GetService("TweenService")
    local WindowSize = Window.MainFrame.Size
    local ScreenSize = game:GetService("GuiService"):GetScreenResolution()
    
    Window.MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    
    local OriginalSize = Window.MainFrame.Size
    Window.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    
    wait(0.5)
    Window.MainFrame:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
end

CenterWindow()

-- Função para minimizar/abrir a janela
local Minimized = false
Window.MainFrame.Draggable = true
Window.MainFrame.Active = true

Window.MainFrame.CloseButton.MouseButton1Click:Connect(function()
    if Minimized then
        Window.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
        wait(0.5)
        Window.MainFrame.Visible = false
    else
        Window.MainFrame.Visible = true
        Window.MainFrame:TweenSize(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    end
    Minimized = not Minimized
end)

-- Tabs Principais
local MainTab = Window:NewTab("Main")
local StatsTab = Window:NewTab("Stats")
local CombatTab = Window:NewTab("Combat")
local SwordTab = Window:NewTab("Sword")
local QuestTab = Window:NewTab("Quest")
local FruitTab = Window:NewTab("Fruit")
local TeleportTab = Window:NewTab("Teleport")
local RaidTab = Window:NewTab("Raid")
local ShopTab = Window:NewTab("Shop")
local MiscTab = Window:NewTab("Misc")

-- Main Section
local MainSection = MainTab:NewSection("Auto Farm")
MainSection:NewToggle("Auto Farm Level", "Auto farms with quests", function(state)
    getgenv().AutoFarm = state
end)

MainSection:NewToggle("Auto Farm Nearest", "Farms nearest mob", function(state)
    getgenv().AutoFarmNearest = state
end)

-- Stats Section
local StatsSection = StatsTab:NewSection("Auto Stats")
local StatsList = {
    {name = "Melee", icon = "👊", toggle = "AutoMelee"},
    {name = "Defense", icon = "🛡️", toggle = "AutoDefense"},
    {name = "Sword", icon = "⚔️", toggle = "AutoSword"},
    {name = "Gun", icon = "🔫", toggle = "AutoGun"},
    {name = "Devil Fruit", icon = "🍎", toggle = "AutoDevilFruit"}
}

for _, stat in ipairs(StatsList) do
    StatsSection:NewToggle(stat.icon .. " Auto " .. stat.name, "", function(state)
        getgenv()[stat.toggle] = state
    end)
end

-- Combat Section
local CombatSection = CombatTab:NewSection("Fighting Styles")
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
local SwordSection = SwordTab:NewSection("Sword Quests")
SwordSection:NewToggle("Auto Saber", "", function(state)
    getgenv().AutoSaber = state
end)

SwordSection:NewToggle("Auto Rengoku", "", function(state)
    getgenv().AutoRengoku = state
end)

SwordSection:NewToggle("Auto Pole", "", function(state)
    getgenv().AutoPole = state
end)

-- Quest Section
local QuestSection = QuestTab:NewSection("Special Quests")
QuestSection:NewToggle("Auto Bartilo Quest", "", function(state)
    getgenv().AutoBartilo = state
end)

QuestSection:NewToggle("Auto Ectoplasm", "", function(state)
    getgenv().AutoEctoplasm = state
end)

QuestSection:NewToggle("Auto Buddy Sword", "", function(state)
    getgenv().AutoBudySword = state
end)

-- Fruit Section
local FruitSection = FruitTab:NewSection("Devil Fruits")
FruitSection:NewToggle("Auto Random Fruit", "", function(state)
    getgenv().AutoRandomFruit = state
end)

FruitSection:NewToggle("Auto Store Fruit", "", function(state)
    getgenv().AutoStoreFruit = state
end)

-- Teleport Section
local TeleportSection = TeleportTab:NewSection("Islands")
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
local RaidSection = RaidTab:NewSection("Dungeon")
RaidSection:NewToggle("Auto Raid", "", function(state)
    getgenv().AutoRaid = state
end)

-- Shop Section
local ShopSection = ShopTab:NewSection("Auto Buy")
ShopSection:NewToggle("Auto Buy Combat", "", function(state)
    getgenv().AutoBuyCombat = state
end)

-- Misc Section
local MiscSection = MiscTab:NewSection("Extra Features")
MiscSection:NewButton("Server Hop", "", function()
    HopServer()
end)

MiscSection:NewToggle("Anti AFK", "", function(state)
    getgenv().AntiAFK = state
end)

MiscSection:NewSlider("Tween Speed", "", 500, 50, function(value)
    getgenv().TweenSpeed = value
end)