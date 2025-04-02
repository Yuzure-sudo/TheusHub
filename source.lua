-- Configurações Iniciais
if game.CoreGui:FindFirstChild("TheusHUB") then
    game.CoreGui:FindFirstChild("TheusHUB"):Destroy()
end

-- Variáveis e Serviços
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configurações Globais
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoQuest = false,
    KillAura = false,
    AutoFruit = false,
    BringMob = false,
    AutoRaid = false,
    SelectedMob = "Bandit",
    WebhookURL = "",
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Foreground = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Interface Principal
local TheusHUB = Instance.new("ScreenGui")
TheusHUB.Name = "TheusHUB"
TheusHUB.Parent = game.CoreGui

-- Container de Login
local LoginContainer = Instance.new("Frame")
LoginContainer.Name = "LoginContainer"
LoginContainer.Size = UDim2.new(0.8, 0, 0.6, 0)
LoginContainer.Position = UDim2.new(0.1, 0, 0.2, 0)
LoginContainer.BackgroundColor3 = Settings.Theme.Background
LoginContainer.BorderSizePixel = 0
LoginContainer.Parent = TheusHUB

-- Efeitos de UI
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = LoginContainer

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.Parent = LoginContainer

-- Logo Container
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(1, 0, 0.4, 0)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Parent = LoginContainer

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0.3, 0, 0.8, 0)
Logo.Position = UDim2.new(0.35, 0, 0.1, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://12774664227"
Logo.Parent = LogoContainer

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Text = "THEUS HUB"
Title.TextColor3 = Settings.Theme.Text
Title.TextSize = 35
Title.Font = Enum.Font.GothamBold
Title.Parent = LoginContainer

-- Campo de Key
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0.12, 0)
KeyBox.Position = UDim2.new(0.1, 0, 0.6, 0)
KeyBox.BackgroundColor3 = Settings.Theme.Foreground
KeyBox.TextColor3 = Settings.Theme.Text
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
KeyBox.TextSize = 22
KeyBox.Font = Enum.Font.GothamSemibold
KeyBox.BorderSizePixel = 0
KeyBox.Parent = LoginContainer

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyBox

-- Botão de Login
local LoginButton = Instance.new("TextButton")
LoginButton.Size = UDim2.new(0.8, 0, 0.12, 0)
LoginButton.Position = UDim2.new(0.1, 0, 0.8, 0)
LoginButton.BackgroundColor3 = Settings.Theme.Accent
LoginButton.Text = "LOGIN"
LoginButton.TextColor3 = Settings.Theme.Text
LoginButton.TextSize = 22
LoginButton.Font = Enum.Font.GothamBold
LoginButton.BorderSizePixel = 0
LoginButton.Parent = LoginContainer

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 10)
LoginCorner.Parent = LoginButton

-- Sistema de Carregamento
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0.8, 0, 0.12, 0)
LoadingFrame.Position = UDim2.new(0.1, 0, 0.8, 0)
LoadingFrame.BackgroundColor3 = Settings.Theme.Accent
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Visible = false
LoadingFrame.Parent = LoginContainer

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 10)
LoadingCorner.Parent = LoadingFrame

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingFrame

local LoadingBarCorner = Instance.new("UICorner")
LoadingBarCorner.CornerRadius = UDim.new(0, 10)
LoadingBarCorner.Parent = LoadingBar-- Sistema de Login
local function CreateLoadingAnimation()
    LoginButton.Visible = false
    LoadingFrame.Visible = true
    
    local LoadingTween = TweenService:Create(LoadingBar, 
        TweenInfo.new(2, Enum.EasingStyle.Linear), 
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    LoadingTween:Play()
    
    LoadingTween.Completed:Wait()
    LoginContainer:Destroy()
end

-- Função de Notificação
local function CreateNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0.3, 0, 0.1, 0)
    Notification.Position = UDim2.new(0.35, 0, -0.2, 0)
    Notification.BackgroundColor3 = Settings.Theme.Foreground
    Notification.BorderSizePixel = 0
    Notification.Parent = TheusHUB
    
    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 10)
    NotificationCorner.Parent = Notification
    
    local NotificationText = Instance.new("TextLabel")
    NotificationText.Size = UDim2.new(1, 0, 1, 0)
    NotificationText.BackgroundTransparency = 1
    NotificationText.Text = text
    NotificationText.TextColor3 = Settings.Theme.Text
    NotificationText.TextSize = 18
    NotificationText.Font = Enum.Font.GothamSemibold
    NotificationText.Parent = Notification
    
    local ShowTween = TweenService:Create(Notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.35, 0, 0.05, 0)}
    )
    ShowTween:Play()
    
    wait(duration)
    
    local HideTween = TweenService:Create(Notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = UDim2.new(0.35, 0, -0.2, 0)}
    )
    HideTween:Play()
    HideTween.Completed:Connect(function()
        Notification:Destroy()
    end)
end

-- Sistema de Verificação de Key
LoginButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == "RELEASE" then
        CreateLoadingAnimation()
        CreateNotification("Login successful!", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TheusFM/TheusHub/main/Main.lua"))()
    else
        CreateNotification("Invalid key!", 3)
        KeyBox.Text = ""
    end
end)

