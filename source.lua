-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Funções Principais do Blox Fruits
local function getNearestMob()
    local nearestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

local function AutoAttack()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(851, 158), workspace.CurrentCamera.CFrame)
end

-- Interface Principal
local TheusHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local ButtonsFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local FarmBtn = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local TeleportBtn = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local SettingsBtn = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")

-- Propriedades
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui
TheusHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = TheusHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.0199999996, 0, 0.0399999991, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 300)

UICorner.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_2.Parent = TopBar

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 1.000
MinimizeBtn.Position = UDim2.new(1, -25, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 25, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14.000

ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = MainFrame
ButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonsFrame.BackgroundTransparency = 1.000
ButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
ButtonsFrame.Size = UDim2.new(1, 0, 1, -40)

UIListLayout.Parent = ButtonsFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

FarmBtn.Name = "FarmBtn"
FarmBtn.Parent = ButtonsFrame
FarmBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FarmBtn.Size = UDim2.new(0.899999976, 0, 0, 35)
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.Text = "Auto Farm"
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize = 14.000

UICorner_3.Parent = FarmBtn

TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = ButtonsFrame
TeleportBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TeleportBtn.Size = UDim2.new(0.899999976, 0, 0, 35)
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.Text = "Teleport"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextSize = 14.000

UICorner_4.Parent = TeleportBtn

SettingsBtn.Name = "SettingsBtn"
SettingsBtn.Parent = ButtonsFrame
SettingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsBtn.Size = UDim2.new(0.899999976, 0, 0, 35)
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.TextSize = 14.000

UICorner_5.Parent = SettingsBtn

-- Variáveis de Controle
local AutoFarmEnabled = false

-- Funções dos Botões
FarmBtn.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    FarmBtn.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
    
    while AutoFarmEnabled do
        local mob = getNearestMob()
        if mob then
            local targetPosition = mob.HumanoidRootPart.Position
            local tweenInfo = TweenInfo.new(
                0.5,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            
            local tween = TweenService:Create(
                Player.Character.HumanoidRootPart,
                tweenInfo,
                {CFrame = CFrame.new(targetPosition)}
            )
            tween:Play()
            AutoAttack()
        end
        wait(0.1)
    end
end)

-- Arrasto da Interface
local isDragging = false
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Minimizar/Maximizar
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ButtonsFrame.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 300)
end)