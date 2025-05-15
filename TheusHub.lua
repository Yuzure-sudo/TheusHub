-- Script Premium: Fly + ESP Pro Edition - By Lek do Black
-- VERSÃO PROFISSIONAL + ESP

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

-- Variáveis principais
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local Flying = false
local Speed = 50
local ESPEnabled = false

-- Limpar GUIs anteriores
if CoreGui:FindFirstChild("PremiumFlyESP") then
    CoreGui:FindFirstChild("PremiumFlyESP"):Destroy()
end

-- Criar a GUI principal
local GUI = Instance.new("ScreenGui")
GUI.Name = "PremiumFlyESP"
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false

-- Função para criar cantos arredondados em UI (usado várias vezes)
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Função para efeito de sombra (aspecto profissional)
local function CreateShadow(parent, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.6
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0, 4, 0, 4)
    shadow.Size = parent.Size
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    
    local shadowCorner = CreateCorner(shadow)
    
    parent:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = UDim2.new(0, parent.Position.X.Offset + 4, 0, parent.Position.Y.Offset + 4)
    end)
    
    parent:GetPropertyChangedSignal("Size"):Connect(function()
        shadow.Size = parent.Size
    end)
    
    return shadow
end

-- Função para criar gradiente (melhor visual)
local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(45, 45, 55)),
        ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(35, 35, 45))
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- Criar o painel principal (design moderno)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 210)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10
MainFrame.Parent = GUI

CreateCorner(MainFrame, 12)
CreateShadow(MainFrame, 0.5)
CreateGradient(MainFrame, Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45))

-- Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.ZIndex = 11
TitleBar.Parent = MainFrame

CreateCorner(TitleBar, 12)

-- Gradient do título com cor premium
CreateGradient(TitleBar, Color3.fromRGB(65, 105, 225), Color3.fromRGB(100, 100, 255), 90)

-- Logo (emoji de raio para parecer premium)
local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 15, 0, 0)
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Font = Enum.Font.GothamBold
Logo.Text = "⚡"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 24
Logo.ZIndex = 12
Logo.Parent = TitleBar

-- Título texto
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 55, 0, 0)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLY & ESP PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = TitleBar

-- Divisor para separar seções
local function CreateDivider(parent, posY, text)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    divider.BorderSizePixel = 0
    divider.Position = UDim2.new(0.05, 0, 0, posY)
    divider.Size = UDim2.new(0.9, 0, 0, 2)
    divider.ZIndex = 11
    divider.Parent = parent
    
    if text then
        local label = Instance.new("TextLabel")
        label.Name = "DividerLabel"
        label.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        label.BackgroundTransparency = 0
        label.BorderSizePixel = 0
        label.Position = UDim2.new(0.5, -TextService:GetTextSize(text, 14, Enum.Font.GothamSemibold, Vector2.new(100, 20)).X/2 - 10, 0, -9)
        label.Size = UDim2.new(0, TextService:GetTextSize(text, 14, Enum.Font.GothamSemibold, Vector2.new(100, 20)).X + 20, 0, 18)
        label.Font = Enum.Font.GothamSemibold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextSize = 14
        label.ZIndex = 12
        label.Parent = divider
        
        CreateGradient(label, Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45))
    end
    
    return divider
end

-- Seções
CreateDivider(MainFrame, 50, "CONTROLES DE VOO")

-- Controle de velocidade (slider moderno)
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 70)
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 40)
SpeedFrame.ZIndex = 11
SpeedFrame.Parent = MainFrame

CreateCorner(SpeedFrame, 8)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0, 15, 0, 0)
SpeedLabel.Size = UDim2.new(0, 80, 1, 0)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "Velocidade"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 12
SpeedLabel.Parent = SpeedFrame

