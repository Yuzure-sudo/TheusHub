local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = game.CoreGui

-- Painel Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.85, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Arredondamento do Painel
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.05, 0)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Text = "Fly Mobile"
Title.Parent = MainFrame

-- Arredondamento do Título
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0.05, 0)
TitleCorner.Parent = Title

-- Botão Toggle
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Ativar Fly"
ToggleButton.Parent = MainFrame

-- Arredondamento do Botão Toggle
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.2, 0)
ToggleCorner.Parent = ToggleButton

-- Slider de Velocidade
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.8, 0, 0, 40)
SpeedFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedFrame.Parent = MainFrame

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.5, 0, 1, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
SpeedSlider.Text = ""
SpeedSlider.Parent = SpeedFrame

-- Arredondamento do Slider
local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0.2, 0)
SliderCorner.Parent = SpeedFrame

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(0.2, 0)
SliderButtonCorner.Parent = SpeedSlider

-- Texto da Velocidade
local SpeedText = Instance.new("TextLabel")
SpeedText.Name = "SpeedText"
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0.6, 0)
SpeedText.BackgroundTransparency = 1
SpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedText.TextSize = 16
SpeedText.Font = Enum.Font.GothamBold
SpeedText.Text = "Velocidade: 50"
SpeedText.Parent = MainFrame

-- Controles de Direção
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
ControlsFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = MainFrame

-- Variáveis de Controle
local Flying = false
local Speed = 50
local TouchStartPosition = nil
local LastTouchPosition = nil

-- Funções
local function StartFlying()
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "FlyVelocity"
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = HumanoidRootPart
    
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "FlyGyro"
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.P = 9000
    BodyGyro.Parent = HumanoidRootPart
    
    Humanoid.PlatformStand = true
end

local function StopFlying()
    if HumanoidRootPart:FindFirstChild("FlyVelocity") then
        HumanoidRootPart.FlyVelocity:Destroy()
    end
    if HumanoidRootPart:FindFirstChild("FlyGyro") then
        HumanoidRootPart.FlyGyro:Destroy()
    end
    Humanoid.PlatformStand = false
end

-- Eventos
ToggleButton.MouseButton1Click:Connect(function()
    Flying = not Flying
    if Flying then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "Desativar Fly"
        StartFlying()
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
        ToggleButton.Text = "Ativar Fly"
        StopFlying()
    end
end)

-- Controle de Velocidade
local DraggingSpeed = false

SpeedSlider.MouseButton1Down:Connect(function()
    DraggingSpeed = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        DraggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if DraggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPosition = math.clamp((input.Position.X - SpeedFrame.AbsolutePosition.X) / SpeedFrame.AbsoluteSize.X, 0, 1)
        SpeedSlider.Size = UDim2.new(sliderPosition, 0, 1, 0)
        Speed = math.floor(sliderPosition * 100)
        SpeedText.Text = "Velocidade: " .. Speed
    end
end)

-- Controles Mobile
UserInputService.TouchStarted:Connect(function(touch)
    TouchStartPosition = touch.Position
    LastTouchPosition = touch.Position
end)

UserInputService.TouchMoved:Connect(function(touch)
    if Flying and TouchStartPosition then
        local delta = touch.Position - LastTouchPosition
        LastTouchPosition = touch.Position
        
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local flyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
                if flyVelocity then
                    local camera = workspace.CurrentCamera
                    local lookVector = camera.CFrame.LookVector
                    local rightVector = camera.CFrame.RightVector
                    
                    local moveDirection = Vector3.new(
                        delta.X / 10,
                        delta.Y / -10,
                        0
                    )
                    
                    flyVelocity.Velocity = moveDirection * Speed
                end
            end
        end
    end
end)

UserInputService.TouchEnded:Connect(function(touch)
    if Flying then
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local flyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
                if flyVelocity then
                    flyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
    TouchStartPosition = nil
    LastTouchPosition = nil
end)

-- Dragging da Interface
local Dragging = false
local DragStart = nil
local StartPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)