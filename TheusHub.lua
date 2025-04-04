-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- Variáveis Locais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoQuest = false,
    NoClip = false,
    AutoHaki = false,
    TweenSpeed = 350
}

-- Interface Principal
local TheusHub = Instance.new("ScreenGui")
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui
TheusHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = TheusHub
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Active = true
Main.Draggable = true

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = Main
TabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabsContainer.BorderSizePixel = 0
TabsContainer.Position = UDim2.new(0, 0, 0, 30)
TabsContainer.Size = UDim2.new(0, 120, 1, -30)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = Main
ContentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 120, 0, 30)
ContentContainer.Size = UDim2.new(1, -120, 1, -30)

-- Função para criar Tabs
local function CreateTab(name)
    local Tab = Instance.new("TextButton")
    Tab.Name = name
    Tab.Parent = TabsContainer
    Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(1, 0, 0, 35)
    Tab.Font = Enum.Font.GothamSemibold
    Tab.Text = name
    Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.TextSize = 12
    
    local Content = Instance.new("ScrollingFrame")
    Content.Name = name.."Content"
    Content.Parent = ContentContainer
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.ScrollBarThickness = 4
    Content.Visible = false
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    return Tab, Content
end

-- Criação das Tabs
local FarmingTab, FarmingContent = CreateTab("Farming")
local TeleportTab, TeleportContent = CreateTab("Teleport")
local StatsTab, StatsContent = CreateTab("Stats")
local MiscTab, MiscContent = CreateTab("Misc")

-- Função para criar Toggle
local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = text.."Toggle"
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, -20, 0, 35)
    Toggle.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 40)

    local Label = Instance.new("TextLabel")
    Label.Parent = Toggle
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Button = Instance.new("TextButton")
    Button.Parent = Toggle
    Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(1, -40, 0.5, -10)
    Button.Size = UDim2.new(0, 30, 0, 20)
    Button.Font = Enum.Font.GothamBold
    Button.Text = ""
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)

    return Toggle, enabled
end

-- Função para criar Botão
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text.."Button"
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 40)
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12

    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Adicionando Toggles ao Farming
CreateToggle(FarmingContent, "Auto Farm", function(enabled)
    getgenv().Settings.AutoFarm = enabled
end)

CreateToggle(FarmingContent, "Fast Attack", function(enabled)
    getgenv().Settings.FastAttack = enabled
end)

CreateToggle(FarmingContent, "Auto Quest", function(enabled)
    getgenv().Settings.AutoQuest = enabled
end)

-- Adicionando Botões ao Teleport
local locations = {
    ["First Island"] = CFrame.new(1000, 10, 1000),
    ["Marine Base"] = CFrame.new(-2000, 10, -2000),
    ["Middle Town"] = CFrame.new(0, 10, 0),
    ["Jungle"] = CFrame.new(3000, 10, 3000),
    ["Desert"] = CFrame.new(-3000, 10, 3000)
}

for locationName, locationCFrame in pairs(locations) do
    CreateButton(TeleportContent, locationName, function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = locationCFrame
        end
    end)
end

-- Sistema de Switch Tab
local function SwitchTab(tabName)
    for _, content in pairs(ContentContainer:GetChildren()) do
        content.Visible = content.Name == tabName.."Content"
    end
end

FarmingTab.MouseButton1Click:Connect(function() SwitchTab("Farming") end)
TeleportTab.MouseButton1Click:Connect(function() SwitchTab("Teleport") end)
StatsTab.MouseButton1Click:Connect(function() SwitchTab("Stats") end)
MiscTab.MouseButton1Click:Connect(function() SwitchTab("Misc") end)

-- Mostrar primeira tab por padrão
SwitchTab("Farming")

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Continuação do script com funcionalidades avançadas

-- Sistema de Auto Farm
local function GetNearestMob()
    local nearest = nil
    local minDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearest = mob
            end
        end
    end
    return nearest
end

-- Quest Data
local QuestData = {
    ["Bandit"] = {
        Level = 1,
        Quest = "BanditQuest1",
        QuestPos = CFrame.new(1060.0065917969, 16.424287796021, 1547.7351074219),
        Mob = "Bandit"
    },
    ["Monkey"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestPos = CFrame.new(-1599.23096, 37.8653831, 153.335892),
        Mob = "Monkey"
    },
    ["Gorilla"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestPos = CFrame.new(-1599.23096, 37.8653831, 153.335892),
        Mob = "Gorilla"
    }
}

-- Sistema de Fast Attack
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)

spawn(function()
    while task.wait() do
        if getgenv().Settings.FastAttack then
            pcall(function()
                CameraShaker:Stop()
                CombatFrameworkR.activeController.hitboxMagnitude = 60
                CombatFrameworkR.activeController.timeToNextAttack = 0
                CombatFrameworkR.activeController.attacking = false
                CombatFrameworkR.activeController.increment = 3
            end)
        end
    end
end)