local SpeedSliderBG = Instance.new("Frame")
SpeedSliderBG.Name = "SpeedSliderBG"
SpeedSliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedSliderBG.BorderSizePixel = 0
SpeedSliderBG.Position = UDim2.new(0.3, 0, 0.5, -4)
SpeedSliderBG.Size = UDim2.new(0.5, 0, 0, 8)
SpeedSliderBG.ZIndex = 12
SpeedSliderBG.Parent = SpeedFrame

CreateCorner(SpeedSliderBG, 4)

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Size = UDim2.new(0.5, 0, 1, 0)
SpeedSlider.ZIndex = 13
SpeedSlider.Parent = SpeedSliderBG

CreateCorner(SpeedSlider, 4)
CreateGradient(SpeedSlider, Color3.fromRGB(100, 150, 255), Color3.fromRGB(65, 105, 225), 90)

local SpeedDrag = Instance.new("TextButton")
SpeedDrag.Name = "SpeedDrag"
SpeedDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedDrag.BorderSizePixel = 0
SpeedDrag.Position = UDim2.new(0.5, -7, 0.5, -7)
SpeedDrag.Size = UDim2.new(0, 14, 0, 14)
SpeedDrag.Text = ""
SpeedDrag.ZIndex = 14
SpeedDrag.Parent = SpeedSlider

CreateCorner(SpeedDrag, 7)

local SpeedValue = Instance.new("TextLabel")
SpeedValue.Name = "SpeedValue"
SpeedValue.BackgroundTransparency = 1
SpeedValue.Position = UDim2.new(0.85, 0, 0, 0)
SpeedValue.Size = UDim2.new(0, 40, 1, 0)
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Text = "50"
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.TextSize = 16
SpeedValue.ZIndex = 12
SpeedValue.Parent = SpeedFrame

-- Configuração do slider de velocidade
local SliderMax = 150
local SliderMin = 10
local SliderDragging = false

SpeedDrag.MouseButton1Down:Connect(function()
    SliderDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = false
    end
end)

SpeedSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = true
        
        local relX = math.clamp((input.Position.X - SpeedSliderBG.AbsolutePosition.X) / SpeedSliderBG.AbsoluteSize.X, 0, 1)
        SpeedSlider.Size = UDim2.new(relX, 0, 1, 0)
        Speed = math.floor(SliderMin + relX * (SliderMax - SliderMin))
        SpeedValue.Text = tostring(Speed)
    end
end)

RunService.RenderStepped:Connect(function()
    if SliderDragging then
        local mousePos = UserInputService:GetMouseLocation()
        local relX = math.clamp((mousePos.X - SpeedSliderBG.AbsolutePosition.X) / SpeedSliderBG.AbsoluteSize.X, 0, 1)
        SpeedSlider.Size = UDim2.new(relX, 0, 1, 0)
        Speed = math.floor(SliderMin + relX * (SliderMax - SliderMin))
        SpeedValue.Text = tostring(Speed)
    end
end)

-- Botões de recursos
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Position = UDim2.new(0.05, 0, 0, 120)
ButtonsFrame.Size = UDim2.new(0.9, 0, 0, 40)
ButtonsFrame.ZIndex = 11
ButtonsFrame.Parent = MainFrame

-- Botão de Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
FlyButton.BorderSizePixel = 0
FlyButton.Position = UDim2.new(0, 0, 0, 0)
FlyButton.Size = UDim2.new(0.485, 0, 1, 0)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "ATIVAR FLY"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 16
FlyButton.ZIndex = 12
FlyButton.Parent = ButtonsFrame

CreateCorner(FlyButton, 8)
CreateGradient(FlyButton, Color3.fromRGB(85, 125, 245), Color3.fromRGB(65, 105, 225), 90)

-- Botão de ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ESPButton.BorderSizePixel = 0
ESPButton.Position = UDim2.new(0.515, 0, 0, 0)
ESPButton.Size = UDim2.new(0.485, 0, 1, 0)
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Text = "ATIVAR ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.ZIndex = 12
ESPButton.Parent = ButtonsFrame

