-- Configurações Iniciais
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RS = game:GetService("ReplicatedStorage")

-- Interface Flutuante
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatingButton.Image = "rbxassetid://7072718412" -- Ícone bonito
FloatingButton.BackgroundTransparency = 0.3
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingButton.Parent = game.CoreGui

-- Tornar o botão arrastável
local Dragging = false
local DragStart = nil
local StartPos = nil

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = FloatingButton.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and Dragging then
        local Delta = input.Position - DragStart
        FloatingButton.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- Interface Principal
local Window = Fluent:CreateWindow({
    Title = "TheusHub | Muscle Legends",
    SubTitle = "Mobile Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- Funções Úteis
local function CreateTween(Object, Info, Properties)
    local Tween = TweenService:Create(Object, TweenInfo.new(unpack(Info)), Properties)
    return Tween
end

local function Notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

-- Sistema de Cache para Otimização
local Cache = {
    Strength = 0,
    LastSell = 0,
    AutoFarmEnabled = false
}

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "home" }),
    Training = Window:AddTab({ Title = "Treinos", Icon = "dumbbell" }),
    Pets = Window:AddTab({ Title = "Pets", Icon = "pet" }),
    Teleport = Window:AddTab({ Title = "Teleporte", Icon = "map" }),
    Skills = Window:AddTab({ Title = "Habilidades", Icon = "zap" }),
    Misc = Window:AddTab({ Title = "Extra", Icon = "settings" })
}

-- Principal Tab
local MainSection = Tabs.Main:AddSection("Auto Farm")

-- Auto Strength Avançado
MainSection:AddToggle("AutoStrength", {
    Title = "Auto Strength",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStrength = Value
        Cache.AutoFarmEnabled = Value
        
        while getgenv().AutoStrength and task.wait() do
            pcall(function()
                -- Multi-training system
                local args = {
                    [1] = "Training",
                    [2] = "Strength"
                }
                RS.RemoteEvent:FireServer(unpack(args))
                
                -- Bonus training
                if Cache.Strength >= 1000 then
                    RS.RemoteEvent:FireServer("SuperTraining")
                end
            end)
        end
    end
})

-- Auto Sell Inteligente
MainSection:AddToggle("AutoSell", {
    Title = "Auto Sell (Smart)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSell = Value
        
        while getgenv().AutoSell and task.wait(0.5) do
            pcall(function()
                local currentTime = tick()
                if currentTime - Cache.LastSell >= 3 then
                    RS.RemoteEvent:FireServer("SellStrength")
                    Cache.LastSell = currentTime
                end
            end)
        end
    end
})

-- Sistema de Combo
MainSection:AddToggle("ComboTraining", {
    Title = "Combo Training",
    Default = false,
    Callback = function(Value)
        getgenv().ComboTraining = Value
        
        while getgenv().ComboTraining and task.wait(0.1) do
            pcall(function()
                local trainTypes = {"Strength", "Endurance", "Durability"}
                for _, trainType in ipairs(trainTypes) do
                    RS.RemoteEvent:FireServer("Training", trainType)
                end
            end)
        end
    end
})

-- Training Tab
local TrainingSection = Tabs.Training:AddSection("Treinos Avançados")