-- Variáveis e Funções Principais
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Fast Attack Fix
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalue(CombatFramework.initialize, 1)
local CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)

spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if Settings.FastAttack then
            pcall(function()
                CameraShakerR:Stop()
                CombatFrameworkR.activeController.attacking = false
                CombatFrameworkR.activeController.timeToNextAttack = 0
                CombatFrameworkR.activeController.increment = 3
                CombatFrameworkR.activeController.hitboxMagnitude = 100
            end)
        end
    end)
end)

-- Auto Attack
spawn(function()
    while wait(.1) do
        if Settings.FastAttack then
            pcall(function()
                local AC = CombatFrameworkR.activeController
                for i = 1, 1 do 
                    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
                        Player.Character,
                        {Player.Character.HumanoidRootPart},
                        60
                    )
                    local cac = {}
                    local hash = {}
                    for k, v in pairs(bladehit) do
                        if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                            table.insert(cac, v.Parent.HumanoidRootPart)
                            hash[v.Parent] = true
                        end
                    end
                    bladehit = cac
                    if #bladehit > 0 then
                        local u8 = debug.getupvalue(AC.attack, 5)
                        local u9 = debug.getupvalue(AC.attack, 6)
                        local u7 = debug.getupvalue(AC.attack, 4)
                        local u10 = debug.getupvalue(AC.attack, 7)
                        local u12 = (u8 * 798405 + u7 * 727595) % u9
                        local u13 = u7 * 798405
                        (function()
                            u12 = (u12 * u9 + u13) % 1099511627776
                            u8 = math.floor(u12 / u9)
                            u7 = u12 - u8 * u9
                        end)()
                        u10 = u10 + 1
                        debug.setupvalue(AC.attack, 5, u8)
                        debug.setupvalue(AC.attack, 6, u9)
                        debug.setupvalue(AC.attack, 4, u7)
                        debug.setupvalue(AC.attack, 7, u10)
                        for k, v in pairs(AC.animator.anims.basic) do
                            v:Play(0.01,0.01,0.01)
                        end                 
                        if Player.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then 
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
                            game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, i, "")
                        end
                    end
                end
            end)
        end
    end
end)

-- Quest System
local function GetQuest()
    local Levels = {
        {Name = "Bandit", Level = 1, Quest = "BanditQuest1"},
        {Name = "Monkey", Level = 15, Quest = "MonkeyQuest1"},
        {Name = "Gorilla", Level = 30, Quest = "GorillaQuest1"},
        {Name = "Marine", Level = 45, Quest = "MarineQuest1"},
        {Name = "Chief Petty Officer", Level = 60, Quest = "ChiefQuest"}
    }
    
    local PlayerLevel = Player.Data.Level.Value
    local QuestToGet = nil
    
    for i, v in pairs(Levels) do
        if PlayerLevel >= v.Level then
            QuestToGet = v
        end
    end
    
    if QuestToGet then
        if Player.PlayerGui.Main.Quest.Visible == false then
            local args = {
                [1] = "StartQuest",
                [2] = QuestToGet.Quest,
                [3] = QuestToGet.Level
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        end
        return QuestToGet.Name
    end
    return nil
end

-- Get Nearest Monster
local function GetNearestMob(Quest)
    local Nearest = nil
    local MinDistance = math.huge
    
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 then
            if Quest and Mob.Name ~= Quest then continue end
            
            local Distance = (HumanoidRootPart.Position - Mob.HumanoidRootPart.Position).Magnitude
            if Distance < MinDistance then
                MinDistance = Distance
                Nearest = Mob
            end
        end
    end
    return Nearest
end

-- Auto Farm System
spawn(function()
    while wait() do
        if Settings.AutoFarm then
            pcall(function()
                local QuestMob = GetQuest()
                if QuestMob then
                    local Mob = GetNearestMob(QuestMob)
                    if Mob then
                        Humanoid:ChangeState(11)
                        HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        
                        if Settings.FastAttack then
                            local AC = CombatFrameworkR.activeController
                            if AC and AC.equipped then
                                for i = 1, 1 do 
                                    AC:attack()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- No Clip
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if Settings.AutoFarm then
            pcall(function()
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end)
end)

-- Auto Haki
spawn(function()
    while wait(1) do
        if Settings.AutoFarm then
            if not Player.Character:FindFirstChild("HasBuso") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
        end
    end
end)

-- Sistema de Webhook
local function SendWebhook(Message)
    if Settings.WebhookURL ~= "" then
        pcall(function()
            local Data = {
                ["content"] = Message
            }
            local Headers = {
                ["content-type"] = "application/json"
            }
            request({
                Url = Settings.WebhookURL,
                Method = "POST",
                Headers = Headers,
                Body = game:GetService("HttpService"):JSONEncode(Data)
            })
        end)
    end
end

-- Auto Save
spawn(function()
    while wait(30) do
        SaveSettings()
    end
end)

CreateNotification("Script loaded successfully!", 3)