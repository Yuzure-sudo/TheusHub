--[[ 
    TheusHub | Muscle Legends
    Desenvolvido por: Theus
    Versão: 2.0 Premium
    Data: 04/04/2025
]]

-- Serviços e Variáveis Iniciais
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cache de Eventos e Remotes
local Events = {
    Train = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Train"),
    Sell = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Sell"),
    Rebirth = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Rebirth"),
    Egg = ReplicatedStorage:WaitForChild("Events"):WaitForChild("OpenEgg"),
    Equip = ReplicatedStorage:WaitForChild("Events"):WaitForChild("EquipPet")
}

-- Sistema de Cache Otimizado
local Cache = {
    Strength = 0,
    LastSell = 0,
    LastRebirth = 0,
    PetInventory = {},
    ActiveBoosts = {},
    TrainingAreas = {},
    CurrentArea = nil
}

-- Interface Principal
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "TheusHub | Muscle Legends",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TheusHubML"
})

-- Funções Utilitárias
local Utils = {
    formatNumber = function(number)
        if number >= 1e18 then return string.format("%.1fQt", number/1e18)
        elseif number >= 1e15 then return string.format("%.1fQd", number/1e15)
        elseif number >= 1e12 then return string.format("%.1fT", number/1e12)
        elseif number >= 1e9 then return string.format("%.1fB", number/1e9)
        elseif number >= 1e6 then return string.format("%.1fM", number/1e6)
        elseif number >= 1e3 then return string.format("%.1fK", number/1e3)
        else return tostring(number) end
    end,
    
    createTween = function(object, info, properties)
        return TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    end,
    
    teleport = function(position)
        if typeof(position) == "CFrame" then
            HumanoidRootPart.CFrame = position
        else
            HumanoidRootPart.CFrame = CFrame.new(position)
        end
    end
}

-- Sistema de Training Avançado
local TrainingSystem = {
    strengthMultiplier = 1,
    activeBoosts = {},
    
    train = function(self, type)
        if not Cache.CurrentArea then
            local nearestArea = self:findNearestTrainingArea()
            if nearestArea then
                Cache.CurrentArea = nearestArea
            end
        end
        
        Events.Train:FireServer(type)
        Cache.Strength = Cache.Strength + (1 * self.strengthMultiplier)
    end,
    
    findNearestTrainingArea = function(self)
        local nearest = nil
        local nearestDist = math.huge
        
        for _, area in pairs(workspace.TrainingAreas:GetChildren()) do
            local dist = (area.Position - HumanoidRootPart.Position).magnitude
            if dist < nearestDist then
                nearest = area
                nearestDist = dist
            end
        end
        
        return nearest
    end,
    
    activateBoost = function(self, boostType)
        if not self.activeBoosts[boostType] then
            self.activeBoosts[boostType] = true
            self.strengthMultiplier = self.strengthMultiplier * 2
            
            task.delay(300, function()
                self.activeBoosts[boostType] = false
                self.strengthMultiplier = self.strengthMultiplier / 2
            end)
        end
    end
}