CreateCorner(ESPButton, 8)
CreateGradient(ESPButton, Color3.fromRGB(65, 65, 85), Color3.fromRGB(45, 45, 65), 90)

-- Divider for ESP Settings
CreateDivider(MainFrame, 170, "CONFIGURAÇÕES")

-- Créditos
local Credits = Instance.new("TextLabel")
Credits.Name = "Credits"
Credits.BackgroundTransparency = 1
Credits.Position = UDim2.new(0, 0, 1, -25)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Font = Enum.Font.Gotham
Credits.Text = "Feito por Lek do Black © 2023"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 12
Credits.ZIndex = 11
Credits.Parent = MainFrame

-- Notificações estilizadas
local NotifFrame = Instance.new("Frame")
NotifFrame.Name = "NotifFrame"
NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NotifFrame.BorderSizePixel = 0
NotifFrame.Position = UDim2.new(0.5, -150, 0, -60)
NotifFrame.Size = UDim2.new(0, 300, 0, 60)
NotifFrame.ZIndex = 100
NotifFrame.Parent = GUI

CreateCorner(NotifFrame, 8)
CreateShadow(NotifFrame, 0.5)
CreateGradient(NotifFrame, Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45))

local NotifIcon = Instance.new("TextLabel")
NotifIcon.Name = "NotifIcon"
NotifIcon.BackgroundTransparency = 1
NotifIcon.Position = UDim2.new(0, 15, 0, 0)
NotifIcon.Size = UDim2.new(0, 30, 0, 60)
NotifIcon.Font = Enum.Font.GothamBold
NotifIcon.Text = "🚀"
NotifIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifIcon.TextSize = 24
NotifIcon.ZIndex = 101
NotifIcon.Parent = NotifFrame

local NotifTitle = Instance.new("TextLabel")
NotifTitle.Name = "NotifTitle"
NotifTitle.BackgroundTransparency = 1
NotifTitle.Position = UDim2.new(0, 50, 0, 10)
NotifTitle.Size = UDim2.new(1, -60, 0, 20)
NotifTitle.Font = Enum.Font.GothamBold
NotifTitle.Text = "Fly & ESP Premium"
NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifTitle.TextSize = 16
NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
NotifTitle.ZIndex = 101
NotifTitle.Parent = NotifFrame

local NotifText = Instance.new("TextLabel")
NotifText.Name = "NotifText"
NotifText.BackgroundTransparency = 1
NotifText.Position = UDim2.new(0, 50, 0, 30)
NotifText.Size = UDim2.new(1, -60, 0, 20)
NotifText.Font = Enum.Font.Gotham
NotifText.Text = "Script ativado com sucesso!"
NotifText.TextColor3 = Color3.fromRGB(200, 200, 200)
NotifText.TextSize = 14
NotifText.TextXAlignment = Enum.TextXAlignment.Left
NotifText.ZIndex = 101
NotifText.Parent = NotifFrame

-- Função para mostrar notificação
local function ShowNotification(title, text, icon, color)
    NotifTitle.Text = title or "Notificação"
    NotifText.Text = text or ""
    NotifIcon.Text = icon or "🚀"
    
    if color then
        CreateGradient(NotifFrame, color, Color3.fromRGB(30, 30, 45))
    else
        CreateGradient(NotifFrame, Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45))
    end
    
    -- Animações
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    
    delay(4, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
    end)
end

-- Funções principais do Fly
local FlyGyro, FlyVel
local LastAnalogY = 0

local function UpdateAnalogState()
    local character = Player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Tenta usar o MoveDirection.Y para subida/descida se disponível
        if humanoid and humanoid.MoveDirection then
            LastAnalogY = humanoid.MoveDirection.Y
        end
    end
end

