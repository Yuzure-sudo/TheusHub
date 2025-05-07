local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tela de Carregamento
local LoadingScreen = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local LoadingBar = Instance.new("Frame")
local LoadingText = Instance.new("TextLabel")
local Logo = Instance.new("ImageLabel")

LoadingScreen.Name = "LoadingScreen"
LoadingScreen.Parent = game.CoreGui

Background.Name = "Background"
Background.Parent = LoadingScreen
Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.Size = UDim2.new(1, 0, 1, 0)

Logo.Name = "Logo"
Logo.Parent = Background
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -100, 0.4, -100)
Logo.Size = UDim2.new(0, 200, 0, 200)
Logo.Image = "rbxassetid://7743878358" -- ID de uma imagem genérica do Roblox

LoadingBar.Name = "LoadingBar"
LoadingBar.Parent = Background
LoadingBar.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Position = UDim2.new(0.3, 0, 0.6, 0)
LoadingBar.Size = UDim2.new(0, 0, 0, 5)

LoadingText.Name = "LoadingText"
LoadingText.Parent = Background
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 0, 0.7, 0)
LoadingText.Size = UDim2.new(1, 0, 0, 50)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "Carregando..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 24

-- Animação de Carregamento
local function LoadAnimation()
    for i = 1, 100 do
        LoadingBar:TweenSize(
            UDim2.new(0.4 * (i/100), 0, 0, 5),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Linear,
            0.01,
            true
        )
        LoadingText.Text = "Carregando... " .. i .. "%"
        wait(0.02)
    end
    wait(0.5)
    LoadingScreen:Destroy()
end

-- Interface Principal
local Window = OrionLib:MakeWindow({
    Name = "Theus Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TheusConfig",
    IntroEnabled = false
})

-- Botão de Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = game.CoreGui
MinimizeButton.Position = UDim2.new(0.85, 0, 0.05, 0)
MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 30
MinimizeButton.Font = Enum.Font.GothamBold

-- Tabs
local MainTab = Window:MakeTab({
    Name = "Principal",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Seções
MainTab:AddSection({
    Name = "Kill Aura"
})

MainTab:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(Value)
        _G.KillAura = Value
    end    
})

FarmTab:AddSection({
    Name = "Auto Farm"
})

FarmTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
    end    
})

TeleportTab:AddSection({
    Name = "Teleportes"
})

TeleportTab:AddButton({
    Name = "Próxima Ilha",
    Callback = function()
        -- Código de teleporte aqui
    end    
})

-- Funcionalidade do botão de minimizar
local MainGui = game:GetService("CoreGui"):WaitForChild("Orion")
local Minimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainGui.Enabled = false
        MinimizeButton.Text = "+"
    else
        MainGui.Enabled = true
        MinimizeButton.Text = "-"
    end
end)

-- Arredondamento do botão de minimizar
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0)
UICorner.Parent = MinimizeButton

-- Sombra do botão
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MinimizeButton
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Iniciar a animação de carregamento
LoadAnimation()

-- Configurações de UI Mobile
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
    -- Ajustes para dispositivos móveis
    MinimizeButton.Size = UDim2.new(0, 70, 0, 70)
    MinimizeButton.TextSize = 40
end

-- Notificação de Boas-vindas
OrionLib:MakeNotification({
    Name = "Theus Hub",
    Content = "Bem-vindo ao Theus Hub!",
    Image = "rbxassetid://4483345998",
    Time = 5
})