-- Sistema de Auto Stats
local function AutoStats()
    while getgenv().Settings.AutoStats do
        local args = {
            [1] = "AddPoint",
            [2] = getgenv().Settings.SelectedStat
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        wait(0.1)
    end
end

-- Sistema de Auto Farm
spawn(function()
    while wait() do
        if getgenv().Settings.AutoFarm then
            pcall(function()
                if not Player.PlayerGui.Main.Quest.Visible then
                    -- Pegar Quest
                    local playerLevel = Player.Data.Level.Value
                    local currentQuest = nil
                    
                    for _, questInfo in pairs(QuestData) do
                        if playerLevel >= questInfo.Level then
                            currentQuest = questInfo
                        end
                    end
                    
                    if currentQuest then
                        HumanoidRootPart.CFrame = currentQuest.QuestPos
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", currentQuest.Quest, currentQuest.Level)
                    end
                else
                    -- Farm Mobs
                    local mob = GetNearestMob()
                    if mob then
                        HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        mob.HumanoidRootPart.Transparency = 0.8
                        mob.Humanoid.JumpPower = 0
                        mob.Humanoid.WalkSpeed = 0
                        if getgenv().Settings.AutoHaki and not Player.Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                    end
                end
            end)
        end
    end
end)

-- Sistema de Teleporte Avançado
local TeleportLocations = {
    ["First Island"] = CFrame.new(1000, 10, 1000),
    ["Marine Base"] = CFrame.new(-2000, 10, -2000),
    ["Middle Town"] = CFrame.new(0, 10, 0),
    ["Jungle"] = CFrame.new(3000, 10, 3000),
    ["Desert"] = CFrame.new(-3000, 10, 3000),
    ["Snow Island"] = CFrame.new(-1000, 10, -1000),
    ["MarineFord"] = CFrame.new(4000, 10, 4000)
}

-- Adicionar Toggles ao StatsContent
CreateToggle(StatsContent, "Auto Melee", function(enabled)
    getgenv().Settings.AutoStats = enabled
    getgenv().Settings.SelectedStat = "Melee"
    spawn(AutoStats)
end)

CreateToggle(StatsContent, "Auto Defense", function(enabled)
    getgenv().Settings.AutoStats = enabled
    getgenv().Settings.SelectedStat = "Defense"
    spawn(AutoStats)
end)

CreateToggle(StatsContent, "Auto Sword", function(enabled)
    getgenv().Settings.AutoStats = enabled
    getgenv().Settings.SelectedStat = "Sword"
    spawn(AutoStats)
end)

-- Adicionar Toggles ao MiscContent
CreateToggle(MiscContent, "Auto Haki", function(enabled)
    getgenv().Settings.AutoHaki = enabled
end)

CreateToggle(MiscContent, "No Clip", function(enabled)
    getgenv().Settings.NoClip = enabled
end)

-- Sistema No Clip
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().Settings.NoClip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Sistema de Velocidade de Ataque
local AttackSpeedSlider = Instance.new("Frame")
AttackSpeedSlider.Name = "AttackSpeedSlider"
AttackSpeedSlider.Parent = MiscContent
AttackSpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AttackSpeedSlider.BorderSizePixel = 0
AttackSpeedSlider.Position = UDim2.new(0, 10, 0, (#MiscContent:GetChildren() - 1) * 40)
AttackSpeedSlider.Size = UDim2.new(1, -20, 0, 35)

local SliderButton = Instance.new("TextButton")
SliderButton.Parent = AttackSpeedSlider
SliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderButton.BorderSizePixel = 0
SliderButton.Position = UDim2.new(0, 0, 0.5, -2)
SliderButton.Size = UDim2.new(0.5, 0, 0, 4)
SliderButton.Text = ""

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = AttackSpeedSlider
SliderLabel.BackgroundTransparency = 1
SliderLabel.Position = UDim2.new(0, 10, 0, 0)
SliderLabel.Size = UDim2.new(1, -20, 0.5, 0)
SliderLabel.Font = Enum.Font.GothamSemibold
SliderLabel.Text = "Attack Speed"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.TextSize = 12
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Parent = AttackSpeedSlider
ValueLabel.BackgroundTransparency = 1
ValueLabel.Position = UDim2.new(0, 10, 0.5, 0)
ValueLabel.Size = UDim2.new(1, -20, 0.5, 0)
ValueLabel.Font = Enum.Font.GothamSemibold
ValueLabel.Text = "1x"
ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ValueLabel.TextSize = 12
ValueLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Atualizar interface inicial
SwitchTab("Farming")