local function StartFly()
    if Flying then return end
    
    -- Obter personagem
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then 
        ShowNotification("Erro", "Personagem não encontrado", "⚠️", Color3.fromRGB(255, 100, 100))
        return 
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    -- Criar controles de voo
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = HRP.CFrame
    FlyGyro.Parent = HRP
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = HRP
    
    Flying = true
    FlyButton.Text = "DESATIVAR FLY"
    CreateGradient(FlyButton, Color3.fromRGB(255, 80, 80), Color3.fromRGB(220, 60, 60), 90)
    
    ShowNotification("Fly Ativado", "Use o analógico para voar!", "🚀", Color3.fromRGB(65, 185, 255))
    
    -- Loop de voo
    RunService:BindToRenderStep("PremiumFly", 1, function()
        if not Flying or not Character:FindFirstChild("HumanoidRootPart") or not FlyGyro or not FlyVel then
            StopFly()
            return
        end
        
        HRP = Character:FindFirstChild("HumanoidRootPart")
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Atualizar estado do analógico
        UpdateAnalogState()
        
        -- Orientação baseada na câmera
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Usar a direção do movimento do Roblox
        local moveDir = Humanoid.MoveDirection
        
        -- Tentar usar MoveDirection.Y se existir (depende do executor)
        local yVelocity = LastAnalogY * Speed
        
        -- Criar vetor final de movimento
        FlyVel.Velocity = Vector3.new(moveDir.X * Speed, yVelocity, moveDir.Z * Speed)
    end)
end

local function StopFly()
    if not Flying then return end
    
    RunService:UnbindFromRenderStep("PremiumFly")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    Flying = false
    LastAnalogY = 0
    FlyButton.Text = "ATIVAR FLY"
    CreateGradient(FlyButton, Color3.fromRGB(85, 125, 245), Color3.fromRGB(65, 105, 225), 90)
    
    ShowNotification("Fly Desativado", "Voltou ao normal", "🛑")
end

-- Sistema de ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPElements"
ESPFolder.Parent = GUI

local ESPSettings = {
    Names = true,
    Boxes = true,
    Distance = true,
    TeamColor = true,
    TeamCheck = false,
    Color = Color3.fromRGB(255, 0, 0),
    MaxDistance = 1000
}

local function ClearESP()
    ESPFolder:ClearAllChildren()
end

local function CreatePlayerESP(player)
    if player == Player then return end
    
    -- Tag para cada jogador
    local PlayerTag = Instance.new("BillboardGui")
    PlayerTag.Name = "ESP_" .. player.Name
    PlayerTag.AlwaysOnTop = true
    PlayerTag.Size = UDim2.new(0, 200, 0, 50)
    PlayerTag.StudsOffset = Vector3.new(0, 3, 0)
    PlayerTag.Parent = ESPFolder
    
    -- Nome
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.BackgroundTransparency = 1
    NameLabel.Position = UDim2.new(0, 0, 0, 0)
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextStrokeTransparency = 0.3
    NameLabel.TextSize = 14
    NameLabel.ZIndex = 2
    NameLabel.Parent = PlayerTag
    
    -- Distância
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Position = UDim2.new(0, 0, 0, 20)
    DistanceLabel.Size = UDim2.new(1, 0, 0, 20)
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.Text = "0m"
    DistanceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DistanceLabel.TextStrokeTransparency = 0.3
    DistanceLabel.TextSize = 12
    DistanceLabel.ZIndex = 2
    DistanceLabel.Parent = PlayerTag
    
    -- Atualização constante
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not ESPEnabled then
            PlayerTag:Destroy()
            if connection then connection:Disconnect() end
            return
        end
        
        -- Checar se o jogador ainda existe
        if not player or not player.Parent then
            PlayerTag:Destroy()
            if connection then connection:Disconnect() end
            return
        end
        
        -- Checar se tem personagem
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
            PlayerTag.Enabled = false
            return
        else
            PlayerTag.Enabled = true
        end
        
        -- Atualizar posição
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        PlayerTag.Adornee = humanoidRootPart
        
        -- Checar distância
        local distance = (humanoidRootPart.Position - Camera.CFrame.Position).Magnitude
        if distance > ESPSettings.MaxDistance then
            PlayerTag.Enabled = false
            return
        end
        
        -- Atualizar informações
        DistanceLabel.Text = math.floor(distance) .. "m"
        
        -- Cor baseada no time
        if ESPSettings.TeamColor and player.Team and Player.Team then
            local teamColor = player.TeamColor.Color
            NameLabel.TextColor3 = teamColor
            
            if ESPSettings.TeamCheck and player.Team == Player.Team then
                PlayerTag.Enabled = false
                return
            end
        else
            NameLabel.TextColor3 = ESPSettings.Color
        end
    end)
