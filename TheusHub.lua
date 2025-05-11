-- Script de Fly para Roblox Mobile com Noclip

-- Configurações
local FLY_KEY = Enum.KeyCode.E -- Tecla para ativar/desativar o voo
local NOCLIP_KEY = Enum.KeyCode.Q -- Tecla para ativar/desativar o noclip
local FLY_SPEED = 1 -- Velocidade de voo (ajuste conforme necessário)

-- Variáveis locais
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local flying = false
local noclip = false

-- Função para alternar o estado de voo
local function toggleFly()
    flying = not flying
    humanoid.PlatformStand = flying
end

-- Função para alternar o estado de noclip
local function toggleNoclip()
    noclip = not noclip
    if noclip then
        -- Desabilita colisões para todas as partes do personagem
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        -- Reabilita colisões para todas as partes do personagem (pode precisar de ajustes dependendo do jogo)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Conecta a função aos eventos de input do usuário
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.Q then
        toggleNoclip()
    end
end)

-- Mantém o personagem voando enquanto o modo de voo está ativo
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and humanoid and humanoid.RootPart then
        local cameraDirection = workspace.CurrentCamera.CFrame.LookVector
        local moveDirection = Vector3.new(0, 0, 0)

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(cameraDirection.X, 0, cameraDirection.Z).Unit
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Vector3.new(cameraDirection.X, 0, cameraDirection.Z).Unit
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end

        humanoid.RootPart.Velocity = moveDirection * FLY_SPEED
    end
end)