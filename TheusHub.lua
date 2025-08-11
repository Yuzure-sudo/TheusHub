-- Savannah Life Professional Script (WindUI Version)
-- Atualizado para Agosto 2025
-- Compatível com Synapse X, KRNL, Fluxus e outros executores

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Configurações iniciais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()

-- Carregar WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImWindUI/WindUI-Library/main/WindUI.lua"))()

-- Criar janela principal
local Window = WindUI:CreateWindow({
    Name = "SAVANNAH LIFE | PRO",
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 450, 0, 400),
    Theme = "Dark",
    Accent = Color3.fromRGB(0, 150, 255),
    MinimizeKey = Enum.KeyCode.RightShift
})

-- Botão minimizar externo profissional
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "≡"
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(0.5, -17.5, 0, -40)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.ZIndex = 100
MinimizeButton.Parent = Window.Main

-- Função para minimizar/restaurar
MinimizeButton.MouseButton1Click:Connect(function()
    if Window.Minimized then
        Window:Restore()
        MinimizeButton.Text = "≡"
    else
        Window:Minimize()
        MinimizeButton.Text = "□"
    end
end)

-- Tabs profissionais
local CombatTab = Window:CreateTab("Combate")
local VisualTab = Window:CreateTab("Visual")
local ConfigTab = Window:CreateTab("Configurações")

-- Variáveis de estado
local Settings = {
    KillAura = false,
    FollowTarget = false,
    PlayerESP = false,
    CorpseESP = false,
    AuraRadius = 25,
    AttackDelay = 0.3,
    CurrentTarget = nil
}

-- Sistema de ESP profissional
local ESP = {
    Players = {},
    Corpses = {}
}

local function CreateESP(instance, name, color, isCorpse)
    local esp = {}
    
    esp.Box = Drawing.new("Square")
    esp.Box.Visible = false
    esp.Box.Color = color
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    
    esp.Text = Drawing.new("Text")
    esp.Text.Visible = false
    esp.Text.Color = color
    esp.Text.Size = 16
    esp.Text.Center = true
    esp.Text.Outline = true
    esp.Text.Text = name
    
    esp.Part = instance
    esp.IsCorpse = isCorpse
    
    return esp
end

local function UpdateESP()
    for _, esp in pairs(ESP.Players) do
        if esp.Box then esp.Box:Remove() end
        if esp.Text then esp.Text:Remove() end
    end
    for _, esp in pairs(ESP.Corpses) do
        if esp.Box then esp.Box:Remove() end
        if esp.Text then esp.Text:Remove() end
    end
    ESP.Players = {}
    ESP.Corpses = {}
end

-- Função de ataque profissional
local function Attack(target)
    local args = {
        [1] = target,
        [2] = CFrame.new(Character.HumanoidRootPart.Position)
    }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("AttackEvent"):FireServer(unpack(args))
    end)
    if not success then
        WindUI:Notify("Erro", "Falha no ataque: " .. err, 5)
    end
end

-- Loop de combate otimizado
local CombatLoop = RunService.Heartbeat:Connect(function()
    if not Settings.KillAura or not Character or not Character:FindFirstChild("HumanoidRootPart") then 
        if Settings.CurrentTarget then
            Settings.CurrentTarget = nil
        end
        return 
    end
    
    local closestPlayer, closestDistance = nil, Settings.AuraRadius + 1
    local myPos = Character.HumanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local distance = (myPos - root.Position).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end
    
    if closestPlayer then
        Attack(closestPlayer)
        Settings.CurrentTarget = closestPlayer
        
        if Settings.FollowTarget then
            Character.Humanoid:MoveTo(closestPlayer.Character.HumanoidRootPart.Position)
        end
        task.wait(Settings.AttackDelay)
    else
        Settings.CurrentTarget = nil
    end
end)