-- Auto Training Completo
TrainingSection:AddToggle("SuperTraining", {
    Title = "Super Training",
    Default = false,
    Callback = function(Value)
        getgenv().SuperTraining = Value
        while getgenv().SuperTraining and task.wait() do
            pcall(function()
                local trainingTypes = {
                    "Strength",
                    "Endurance",
                    "Durability",
                    "PushUps",
                    "SitUps",
                    "Squats"
                }
                
                for _, training in ipairs(trainingTypes) do
                    RS.RemoteEvent:FireServer("Train", training)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Auto Rebirth Inteligente
TrainingSection:AddToggle("SmartRebirth", {
    Title = "Smart Rebirth",
    Default = false,
    Callback = function(Value)
        getgenv().SmartRebirth = Value
        while getgenv().SmartRebirth and task.wait(1) do
            pcall(function()
                local stats = Player.Stats
                if stats.Strength.Value >= stats.RebirthReq.Value then
                    RS.RemoteEvent:FireServer("Rebirth")
                end
            end)
        end
    end
})

-- Pets Tab
local PetsSection = Tabs.Pets:AddSection("Sistema de Pets")

-- Auto Hatch Avançado
local selectedEgg = "Basic"
local autoHatchAmount = 1

PetsSection:AddDropdown("EggSelect", {
    Title = "Selecionar Ovo",
    Values = {"Basic", "Mythical", "Legendary", "Ultimate", "Godly"},
    Default = "Basic",
    Callback = function(Value)
        selectedEgg = Value
    end
})

PetsSection:AddToggle("AutoHatch", {
    Title = "Auto Hatch",
    Default = false,
    Callback = function(Value)
        getgenv().AutoHatch = Value
        while getgenv().AutoHatch and task.wait(0.5) do
            pcall(function()
                RS.RemoteEvent:FireServer("OpenEgg", selectedEgg, autoHatchAmount)
            end)
        end
    end
})

-- Auto Equip Best Pets
PetsSection:AddButton({
    Title = "Equipar Melhores Pets",
    Callback = function()
        RS.RemoteEvent:FireServer("EquipBest")
        Notify("Pets", "Melhores pets equipados!", 3)
    end
})

-- Skills Tab
local SkillsSection = Tabs.Skills:AddSection("Habilidades")

-- Auto Skills
local skillsList = {"Speed", "Jump", "Strength", "Defense"}

for _, skill in ipairs(skillsList) do
    SkillsSection:AddToggle("Auto"..skill, {
        Title = "Auto " .. skill,
        Default = false,
        Callback = function(Value)
            getgenv()["Auto"..skill] = Value
            while getgenv()["Auto"..skill] and task.wait(0.5) do
                pcall(function()
                    RS.RemoteEvent:FireServer("UseSkill", skill)
                end)
            end
        end
    })
end

-- Teleport Tab
local TeleportSection = Tabs.Teleport:AddSection("Teleportes")

-- Lista de locais com coordenadas
local locations = {
    ["Spawn"] = Vector3.new(5, 3, 5),
    ["Muscle Beach"] = Vector3.new(-4000, 3, 0),
    ["Legends Gym"] = Vector3.new(2000, 3, 0),
    ["Mythical Grounds"] = Vector3.new(-6000, 3, 0),
    ["Secret Area"] = Vector3.new(8000, 3, 0)
}

-- Função de Teleporte com Animação
local function AnimatedTeleport(cf)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = Player.Character.HumanoidRootPart
        local currentPos = humanoidRootPart.Position
        local targetPos = cf
        
        local tween = TweenService:Create(humanoidRootPart, 
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = CFrame.new(targetPos)}
        )
        tween:Play()
    end
end

-- Botões de Teleporte
for locationName, position in pairs(locations) do
    TeleportSection:AddButton({
        Title = locationName,
        Callback = function()
            AnimatedTeleport(position)
        end
    })
end

-- Misc Tab
local MiscSection = Tabs.Misc:AddSection("Extras")

-- Auto Collect
MiscSection:AddToggle("AutoCollect", {
    Title = "Auto Collect",
    Default = false,
    Callback = function(Value)
        getgenv().AutoCollect = Value
        while getgenv().AutoCollect and task.wait(0.5) do
            pcall(function()
                for _, v in pairs(workspace.Collectibles:GetChildren()) do
                    if v:IsA("Part") then
                        v.CFrame = Player.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})

-- WalkSpeed & JumpPower
MiscSection:AddSlider("WalkSpeed", {
    Title = "Velocidade",
    Default = 16,
    Min = 16,
    Max = 500,
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

MiscSection:AddSlider("JumpPower", {
    Title = "Força do Pulo",
    Default = 50,
    Min = 50,
    Max = 500,
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Sistema de Segurança
local function SetupSecurity()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and args[2] == "ban" then
            return
        end
        return old(...)
    end)
    setreadonly(mt, true)
end

-- Otimizações
setfpscap(60)
settings().Physics.PhysicsEnvironmentalThrottle = 1
settings().Rendering.QualityLevel = 1

-- Botão Flutuante Handler
FloatingButton.MouseButton1Click:Connect(function()
    Window:Toggle()
end)

-- Inicialização
pcall(SetupSecurity)
Notify("Script Carregado", "TheusHub ativado com sucesso!", 5)