-- Sistema de Pets Avançado
local PetSystem = {
    equippedPets = {},
    
    openEgg = function(self, eggType, amount)
        Events.Egg:FireServer(eggType, amount or 1)
    end,
    
    equipBestPets = function(self)
        local inventory = Player.PetsInventory:GetChildren()
        table.sort(inventory, function(a, b)
            return a.Power.Value > b.Power.Value
        end)
        
        for i = 1, math.min(#inventory, 3) do
            Events.Equip:FireServer(inventory[i])
        end
    end,
    
    autoDelete = function(self, rarity)
        for _, pet in pairs(Player.PetsInventory:GetChildren()) do
            if pet.Rarity.Value <= rarity and not pet.Equipped.Value then
                Events.DeletePet:FireServer(pet)
            end
        end
    end
}

-- Tabs
local MainTab = Window:MakeTab({Name = "Principal", Icon = "rbxassetid://4483345998"})
local PetsTab = Window:MakeTab({Name = "Pets", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "Teleporte", Icon = "rbxassetid://4483345998"})
local BoostsTab = Window:MakeTab({Name = "Boosts", Icon = "rbxassetid://4483345998"})

-- Principal Tab
MainTab:AddToggle({
    Name = "Auto Strength",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStrength = Value
        while getgenv().AutoStrength and task.wait() do
            TrainingSystem:train("Strength")
        end
    end
})

MainTab:AddToggle({
    Name = "Auto Sell",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSell = Value
        while getgenv().AutoSell and task.wait(1) do
            if tick() - Cache.LastSell >= 3 then
                Events.Sell:FireServer()
                Cache.LastSell = tick()
            end
        end
    end
})

-- Sistema de Auto Farm Inteligente
local AutoFarmSystem = {
    locations = {
        ["Muscle Beach"] = CFrame.new(-4000, 3, 0),
        ["Legends Gym"] = CFrame.new(2000, 3, 0),
        ["Mythical Grounds"] = CFrame.new(-6000, 3, 0),
        ["Secret Area"] = CFrame.new(8000, 3, 0),
        ["God's Gym"] = CFrame.new(12000, 3, 0)
    },
    
    trainings = {
        ["Strength"] = true,
        ["Endurance"] = true,
        ["Durability"] = true,
        ["PushUps"] = true,
        ["SitUps"] = true
    },
    
    bestLocation = function(self)
        local strength = Player.Stats.Strength.Value
        if strength < 1000 then
            return self.locations["Muscle Beach"]
        elseif strength < 10000 then
            return self.locations["Legends Gym"]
        elseif strength < 100000 then
            return self.locations["Mythical Grounds"]
        elseif strength < 1000000 then
            return self.locations["Secret Area"]
        else
            return self.locations["God's Gym"]
        end
    end,
    
    startTraining = function(self)
        local currentLocation = self:bestLocation()
        Utils.teleport(currentLocation)
        
        for type, _ in pairs(self.trainings) do
            TrainingSystem:train(type)
            task.wait(0.1)
        end
    end
}

-- Sistema Avançado de Rebirth
local RebirthSystem = {
    requirements = {
        [1] = 1000,
        [2] = 10000,
        [3] = 100000,
        [4] = 1000000,
        [5] = 10000000
    },
    
    canRebirth = function(self)
        local strength = Player.Stats.Strength.Value
        local currentRebirth = Player.Stats.Rebirth.Value
        return strength >= self.requirements[currentRebirth + 1]
    end,
    
    performRebirth = function(self)
        if self:canRebirth() then
            Events.Rebirth:FireServer()
            return true
        end
        return false
    end
}

-- Sistema de Boost Avançado
local BoostSystem = {
    activeBoosts = {},
    
    boostTypes = {
        ["Strength"] = 2,
        ["Speed"] = 2,
        ["Jump"] = 2,
        ["Gains"] = 2
    },
    
    activateBoost = function(self, boostType)
        if not self.activeBoosts[boostType] then
            Events.ActivateBoost:FireServer(boostType)
            self.activeBoosts[boostType] = true
            
            task.delay(300, function()
                self.activeBoosts[boostType] = false
            end)
        end
    end,
    
    useAllBoosts = function(self)
        for boostType, _ in pairs(self.boostTypes) do
            self:activateBoost(boostType)
            task.wait(0.5)
        end
    end
}

-- Sistema de Eventos Especiais
local EventSystem = {
    active = false,
    currentEvent = nil,
    
    events = {
        ["Boss Fight"] = true,
        ["Lucky Wheel"] = true,
        ["Tournament"] = true
    },
    
    startEventMonitoring = function(self)
        self.active = true
        
        task.spawn(function()
            while self.active and task.wait(1) do
                for eventName, _ in pairs(self.events) do
                    if workspace.Events:FindFirstChild(eventName) then
                        self.currentEvent = eventName
                        self:participateInEvent(eventName)
                    end
                end
            end
        end)
    end,
    
    participateInEvent = function(self, eventName)
        if eventName == "Boss Fight" then
            -- Lógica de luta contra o chefe
            Events.JoinBossFight:FireServer()
        elseif eventName == "Lucky Wheel" then
            -- Lógica da roda da sorte
            Events.SpinWheel:FireServer()
        elseif eventName == "Tournament" then
            -- Lógica do torneio
            Events.JoinTournament:FireServer()
        end
    end
}

-- Adicionando mais funcionalidades aos Tabs
MainTab:AddToggle({
    Name = "Smart Auto Farm",
    Default = false,
    Callback = function(Value)
        getgenv().SmartAutoFarm = Value
        while getgenv().SmartAutoFarm and task.wait() do
            AutoFarmSystem:startTraining()
        end
    end
})

MainTab:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        getgenv().AutoRebirth = Value
        while getgenv().AutoRebirth and task.wait(1) do
            RebirthSystem:performRebirth()
        end
    end
})

-- Pets Tab Avançado
PetsTab:AddDropdown({
    Name = "Selecionar Ovo",
    Default = "Basic",
    Options = {"Basic", "Rare", "Epic", "Legendary", "Mythical", "Divine"},
    Callback = function(Value)
        getgenv().SelectedEgg = Value
    end
})

PetsTab:AddToggle({
    Name = "Auto Hatch",
    Default = false,
    Callback = function(Value)
        getgenv().AutoHatch = Value
        while getgenv().AutoHatch and task.wait(1) do
            PetSystem:openEgg(getgenv().SelectedEgg, 3)
        end
    end
})

PetsTab:AddButton({
    Name = "Equipar Melhores Pets",
    Callback = function()
        PetSystem:equipBestPets()
    end
})

-- Boosts Tab
BoostsTab:AddButton({
    Name = "Ativar Todos os Boosts",
    Callback = function()
        BoostSystem:useAllBoosts()
    end
})

for boostType, _ in pairs(BoostSystem.boostTypes) do
    BoostsTab:AddToggle({
        Name = "Auto " .. boostType .. " Boost",
        Default = false,
        Callback = function(Value)
            getgenv()["Auto"..boostType.."Boost"] = Value
            while getgenv()["Auto"..boostType.."Boost"] and task.wait(300) do
                BoostSystem:activateBoost(boostType)
            end
        end
    })
end

-- Sistema Anti-Detecção
local AntiDetection = {
    setupAntiCheat = function(self)
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if method == "FireServer" and args[1] == "Ban" then
                return
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end
}

-- Inicialização
AntiDetection:setupAntiCheat()
EventSystem:startEventMonitoring()

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Otimizações Finais
settings().Physics.PhysicsEnvironmentalThrottle = 1
settings().Rendering.QualityLevel = 1
UserSettings():GetService("UserGameSettings").MasterVolume = 0

-- Notificação de Inicialização
OrionLib:MakeNotification({
    Name = "TheusHub",
    Content = "Script carregado com sucesso!",
    Image = "rbxassetid://4483345998",
    Time = 5
})