end

local function StartESP()
    if ESPEnabled then return end
    
    ESPEnabled = true
    ESPButton.Text = "DESATIVAR ESP"
    CreateGradient(ESPButton, Color3.fromRGB(65, 185, 255), Color3.fromRGB(65, 135, 205), 90)
    
    ShowNotification("ESP Ativado", "Agora pode ver os jogadores", "👁️", Color3.fromRGB(65, 185, 255))
    
    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        CreatePlayerESP(player)
    end
    
        -- Monitorar novos jogadores
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            CreatePlayerESP(player)
        end
    end)
end

local function StopESP()
    if not ESPEnabled then return end
    
    ESPEnabled = false
    ESPButton.Text = "ATIVAR ESP"
    CreateGradient(ESPButton, Color3.fromRGB(65, 65, 85), Color3.fromRGB(45, 45, 65), 90)
    
    ShowNotification("ESP Desativado", "Jogadores ocultos", "🔍")
    
    -- Limpar ESP
    ClearESP()
end

-- Bind de botões
FlyButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    if ESPEnabled then
        StopESP()
    else
        StartESP()
    end
end)

-- Botões adicionais
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Position = UDim2.new(0.05, 0, 0, 180)
SettingsFrame.Size = UDim2.new(0.9, 0, 0, 25)
SettingsFrame.ZIndex = 11
SettingsFrame.Parent = MainFrame

-- Toggle para ocultar UI
local HideUIButton = Instance.new("TextButton")
HideUIButton.Name = "HideUIButton"
HideUIButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
HideUIButton.BorderSizePixel = 0
HideUIButton.Position = UDim2.new(0, 0, 0, 0)
HideUIButton.Size = UDim2.new(0.485, 0, 1, 0)
HideUIButton.Font = Enum.Font.GothamSemibold
HideUIButton.Text = "Ocultar UI (F)"
HideUIButton.TextColor3 = Color3.fromRGB(220, 220, 220)
HideUIButton.TextSize = 14
HideUIButton.ZIndex = 12
HideUIButton.Parent = SettingsFrame

CreateCorner(HideUIButton, 6)

-- Botão para fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.515, 0, 0, 0)
CloseButton.Size = UDim2.new(0.485, 0, 1, 0)
CloseButton.Font = Enum.Font.GothamSemibold
CloseButton.Text = "Fechar"
CloseButton.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseButton.TextSize = 14
CloseButton.ZIndex = 12
CloseButton.Parent = SettingsFrame

CreateCorner(CloseButton, 6)

-- Função para ocultar/mostrar a UI
local UIVisible = true
local function ToggleUIVisibility()
    UIVisible = not UIVisible
    MainFrame.Visible = UIVisible
end

-- Botão para ocultar
HideUIButton.MouseButton1Click:Connect(ToggleUIVisibility)

-- Tecla F para ocultar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        ToggleUIVisibility()
    end
end)

-- Botão para fechar
CloseButton.MouseButton1Click:Connect(function()
    GUI:Destroy()
    if Flying then StopFly() end
    if ESPEnabled then StopESP() end
end)

-- Animação inicial
MainFrame.Position = UDim2.new(0.5, -175, 0, -250)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -175, 0.1, 0)}):Play()

-- Mostrar notificação inicial
ShowNotification("Script Carregado", "Fly & ESP Premium ativado!", "🚀", Color3.fromRGB(65, 185, 255))

