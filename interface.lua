local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Hub", "DarkTheme")

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
local FarmTab = Window:NewTab("Farm")
local CombatTab = Window:NewTab("Combat")
local QuestTab = Window:NewTab("Quest")
local FruitTab = Window:NewTab("Fruit")
local TeleportTab = Window:NewTab("Teleport")
local MiscTab = Window:NewTab("Misc")

-- Main Section
local MainSection = MainTab:NewSection("Overview")
MainSection:NewLabel("Welcome to Theus Hub!")
MainSection:NewLabel("This hub provides various features to enhance your gameplay.")

-- Farm Section
local FarmSection = FarmTab:NewSection("Auto Farm")
FarmSection:NewToggle("Auto Farm Level", "Automatically farms with quests", function(state)
    getgenv().AutoFarm = state
end)

FarmSection:NewToggle("Auto Farm Nearest", "Automatically farms nearest mob", function(state)
    getgenv().AutoFarmNearest = state
end)

FarmSection:NewSlider("Tween Speed", "Adjust the tween speed", 500, 50, function(value)
    getgenv().TweenSpeed = value
end)

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

-- Misc Section
local MiscSection = MiscTab:NewSection("Extra Features")
MiscSection:NewButton("Server Hop", "", function()
    HopServer()
end)

MiscSection:NewToggle("Anti AFK", "", function(state)
    getgenv().AntiAFK = state
end)

MiscSection:NewButton("Rejoin Server", "", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)