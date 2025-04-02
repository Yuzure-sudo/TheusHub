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
    Title.Parent = MainFrame