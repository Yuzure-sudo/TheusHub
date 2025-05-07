-- Configuração Inicial
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tela de Carregamento
local LoadingScreen = Instance.new("ScreenGui")
local LoadingFrame = Instance.new("Frame")
local LoadingBar = Instance.new("Frame")
local LoadingText = Instance.new("TextLabel")
local Logo = Instance.new("ImageLabel")

LoadingScreen.Name = "LoadingScreen"
LoadingScreen.Parent = game.CoreGui

LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = LoadingScreen
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)

Logo.Name = "Logo"
Logo.Parent = LoadingFrame
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -100, 0.4, -100)
Logo.Size = UDim2.new(0, 200, 0, 200)
Logo.Image = "rbxassetid://7743878358"

LoadingBar.Name = "LoadingBar"
LoadingBar.Parent = LoadingFrame
LoadingBar.BackgroundColor3 = Color3.fromRGB(45, 180, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Position = UDim2.new(0.3, 0, 0.6, 0)
LoadingBar.Size = UDim2.new(0, 0, 0, 5)

LoadingText.Name = "LoadingText"
LoadingText.Parent = LoadingFrame
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
    Name = "Ultimate Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UltimateConfig",
    IntroEnabled = true,
    IntroText = "Ultimate Hub"
})

-- Tabs
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AvatarTab = Window:MakeTab({
    Name = "Avatar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Funções
local function CopyCharacter(targetPlayer)
    local character = targetPlayer.Character
    if character then
        -- Copiar aparência
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            local targetHumanoid = character:FindFirstChild("Humanoid")
            if targetHumanoid then
                humanoid:Clone():Destroy()
                local newHumanoid = targetHumanoid:Clone()
                newHumanoid.Parent = LocalPlayer.Character
            end
        end
        
        -- Copiar acessórios
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local clone = accessory:Clone()
                clone.Parent = LocalPlayer.Character
            end
        end
    end
end

-- Player Tab
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(45, 180, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(45, 180, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- Combat Tab
local function KillPlayer(player)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

CombatTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = {},
    Callback = function(Value)
        _G.SelectedPlayer = Value
    end    
})

CombatTab:AddButton({
    Name = "Kill Selected Player",
    Callback = function()
        if _G.SelectedPlayer then
            local player = Players:FindFirstChild(_G.SelectedPlayer)
            if player then
                KillPlayer(player)
            end
        end
    end    
})

-- Misc Tab
MiscTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJump = Value
        game:GetService("UserInputService").JumpRequest:connect(function()
            if _G.InfiniteJump then
                LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end    
})

MiscTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(Value)
        _G.NoClip = Value
        game:GetService('RunService').Stepped:connect(function()
            if _G.NoClip then
                LocalPlayer.Character.Humanoid:ChangeState(11)
            end
        end)
    end    
})

-- Avatar Tab
local playerList = {}
for _, player in pairs(Players:GetPlayers()) do
    table.insert(playerList, player.Name)
end

AvatarTab:AddDropdown({
    Name = "Select Player to Copy",
    Default = "",
    Options = playerList,
    Callback = function(Value)
        local player = Players:FindFirstChild(Value)
        if player then
            CopyCharacter(player)
        end
    end    
})

-- Atualizar lista de jogadores
Players.PlayerAdded:Connect(function(player)
    table.insert(playerList, player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerList) do
        if name == player.Name then
            table.remove(playerList, i)
            break
        end
    end
end)

-- Notificações
OrionLib:MakeNotification({
    Name = "Ultimate Hub",
    Content = "Script carregado com sucesso!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Iniciar animação de carregamento
LoadAnimation()

-- Configurações de UI Mobile
if game:GetService("UserInputService").TouchEnabled then
    -- Ajustes específicos para mobile
    Window.Size = UDim2.new(0, 300, 0, 400)
end