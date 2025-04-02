-- Serviços Principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Configurações Expandidas
local Settings = {
    Farm = {
        Active = false,
        Height = 25,
        AutoQuest = false,
        MobSelected = "",
        BossSelected = "",
        Distance = 5
    },
    Combat = {
        Fast = false,
        Skills = false,
        AutoHaki = false,
        KillAura = false,
        GodMode = false
    },
    Misc = {
        Fruits = false,
        AutoStore = false,
        ChestFarm = false,
        AutoRaid = false,
        HopServer = false
    },
    Stats = {
        AutoStats = false,
        SelectedStat = "Melee"
    }
}

-- Interface Principal Atualizada
local function CreateMainInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TheusHUB"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Botão de Minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(0, 10, 0.5, -20)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MinimizeButton.Text = "T"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Visible = false
    MinimizeButton.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Botão Minimizar na Interface Principal
    local MinimizeMain = Instance.new("TextButton")
    MinimizeMain.Size = UDim2.new(0, 30, 0, 30)
    MinimizeMain.Position = UDim2.new(1, -35, 0, 5)
    MinimizeMain.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinimizeMain.Text = "-"
    MinimizeMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeMain.TextSize = 20
    MinimizeMain.Font = Enum.Font.GothamBold
    MinimizeMain.Parent = MainFrame
    
    -- Sistema de Minimização
    local minimized = false
    MinimizeMain.MouseButton1Click:Connect(function()
        minimized = true
        MainFrame.Visible = false
        MinimizeButton.Visible = true
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = false
        MainFrame.Visible = true
        MinimizeButton.Visible = false
    end)
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    -- Container das Opções
    local OptionsContainer = Instance.new("ScrollingFrame")
    OptionsContainer.Size = UDim2.new(1, -20, 1, -50)
    OptionsContainer.Position = UDim2.new(0, 10, 0, 45)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.ScrollBarThickness = 2
    OptionsContainer.Parent = MainFrame
    
    -- Layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = OptionsContainer

    -- Funções Corrigidas e Otimizadas
    local function GetNearestMob()
        local nearest = {distance = math.huge, mob = nil}
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") 
            and mob.Humanoid.Health > 0 then
                if Settings.Farm.MobSelected ~= "" and mob.Name ~= Settings.Farm.MobSelected then
                    continue
                end
                local distance = (Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                if distance < nearest.distance then
                    nearest = {distance = distance, mob = mob}
                end
            end
        end
        return nearest.mob
    end

    local function Attack()
        if not Settings.Combat.Fast then return end
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        
        local args = {
            [1] = "ComboHit",
            [2] = "Melee"
        }
        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
    end

    local function UseSkills()
        if not Settings.Combat.Skills then return end
        local skills = {"Z", "X", "C", "V", "F"}
        for _, skill in ipairs(skills) do
            game:GetService("VirtualInput"):SendKeyEvent(true, skill, false, game)
            wait(0.1)
            game:GetService("VirtualInput"):SendKeyEvent(false, skill, false, game)
            wait(0.5)
        end
    end

    local function AutoHaki()
        if not Settings.Combat.AutoHaki then return end
        if not Player.Character:FindFirstChild("HasBuso") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end
    end

    local function TeleportTo(position)
        Character.HumanoidRootPart.CFrame = position
    end    -- Implementação das Funções de Farm
    local function StartFarm()
        spawn(function()
            while Settings.Farm.Active do
                if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                    local mob = GetNearestMob()
                    if mob then
                        local targetCFrame = mob.HumanoidRootPart.CFrame * 
                            CFrame.new(0, Settings.Farm.Height, Settings.Farm.Distance)
                        
                        TeleportTo(targetCFrame)
                        Attack()
                        UseSkills()
                        AutoHaki()
                    end
                end
                wait()
            end
        end)
    end

    -- Sistema de Frutas Aprimorado
    local function FruitManager()
        spawn(function()
            while Settings.Misc.Fruits do
                -- Coleta de Frutas
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                        TeleportTo(fruit.Handle.CFrame)
                        wait(0.2)
                    end
                end
                
                -- Armazenamento Automático
                if Settings.Misc.AutoStore then
                    for _, tool in pairs(Player.Backpack:GetChildren()) do
                        if tool.Name:find("Fruit") then
                            Character.Humanoid:EquipTool(tool)
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                            wait(0.5)
                        end
                    end
                end
                wait(1)
            end
        end)
    end

    -- Sistema de Raid Automático
    local function AutoRaid()
        spawn(function()
            while Settings.Misc.AutoRaid do
                if not workspace:FindFirstChild("RaidMap") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNow")
                    wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyChip", "Flame")
                    wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartRaid", "Flame")
                else
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") 
                        and v.Humanoid.Health > 0 then
                            repeat
                                TeleportTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                                Attack()
                                UseSkills()
                                wait()
                            until not v or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0
                        end
                    end
                end
                wait()
            end
        end)
    end

    -- Sistema de Farm de Baús
    local function ChestFarm()
        spawn(function()
            while Settings.Misc.ChestFarm do
                for _, chest in pairs(workspace:GetChildren()) do
                    if chest.Name:find("Chest") then
                        TeleportTo(chest.CFrame)
                        wait(0.5)
                    end
                end
                wait(1)
            end
        end)
    end

    -- Sistema de Stats Automático
    local function AutoStats()
        spawn(function()
            while Settings.Stats.AutoStats do
                local args = {
                    [1] = "AddPoint",
                    [2] = Settings.Stats.SelectedStat,
                    [3] = 1
                }
                ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                wait(0.1)
            end
        end)
    end

    -- Criação dos Toggles e Botões
    local function CreateToggle(text, setting, parentSetting, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, 0, 0, 35)
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Toggle.BorderSizePixel = 0
        Toggle.Parent = OptionsContainer

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 20, 0, 20)
        Button.Position = UDim2.new(0, 10, 0.5, -10)
        Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Button.Text = ""
        Button.Parent = Toggle

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 40, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.Parent = Toggle

        local enabled = false
        Button.MouseButton1Click:Connect(function()
            enabled = not enabled
            Settings[parentSetting][setting] = enabled
            Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
            if callback then callback(enabled) end
        end)
    end

    -- Criação das Seções e Toggles
    local function CreateSection(text)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, 0, 0, 30)
        Section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Section.Text = text
        Section.TextColor3 = Color3.fromRGB(255, 255, 255)
        Section.TextSize = 16
        Section.Font = Enum.Font.GothamBold
        Section.Parent = OptionsContainer
    end

    -- Implementação da Interface
    CreateSection("Farming")
    CreateToggle("Auto Farm", "Active", "Farm", StartFarm)
    CreateToggle("Auto Quest", "AutoQuest", "Farm")
    
    CreateSection("Combat")
    CreateToggle("Fast Attack", "Fast", "Combat")
    CreateToggle("Auto Skills", "Skills", "Combat")
    CreateToggle("Auto Haki", "AutoHaki", "Combat")
    CreateToggle("God Mode", "GodMode", "Combat")
    
    CreateSection("Fruits")
    CreateToggle("Auto Collect Fruits", "Fruits", "Misc", FruitManager)
    CreateToggle("Auto Store Fruits", "AutoStore", "Misc")
    
    CreateSection("Misc")
    CreateToggle("Chest Farm", "ChestFarm", "Misc", ChestFarm)
    CreateToggle("Auto Raid", "AutoRaid", "Misc", AutoRaid)
    CreateToggle("Auto Stats", "AutoStats", "Stats", AutoStats)

    -- Atualização do Canvas
    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Sistema de Login
local function CreateLoginUI()
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "TheusLogin"
    LoginGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = LoginGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "Insira sua Key"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    KeyInput.BorderSizePixel = 0
    KeyInput.Parent = MainFrame

    local LoginButton = Instance.new("TextButton")
    LoginButton.Size = UDim2.new(0.8, 0, 0, 35)
    LoginButton.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginButton.Text = "Login"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    LoginButton.BorderSizePixel = 0
    LoginButton.Parent = MainFrame

    LoginButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "theusgostoso" then
            LoginGui:Destroy()
            CreateMainInterface()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Key Inválida!"
        end
    end)
end

-- Iniciar o Script
CreateLoginUI()