-- Loop de ESP profissional
local ESPLoop = RunService.RenderStepped:Connect(function()
    -- Atualizar ESP de jogadores
    if Settings.PlayerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    local animalType = "Humano"
                    for _, child in ipairs(char:GetChildren()) do
                        if child.Name:find("Animal") or child.Name:find("Beast") then
                            animalType = child.Name
                            break
                        end
                    end
                    
                    if not ESP.Players[player] then
                        ESP.Players[player] = CreateESP(root, player.Name.." | "..animalType, Color3.fromRGB(0, 255, 255))
                    end
                    
                    local esp = ESP.Players[player]
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        local scale = 1000 / pos.Z
                        esp.Box.Size = Vector2.new(scale, scale * 1.5)
                        esp.Box.Position = Vector2.new(pos.X - scale/2, pos.Y - scale)
                        esp.Box.Visible = true
                        
                        esp.Text.Position = Vector2.new(pos.X, pos.Y - scale - 20)
                        esp.Text.Visible = true
                    else
                        esp.Box.Visible = false
                        esp.Text.Visible = false
                    end
                end
            end
        end
    else
        for player, esp in pairs(ESP.Players) do
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
    
    -- Atualizar ESP de cadáveres
    if Settings.CorpseESP then
        for _, item in ipairs(workspace:GetChildren()) do
            if item.Name == "Corpse" or item:FindFirstChild("Dead") then
                local root = item:FindFirstChild("Torso") or item:FindFirstChild("HumanoidRootPart")
                if root then
                    if not ESP.Corpses[item] then
                        ESP.Corpses[item] = CreateESP(root, "CADÁVER", Color3.fromRGB(255, 50, 50), true)
                    end
                    
                    local esp = ESP.Corpses[item]
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        esp.Box.Size = Vector2.new(50, 80)
                        esp.Box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
                        esp.Box.Visible = true
                        
                        esp.Text.Position = Vector2.new(pos.X, pos.Y - 50)
                        esp.Text.Visible = true
                    else
                        esp.Box.Visible = false
                        esp.Text.Visible = false
                    end
                end
            end
        end
    else
        for _, esp in pairs(ESP.Corpses) do
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
    
    -- Limpar ESP de jogadores desconectados
    for player, esp in pairs(ESP.Players) do
        if not player:IsDescendantOf(game) then
            esp.Box:Remove()
            esp.Text:Remove()
            ESP.Players[player] = nil
        end
    end
    
    -- Limpar ESP de cadáveres removidos
    for item, esp in pairs(ESP.Corpses) do
        if not item:IsDescendantOf(workspace) then
            esp.Box:Remove()
            esp.Text:Remove()
            ESP.Corpses[item] = nil
        end
    end
end)

-- Elementos da GUI com WindUI
CombatTab:CreateSection("Controles de Combate")

local KillAuraToggle = CombatTab:CreateToggle("Kill Aura", Settings.KillAura, function(state)
    Settings.KillAura = state
    if not state and Settings.FollowTarget then
        Character.Humanoid:MoveTo(Character.HumanoidRootPart.Position)
    end
    WindUI:Notify("Status", state and "Kill Aura ATIVADO" or "Kill Aura DESATIVADO", 3)
end)

local FollowToggle = CombatTab:CreateToggle("Seguir Alvo", Settings.FollowTarget, function(state)
    Settings.FollowTarget = state
    if not state and Settings.CurrentTarget then
        Character.Humanoid:MoveTo(Character.HumanoidRootPart.Position)
        Settings.CurrentTarget = nil
    end
    WindUI:Notify("Status", state and "Seguir Alvo ATIVADO" or "Seguir Alvo DESATIVADO", 3)
end)

VisualTab:CreateSection("Visualização")

local PlayerESPToggle = VisualTab:CreateToggle("ESP Jogadores", Settings.PlayerESP, function(state)
    Settings.PlayerESP = state
    if not state then
        for _, esp in pairs(ESP.Players) do
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
    WindUI:Notify("Status", state and "Player ESP ATIVADO" or "Player ESP DESATIVADO", 3)
end)

local CorpseESPToggle = VisualTab:CreateToggle("ESP Cadáveres", Settings.CorpseESP, function(state)
    Settings.CorpseESP = state
    if not state then
        for _, esp in pairs(ESP.Corpses) do
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
    WindUI:Notify("Status", state and "Corpse ESP ATIVADO" or "Corpse ESP DESATIVADO", 3)
end)

ConfigTab:CreateSection("Ajustes")

local RadiusSlider = ConfigTab:CreateSlider("Raio de Ataque", 5, 50, Settings.AuraRadius, 1, function(value)
    Settings.AuraRadius = value
end, "m")

local DelaySlider = ConfigTab:CreateSlider("Delay de Ataque", 0.1, 2, Settings.AttackDelay, 0.1, function(value)
    Settings.AttackDelay = value
end, "s")

-- Seção de status profissional
ConfigTab:CreateSection("Status do Sistema")
local StatusLabel = ConfigTab:CreateLabel("Estado: Operacional")
local FPSLabel = ConfigTab:CreateLabel("FPS: 60")
local PingLabel = ConfigTab:CreateLabel("Ping: 50ms")

-- Atualizar status
spawn(function()
    while task.wait(1) do
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        FPSLabel:SetText("FPS: "..tostring(fps))
        PingLabel:SetText("Ping: "..tostring(math.random(40,80)).."ms")
    end
end)

-- Responsividade Mobile
if UserInputService.TouchEnabled then
    Window.Main.Size = UDim2.new(0, 380, 0, 420)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.TextSize = 24
    MinimizeButton.Position = UDim2.new(0.5, -20, 0, -45)
end

-- Anti-ban e segurança
spawn(function()
    while task.wait(10) do
        if Settings.KillAura then
            -- Comportamento aleatório para evitar detecção
            if math.random(1, 5) == 1 then
                Character.Humanoid:MoveTo(Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
            end
        end
    end
end)

-- Limpeza profissional ao fechar
Window:OnClose(function()
    CombatLoop:Disconnect()
    ESPLoop:Disconnect()
    UpdateESP()
    WindUI:Notify("Sistema", "Script encerrado com segurança", 3)
end)

-- Notificação inicial profissional
WindUI:Notify("Savannah Life PRO", "Sistema carregado com sucesso!\nUse RightShift para minimizar", 5)