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

-- Quest Section
local QuestSection = Quest:NewSection("Special Quests")
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

-- Shop Section
local ShopSection = Shop:NewSection("Auto Buy")
ShopSection:NewToggle("Auto Buy Combat", "", function(state)
    getgenv().AutoBuyCombat = state
end)

-- Misc Section
local MiscSection = Misc:NewSection("Extra Features")
MiscSection:NewButton("Server Hop", "", function()
    HopServer()
end)

MiscSection:NewToggle("Anti AFK", "", function(state)
    getgenv().AntiAFK = state
end)

MiscSection:NewSlider("Tween Speed", "", 500, 50, function(value)
    getgenv().TweenSpeed = value
end)
```

2. `funcoes.lua` (todas as funções que executam as ações):
```lua
-- Variáveis Globais
getgenv().AutoFarm = false
getgenv().TweenSpeed = 250

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Quest Data
local QuestData = {
    ["1-9"] = {
        Monster = "Bandit [Lv. 5]",
        Quest = "BanditQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905),
        CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516)
    },
    -- Adicione mais quests aqui
}

-- Island Data
local IslandCFrames = {
    ["Starter Island"] = CFrame.new(1071.2832, 16.3085976, 1426.86792),
    ["Marine Island"] = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156),
    -- Adicione mais ilhas aqui
}

-- Função Tween
function Tween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local distance = (targetCFrame.Position - humanoidRootPart.Position).Magnitude
    
    local tweenInfo = TweenInfo.new(
        distance/getgenv().TweenSpeed,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return tween
end

-- Auto Farm Function
spawn(function()
    while true do
        if getgenv().AutoFarm then
            pcall(function()
                -- Código do Auto Farm aqui
            end)
        end
        wait()
    end
end)

-- Auto Stats Functions
for _, stat in ipairs({"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}) do
    spawn(function()
        while true do
            if getgenv()["Auto" .. stat] then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
            end
            wait(0.1)
        end
    end)
end

-- Teleport Function
function TeleportToIsland()
    if IslandCFrames[getgenv().SelectedIsland] then
        Tween(IslandCFrames[getgenv().SelectedIsland])
    end
end

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Server Hop Function
function HopServer()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false

    local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
    end)
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
    end
    
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end

    function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end

    Teleport()
end