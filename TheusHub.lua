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