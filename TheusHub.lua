-- Fly Script Mobile ULTRA SIMPLIFICADO - By Lek do Black
-- Versão super básica para maior compatibilidade

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Variáveis principais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera
local Flying = false
local Speed = 50
local UpVelocity = 0

-- Limpar GUIs anteriores
if CoreGui:FindFirstChild("SimpleFlyMobile") then
    CoreGui:FindFirstChild("SimpleFlyMobile"):Destroy()
end

-- Interface simples
local FlyUI = Instance.new("ScreenGui")
FlyUI.Name = "SimpleFlyMobile"
FlyUI.Parent = CoreGui
FlyUI.ResetOnSpawn = false

-- Botão principal
local MainButton = Instance.new("TextButton")
MainButton.Name = "FlyButton"
MainButton.Parent = FlyUI
MainButton.Size = UDim2.new(0, 120, 0, 50)
MainButton.Position = UDim2.new(0.5, -60, 0.1, 0)
MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainButton.BorderSizePixel = 0
MainButton.Text = "ATIVAR FLY"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 16

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = MainButton

-- Botões para subir/descer
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Parent = FlyUI
UpButton.Size = UDim2.new(0, 70, 0, 70)
UpButton.Position = UDim2.new(0.9, -70, 0.4, 0)
UpButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
UpButton.BorderSizePixel = 0
UpButton.Text = "↑"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.Font = Enum.Font.GothamBold
UpButton.TextSize = 30

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpButton

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Parent = FlyUI
DownButton.Size = UDim2.new(0, 70, 0, 70)
DownButton.Position = UDim2.new(0.9, -70, 0.6, 0)
DownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DownButton.BorderSizePixel = 0
DownButton.Text = "↓"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.Font = Enum.Font.GothamBold
DownButton.TextSize = 30

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 8)
DownCorner.Parent = DownButton

-- Funções de voo (versão simplificada)
local FlyGyro, FlyVel

local function StartFly()
    if Flying then return end
    
    -- Obter personagem novamente (caso tenha respawnado)
    Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then 
        print("Erro: Personagem não encontrado")
        return 
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not HRP or not Humanoid then
        print("Erro: Partes do personagem não encontradas")
        return
    end
    
    -- Criar BodyGyro e BodyVelocity de forma mais simples
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
    MainButton.Text = "DESATIVAR FLY"
    MainButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    -- Loop simple para voo
    RunService:BindToRenderStep("SimpleFly", 1, function()
        if not Flying or not Character:FindFirstChild("HumanoidRootPart") or not FlyGyro or not FlyVel then
            StopFly()
            return
        end
        
        HRP = Character:FindFirstChild("HumanoidRootPart")
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Orientação baseada na câmera
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Usar a direção do movimento do Roblox
        local moveDir = Humanoid.MoveDirection * Speed
        
        -- Adicionar movimento vertical
        FlyVel.Velocity = Vector3.new(moveDir.X, UpVelocity, moveDir.Z)
    end)
end

local function StopFly()
    if not Flying then return end
    
    RunService:UnbindFromRenderStep("SimpleFly")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    Flying = false
    UpVelocity = 0
    MainButton.Text = "ATIVAR FLY"
    MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end

-- Controle de subida/descida
UpButton.MouseButton1Down:Connect(function()
    UpVelocity = Speed
end)

UpButton.MouseButton1Up:Connect(function()
    UpVelocity = 0
end)

DownButton.MouseButton1Down:Connect(function()
    UpVelocity = -Speed
end)

DownButton.MouseButton1Up:Connect(function()
    UpVelocity = 0
end)

-- Botão principal
MainButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end)

-- Mensagem de aviso
print("Script de voo SIMPLIFICADO ativado. Este é um script básico que deve funcionar em mais jogos.")
print("Se não funcionar, pode ser que o jogo tenha anti-cheat.")
