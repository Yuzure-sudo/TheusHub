-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configurações
local Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoSkill = false,
    NoClip = false,
    ChestFarm = false,
    AutoQuest = false,
    HitboxExpander = false,
    ESP = {
        Players = false,
        Mobs = false,
        Fruits = false,
        Chests = false
    },
    HitboxSize = 15,
    AttackSpeed = 0.01,
    FarmHeight = 25
}

-- Cores
local Colors = {
    Primary = Color3.fromRGB(30, 30, 35),
    Secondary = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(50, 255, 50),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Utilitários
local function createTween(object, info, properties)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

-- Sistema de ESP Aprimorado
local function createESP(object, espType)
    local ESP = Instance.new("BillboardGui")
    ESP.Size = UDim2.new(0, 200, 0, 50)
    ESP.AlwaysOnTop = true
    ESP.StudsOffset = Vector3.new(0, 2, 0)

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1, 0, 0.5, 0)
    Name.BackgroundTransparency = 1
    Name.TextColor3 = Colors.Text
    Name.TextStrokeTransparency = 0
    Name.TextSize = 14
    Name.Font = Enum.Font.GothamBold
    Name.Parent = ESP

    local Distance = Instance.new("TextLabel")
    Distance.Size = UDim2.new(1, 0, 0.5, 0)
    Distance.Position = UDim2.new(0, 0, 0.5, 0)
    Distance.BackgroundTransparency = 1
    Distance.TextColor3 = Colors.Text
    Distance.TextStrokeTransparency = 0
    Distance.TextSize = 12
    Distance.Font = Enum.Font.Gotham
    Distance.Parent = ESP

    -- ESP Line
    if espType == "Player" then
        local Line = Instance.new("LineHandleAdornment")
        Line.Color3 = Colors.Accent
        Line.Thickness = 1
        Line.ZIndex = 3
        Line.AlwaysOnTop = true
        Line.Transparency = 0.5
        Line.Parent = game.CoreGui

        RunService.RenderStepped:Connect(function()
            if Settings.ESP.Players and object.Character and Player.Character then
                Line.Visible = true
                Line.Length = (object.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                Line.CFrame = CFrame.new(
                    Player.Character.HumanoidRootPart.Position,
                    object.Character.HumanoidRootPart.Position
                )
            else
                Line.Visible = false
            end
        end)
    end

    RunService.RenderStepped:Connect(function()
        if object and object.Parent then
            local objectPos = (espType == "Player") and object.Character.HumanoidRootPart.Position or object:FindFirstChild("HumanoidRootPart").Position
            local distance = math.floor((objectPos - Player.Character.HumanoidRootPart.Position).Magnitude)
            
            Name.Text = (espType == "Player") and object.Name or object.Name
            Distance.Text = tostring(distance) .. " studs"
            
            ESP.Parent = (espType == "Player") and object.Character.Head or object:FindFirstChild("Head")
        else
            ESP:Destroy()
        end
    end)
end

-- Sistema de Hitbox Expandido
local function updateHitbox(mob)
    if mob:FindFirstChild("HumanoidRootPart") then
        mob.HumanoidRootPart.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
        mob.HumanoidRootPart.Transparency = 0.8
        mob.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
        mob.HumanoidRootPart.CanCollide = false
    end
end

-- Fast Attack Aprimorado
local function fastAttack()
    while Settings.FastAttack do
        local args = {
            [1] = "ComboChange",
            [2] = "M1"
        }
        game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
        game:GetService("RunService").Heartbeat:Wait()
    end
end

-- Auto Farm com Quest
local function getQuest()
    -- Implementar lógica de pegar quest baseado no nível do jogador
    local questNPC = workspace.QuestNPCs:FindFirstChild("QuestNPC")
    if questNPC then
        Player.Character.HumanoidRootPart.CFrame = questNPC.HumanoidRootPart.CFrame
        wait(0.5)
        fireproximityprompt(questNPC.ProximityPrompt)
    end
end

local function autoFarm()
    while Settings.AutoFarm do
        if Settings.AutoQuest then
            getQuest()
        end

        local nearestMob = nil
        local shortestDistance = math.huge

        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and 
               mob:FindFirstChild("HumanoidRootPart") and 
               mob.Humanoid.Health > 0 then
                
                if Settings.HitboxExpander then
                    updateHitbox(mob)
                end

                local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestMob = mob
                end
            end
        end

        if nearestMob then
            local targetPos = nearestMob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmHeight, 0)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            
            createTween(Player.Character.HumanoidRootPart, {0.2, Enum.EasingStyle.Linear}, {
                CFrame = CFrame.new(targetPos, nearestMob.HumanoidRootPart.Position)
            })

            if Settings.FastAttack then
                fastAttack()
            else
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
            end
        end
        wait()
    end
