-- Script ultra básico para Blox Fruits Sea 1
-- Testar função por função para identificar o problema

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

print("Script iniciado")

-- Criar uma interface básica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestScriptGui"
ScreenGui.Parent = Player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Size = UDim2.new(0, 180, 0, 40)
AutoFarmButton.Position = UDim2.new(0.5, -90, 0.5, -20)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AutoFarmButton.Text = "Auto Farm: OFF"
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.Font = Enum.Font.SourceSansBold
AutoFarmButton.TextSize = 18
AutoFarmButton.Parent = Frame

print("UI criada")

-- Variáveis de controle
local AutoFarmEnabled = false
local AutoFarmLoop = nil

-- Função simples para encontrar o inimigo mais próximo
local function GetClosestEnemy()
    local closest = nil
    local minDistance = math.huge
    
    -- Verificar se workspace.Enemies existe
    if not workspace:FindFirstChild("Enemies") then
        print("Pasta Enemies não encontrada")
        return nil
    end
    
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
            local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < minDistance and distance < 100 then
                minDistance = distance
                closest = enemy
            end
        end
    end
    
    return closest
end

-- Função simples para clicar (atacar)
local function Attack()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(500, 500))
end

-- Função para ir até o inimigo e atacar
local function MoveToAndAttack(enemy)
    if not Character:FindFirstChild("HumanoidRootPart") or not enemy:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Move para o inimigo
    Character.Humanoid:MoveTo(enemy.HumanoidRootPart.Position)
    
    -- Espera chegar próximo
    local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
    if distance <= 10 then
        -- Ataca
        Attack()
    end
end

-- Função para iniciar/parar o Auto Farm
local function ToggleAutoFarm()
    AutoFarmEnabled = not AutoFarmEnabled
    AutoFarmButton.Text = "Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    
    print("Auto Farm: " .. (AutoFarmEnabled and "ON" or "OFF"))
    
    if AutoFarmEnabled then
        -- Iniciar loop de Auto Farm
        if AutoFarmLoop then
            AutoFarmLoop:Disconnect()
        end
        
        AutoFarmLoop = RunService.Heartbeat:Connect(function()
            local enemy = GetClosestEnemy()
            if enemy then
                print("Inimigo encontrado: " .. enemy.Name)
                MoveToAndAttack(enemy)
            else
                print("Nenhum inimigo próximo")
            end
        end)
    else
        -- Parar loop de Auto Farm
        if AutoFarmLoop then
            AutoFarmLoop:Disconnect()
            AutoFarmLoop = nil
        end
    end
end

-- Conectar o botão à função
AutoFarmButton.MouseButton1Click:Connect(ToggleAutoFarm)

print("Script completamente carregado")

-- Mensagem de notificação
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Teste",
    Text = "Script carregado! Clique no botão para ativar o Auto Farm.",
    Duration = 5
})