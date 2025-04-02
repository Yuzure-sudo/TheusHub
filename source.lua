-- Serviços Principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Configurações
local Settings = {
    Farm = {Active = false, Height = 25},
    Combat = {Fast = false, Skills = false},
    Misc = {Fruits = false, Bosses = false}
}

-- Interface Principal
local function CreateMainInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TheusHUB"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    -- Container das Opções
    local OptionsContainer = Instance.new("ScrollingFrame")
    OptionsContainer.Size = UDim2.new(1, -20, 1, -40)
    OptionsContainer.Position = UDim2.new(0, 10, 0, 35)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.ScrollBarThickness = 2
    OptionsContainer.Parent = MainFrame
    
    -- Layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = OptionsContainer
    
    -- Função para criar seções
    local function CreateSection(title)
        local Section = Instance.new("Frame")
        Section.Size = UDim2.new(1, 0, 0, 30)
        Section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Section.BorderSizePixel = 0
        Section.Parent = OptionsContainer
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Size = UDim2.new(1, 0, 1, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 14
        SectionTitle.Font = Enum.Font.GothamSemibold
        SectionTitle.Parent = Section
        
        return Section
    end
    
    -- Função para criar toggles
    local function CreateToggle(text, callback)
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
            Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
            callback(enabled)
        end)
    end
    
    -- Criar Seções e Toggles
    CreateSection("Farming")
    CreateToggle("Auto Farm", function(enabled)
        Settings.Farm.Active = enabled
        if enabled then
            -- Iniciar Farm
        end
    end)
    
    CreateToggle("Fast Attack", function(enabled)
        Settings.Combat.Fast = enabled
    end)
    
    CreateSection("Fruits")
    CreateToggle("Auto Collect Fruits", function(enabled)
        Settings.Misc.Fruits = enabled
    end)
    
    CreateToggle("Auto Store Fruits", function(enabled)
        -- Implementar
    end)
    
    CreateSection("Combat")
    CreateToggle("Auto Skills", function(enabled)
        Settings.Combat.Skills = enabled
    end)
    
    CreateToggle("Kill Aura", function(enabled)
        -- Implementar
    end)
    
    CreateSection("Teleports")
    local function CreateTeleportButton(text, position)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.Parent = OptionsContainer
        
        Button.MouseButton1Click:Connect(function()
            Character:SetPrimaryPartCFrame(CFrame.new(position))
        end)
    end
    
    CreateTeleportButton("First Island", Vector3.new(1000, 100, 1000))
    CreateTeleportButton("Second Island", Vector3.new(2000, 100, 2000))
    
    -- Ajustar tamanho do ScrollingFrame
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
    Title.Parent = MainFrame-- Continuação do Sistema de Login
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

    -- Sistema de Farm
    local FarmSystem = {
        running = false,
        
        getNearestMob = function()
            local nearest = {distance = math.huge, mob = nil}
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") 
                and mob.Humanoid.Health > 0 then
                    local distance = (Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if distance < nearest.distance then
                        nearest = {distance = distance, mob = mob}
                    end
                end
            end
            return nearest.mob
        end,

        attack = function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            
            if Settings.Combat.Fast then
                for i = 1, 3 do
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("ComboHit", "Melee")
                    task.wait(0.1)
                end
            end
        end,

        useSkills = function()
            if Settings.Combat.Skills then
                for _, key in pairs({"Z", "X", "C"}) do
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    wait(0.1)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                end
            end
        end,

        start = function()
            if FarmSystem.running then return end
            FarmSystem.running = true
            
            spawn(function()
                while Settings.Farm.Active and FarmSystem.running do
                    local mob = FarmSystem.getNearestMob()
                    if mob then
                        local targetCFrame = mob.HumanoidRootPart.CFrame * 
                            CFrame.new(0, Settings.Farm.Height, 0)
                        
                        Character.HumanoidRootPart.CFrame = targetCFrame
                        
                        FarmSystem.attack()
                        FarmSystem.useSkills()
                    end
                    task.wait()
                end
            end)
        end,

        stop = function()
            FarmSystem.running = false
        end
    }

    -- Sistema de Frutas
    local FruitSystem = {
        collectNearbyFruits = function()
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                    local distance = (Character.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                    if distance < 50 then
                        Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                        wait(0.2)
                    end
                end
            end
        end,

        storeFruit = function()
            local backpack = Player.Backpack
            for _, tool in pairs(backpack:GetChildren()) do
                if tool.Name:find("Fruit") then
                    Character.Humanoid:EquipTool(tool)
                    game:GetService("ReplicatedStorage").Remotes.StoreFruit:FireServer()
                    wait(0.5)
                end
            end
        end
    }

    -- Anti AFK
    local antiAFK = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        antiAFK:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        antiAFK:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)

    -- Sistema de Inicialização
    LoginButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "theusgostoso" then
            LoginGui:Destroy()
            CreateMainInterface()
            
            -- Iniciar sistemas automáticos
            spawn(function()
                while wait(1) do
                    if Settings.Misc.Fruits then
                        FruitSystem.collectNearbyFruits()
                        FruitSystem.storeFruit()
                    end
                end
            end)

            -- Notificação de sucesso
            local function CreateNotification(text)
                local Notification = Instance.new("Frame")
                Notification.Size = UDim2.new(0, 200, 0, 40)
                Notification.Position = UDim2.new(1, -220, 1, -60)
                Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                Notification.BorderSizePixel = 0
                Notification.Parent = game:GetService("CoreGui").TheusHUB
                
                local NotifText = Instance.new("TextLabel")
                NotifText.Size = UDim2.new(1, 0, 1, 0)
                NotifText.Text = text
                NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
                NotifText.TextSize = 14
                NotifText.Font = Enum.Font.Gotham
                NotifText.Parent = Notification
                
                game:GetService("TweenService"):Create(
                    Notification,
                    TweenInfo.new(0.5),
                    {Position = UDim2.new(1, -220, 1, -60)}
                ):Play()
                
                wait(2)
                
                game:GetService("TweenService"):Create(
                    Notification,
                    TweenInfo.new(0.5),
                    {Position = UDim2.new(1.5, 0, 1, -60)}
                ):Play()
                
                wait(0.5)
                Notification:Destroy()
            end
            
            CreateNotification("THEUS HUB carregado com sucesso!")
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Key Inválida!"
        end
    end)
end

-- Iniciar o script
CreateLoginUI()