end

-- No Clip Aprimorado
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)-- Interface Aprimorada
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheusHubV2"
ScreenGui.Parent = game.CoreGui

-- Estilo Visual
local function applyGradient(frame)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    })
    gradient.Parent = frame
end

local function createShadow(frame)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://297774371"
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
end

-- Interface Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Colors.Primary
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

applyGradient(MainFrame)
createShadow(MainFrame)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Colors.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "THEUS HUB V2"
Title.TextColor3 = Colors.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

-- Container de Botões
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ScrollBarThickness = 2
ButtonContainer.ScrollBarImageColor3 = Colors.Accent
ButtonContainer.Parent = MainFrame

-- Função para criar botões estilizados
local function createStyledButton(text, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 45)
    Button.Position = position
    Button.BackgroundColor3 = Colors.Secondary
    Button.Text = text
    Button.TextColor3 = Colors.Text
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamSemibold
    Button.AutoButtonColor = false
    Button.Parent = ButtonContainer

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(0.95, -15, 0.5, -5)
    StatusDot.BackgroundColor3 = Colors.Error
    StatusDot.Parent = Button

    local UICornerDot = Instance.new("UICorner")
    UICornerDot.CornerRadius = UDim.new(1, 0)
    UICornerDot.Parent = StatusDot

    -- Efeitos de Hover
    Button.MouseEnter:Connect(function()
        createTween(Button, {0.3}, {BackgroundColor3 = Color3.fromRGB(55, 55, 60)})
    end)

    Button.MouseLeave:Connect(function()
        createTween(Button, {0.3}, {BackgroundColor3 = Colors.Secondary})
    end)

    return Button, StatusDot
end

-- Criação dos Botões
local buttonHeight = 55
local currentPosition = 0

local function createButton(text, setting)
    local button, status = createStyledButton(text, UDim2.new(0, 5, 0, currentPosition))
    
    button.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        createTween(status, {0.3}, {BackgroundColor3 = Settings[setting] and Colors.Success or Colors.Error})
        
        if setting == "AutoFarm" and Settings[setting] then
            coroutine.wrap(autoFarm)()
        elseif setting == "FastAttack" and Settings[setting] then
            coroutine.wrap(fastAttack)()
        end
    end)
    
    currentPosition = currentPosition + buttonHeight
    return button
end

-- Criação dos Botões ESP
local function createESPButton(text, espType)
    local button, status = createStyledButton(text, UDim2.new(0, 5, 0, currentPosition))
    
    button.MouseButton1Click:Connect(function()
        Settings.ESP[espType] = not Settings.ESP[espType]
        createTween(status, {0.3}, {BackgroundColor3 = Settings.ESP[espType] and Colors.Success or Colors.Error})
        
        if espType == "Players" then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player then
                    createESP(player, "Player")
                end
            end
        end
    end)
    
    currentPosition = currentPosition + buttonHeight
    return button
end

-- Botões Principais
createButton("Auto Farm", "AutoFarm")
createButton("Fast Attack", "FastAttack")
createButton("Auto Quest", "AutoQuest")
createButton("Hitbox Expander", "HitboxExpander")
createButton("No Clip", "NoClip")

-- Botões ESP
createESPButton("ESP Players", "Players")
createESPButton("ESP Mobs", "Mobs")
createESPButton("ESP Fruits", "Fruits")
createESPButton("ESP Chests", "Chests")

ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, currentPosition + 10)

-- Sistema de Key
local function createKeySystem()
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    KeyFrame.BackgroundColor3 = Colors.Primary
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = ScreenGui

    applyGradient(KeyFrame)
    createShadow(KeyFrame)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
    KeyInput.BackgroundColor3 = Colors.Secondary
    KeyInput.TextColor3 = Colors.Text
    KeyInput.TextSize = 18
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Text = ""
    KeyInput.Parent = KeyFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = KeyInput

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.8, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    SubmitButton.BackgroundColor3 = Colors.Accent
    SubmitButton.TextColor3 = Colors.Text
    SubmitButton.TextSize = 18
    SubmitButton.Text = "Submit"
    SubmitButton.Parent = KeyFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = SubmitButton

    SubmitButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "THEUSHUB" then
            KeyFrame:Destroy()
            MainFrame.Visible = true
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end
    end)

    MainFrame.Visible = false
end

-- Inicialização
createKeySystem()

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ESP para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if Settings.ESP.Players then
        createESP(player, "Player")
    end
end)

-- Atualização do ESP de Frutas
RunService.Heartbeat:Connect(function()
    if Settings.ESP.Fruits then
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
                createESP(fruit, "Fruit")
            end
        end
    end
end)