-- Botões de controle vertical
-- Essas são opções extras caso o analógico não funcione em alguns dispositivos
local UpDownFrame = Instance.new("Frame")
UpDownFrame.Name = "UpDownFrame"
UpDownFrame.BackgroundTransparency = 1
UpDownFrame.Position = UDim2.new(0.9, -50, 0.5, -50)
UpDownFrame.Size = UDim2.new(0, 50, 0, 100)
UpDownFrame.ZIndex = 50
UpDownFrame.Parent = GUI

local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UpButton.BackgroundTransparency = 0.2
UpButton.Position = UDim2.new(0, 0, 0, 0)
UpButton.Size = UDim2.new(1, 0, 0, 50)
UpButton.Text = "↑"
UpButton.TextColor3 = Color3.fromRGB(220, 220, 220)
UpButton.TextSize = 24
UpButton.Font = Enum.Font.GothamBold
UpButton.ZIndex = 51
UpButton.Parent = UpDownFrame

CreateCorner(UpButton, 8)

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DownButton.BackgroundTransparency = 0.2
DownButton.Position = UDim2.new(0, 0, 0, 50)
DownButton.Size = UDim2.new(1, 0, 0, 50)
DownButton.Text = "↓"
DownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
DownButton.TextSize = 24
DownButton.Font = Enum.Font.GothamBold
DownButton.ZIndex = 51
DownButton.Parent = UpDownFrame

CreateCorner(DownButton, 8)

-- Eventos para subir/descer (opcão reserva)
local isUpPressed, isDownPressed = false, false

UpButton.MouseButton1Down:Connect(function()
    isUpPressed = true
    LastAnalogY = 1
end)

UpButton.MouseButton1Up:Connect(function()
    isUpPressed = false
    if not isDownPressed then LastAnalogY = 0 end
end)

DownButton.MouseButton1Down:Connect(function()
    isDownPressed = true
    LastAnalogY = -1
end)

DownButton.MouseButton1Up:Connect(function()
    isDownPressed = false
    if not isUpPressed then LastAnalogY = 0 end
end)

-- Ocultação dos botões quando o fly estiver desativado
RunService.RenderStepped:Connect(function()
    UpDownFrame.Visible = Flying
end)

-- Adicionar detecção de analógico avançado para dispositivos móveis
-- Isso tenta capturar o movimento vertical do analógico em alguns executores
local function SetupAdvancedAnalogDetection()
    local success = pcall(function()
        -- Tenta usar recursos avançados se disponíveis
        local VirtualUser = game:GetService("VirtualUser")
        local TouchEnabled = UserInputService.TouchEnabled
        
        if TouchEnabled then
            -- Tenta detectar movimento vertical do analógico
            UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
                if Flying and not gameProcessed then
                    -- Lógica avançada para detectar movimento vertical
                    -- Isso é uma simulação, pois depende do executor
                    local touchDelta = touch.Delta
                    if touchDelta.Y > 10 then
                        LastAnalogY = -0.5
                    elseif touchDelta.Y < -10 then
                        LastAnalogY = 0.5
                    end
                end
            end)
        end
    end)
    
    if not success then
        print("Detecção avançada de analógico não disponível - usando controles alternativos")
    end
end

-- Tenta configurar detecção avançada
SetupAdvancedAnalogDetection()

-- Adicionar marca d'água discreta
local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.BackgroundTransparency = 1
Watermark.Position = UDim2.new(0, 5, 1, -25)
Watermark.Size = UDim2.new(0, 200, 0, 20)
Watermark.Font = Enum.Font.Gotham
Watermark.Text = "Fly & ESP Premium v3.0"
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.TextTransparency = 0.7
Watermark.TextSize = 14
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.ZIndex = 1
Watermark.Parent = GUI

print("Script Fly & ESP Premium carregado com sucesso!")
print("Use o analógico para controle completo de movimento.")
print("Desenvolvido por: Lek do Black")