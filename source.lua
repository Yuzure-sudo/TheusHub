if game.CoreGui:FindFirstChild("TheusUI") then
    game.CoreGui:FindFirstChild("TheusUI"):Destroy()
end

local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- Interface Principal
local TheusUI = Instance.new("ScreenGui")
TheusUI.Name = "TheusUI"
TheusUI.Parent = game.CoreGui

-- Tela de Login
local LoginFrame = Instance.new("Frame")
LoginFrame.Name = "LoginFrame"
LoginFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
LoginFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
LoginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
LoginFrame.BorderSizePixel = 0
LoginFrame.Parent = TheusUI

-- Arredondar Bordas
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = LoginFrame

-- Efeito de Sombra
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
Shadow.Parent = LoginFrame

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0.3, 0, 0.3, 0)
Logo.Position = UDim2.new(0.35, 0, 0.1, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://12774664227" -- Substitua pelo ID da sua logo
Logo.Parent = LoginFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.15, 0)
Title.Position = UDim2.new(0, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Text = "THEUS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 30
Title.Font = Enum.Font.GothamBold
Title.Parent = LoginFrame

-- Campo de Key
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0.15, 0)
KeyBox.Position = UDim2.new(0.1, 0, 0.6, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
KeyBox.TextSize = 20
KeyBox.Font = Enum.Font.GothamSemibold
KeyBox.BorderSizePixel = 0
KeyBox.Parent = LoginFrame

-- Arredondar Bordas do KeyBox
local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyBox

-- Botão de Login
local LoginButton = Instance.new("TextButton")
LoginButton.Size = UDim2.new(0.8, 0, 0.15, 0)
LoginButton.Position = UDim2.new(0.1, 0, 0.8, 0)
LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LoginButton.Text = "LOGIN"
LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginButton.TextSize = 20
LoginButton.Font = Enum.Font.GothamBold
LoginButton.BorderSizePixel = 0
LoginButton.Parent = LoginFrame

-- Arredondar Bordas do Botão
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = LoginButton

-- Efeitos de Hover e Click
LoginButton.MouseEnter:Connect(function()
    TweenService:Create(LoginButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 100, 220)}):Play()
end)

LoginButton.MouseLeave:Connect(function()
    TweenService:Create(LoginButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
end)

-- Animação de Login
local function AnimateLogin()
    local originalPosition = LoginFrame.Position
    local originalSize = LoginFrame.Size
    
    LoginFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    LoginFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    wait(0.5)
    LoginFrame.Visible = false
end

-- Sistema de Login
LoginButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == "theusgostoso" then
        AnimateLogin()
        wait(0.5)
        -- Aqui vai começar a segunda parte do script (interface principal)
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Invalid Key!"
        TweenService:Create(KeyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
        wait(0.3)
        TweenService:Create(KeyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end
end)-- Interface Principal (aparece após o login)
local MainUI = Instance.new("Frame")
MainUI.Name = "MainUI"
MainUI.Size = UDim2.new(0.8, 0, 0.7, 0)
MainUI.Position = UDim2.new(0.1, 0, 0.15, 0)
MainUI.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainUI.BorderSizePixel = 0
MainUI.Visible = false
MainUI.Parent = TheusUI

-- Arredondar Bordas
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainUI

-- Sombra Principal
local MainShadow = Instance.new("ImageLabel")
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainShadow.Size = UDim2.new(1.1, 0, 1.1, 0)
MainShadow.ZIndex = -1
MainShadow.Image = "rbxassetid://1316045217"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.6
MainShadow.Parent = MainUI

-- Título Principal
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0.1, 0)
MainTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainTitle.Text = "THEUS HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 25
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainUI

-- Arredondar Título
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = MainTitle

-- Container de Funções
local FunctionContainer = Instance.new("ScrollingFrame")
FunctionContainer.Size = UDim2.new(0.95, 0, 0.85, 0)
FunctionContainer.Position = UDim2.new(0.025, 0, 0.13, 0)
FunctionContainer.BackgroundTransparency = 1
FunctionContainer.ScrollBarThickness = 4
FunctionContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
FunctionContainer.Parent = MainUI

-- Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = FunctionContainer

-- Função para criar toggles mobile-friendly
local function CreateToggle(text, value)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 60)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Toggle.BorderSizePixel = 0

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 15)
    ToggleCorner.Parent = Toggle

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 20
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.15, 0, 0.6, 0)
    Button.Position = UDim2.new(0.8, 0, 0.2, 0)
    Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Button.Text = ""
    Button.Parent = Toggle

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.5, 0)
    ButtonCorner.Parent = Button

    Toggle.Parent = FunctionContainer

    -- Efeito do Toggle
    Button.MouseButton1Click:Connect(function()
        _G[value] = not _G[value]
        TweenService:Create(Button, TweenInfo.new(0.3), {
            BackgroundColor3 = _G[value] and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
end

-- Função para criar seções
local function CreateSection(text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Section.Text = text
    Section.TextColor3 = Color3.fromRGB(255, 255, 255)
    Section.TextSize = 22
    Section.Font = Enum.Font.GothamBold

    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section

    Section.Parent = FunctionContainer
end

-- Criar Dropdown de Mobs para Mobile
local function CreateMobDropdown()
    local Dropdown = Instance.new("TextButton")
    Dropdown.Size = UDim2.new(1, 0, 0, 60)
    Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Dropdown.Text = "Selected: " .. _G.SelectedMob
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.TextSize = 20
    Dropdown.Font = Enum.Font.GothamSemibold

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 15)
    DropdownCorner.Parent = Dropdown

    Dropdown.Parent = FunctionContainer

    local Mobs = {
        "Nearest",
        "Bandit",
        "Monkey",
        "Gorilla",
        "Marine",
        "Chief Petty Officer",
        "Sky Bandit",
        "Dark Master"
    }
    
    Dropdown.MouseButton1Click:Connect(function()
        local current = table.find(Mobs, _G.SelectedMob)
        current = current and current + 1 or 1
        if current > #Mobs then current = 1 end
        _G.SelectedMob = Mobs[current]
        Dropdown.Text = "Selected: " .. _G.SelectedMob
    end)
end

-- Botão de Minimizar Mobile
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0.12, 0, 0.12, 0)
MinimizeButton.Position = UDim2.new(0.84, 0, 0.02, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeButton.Text = "-"
MinimizeButton.TextSize = 35
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = MainUI

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0.5, 0)
MinimizeCorner.Parent = MinimizeButton

-- Botão Flutuante (quando minimizado)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.new(0.15, 0, 0.08, 0)
FloatingButton.Position = UDim2.new(0.02, 0, 0.5, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
FloatingButton.Text = "T"
FloatingButton.TextSize = 30
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Visible = false
FloatingButton.Parent = TheusUI

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0.5, 0)
FloatingCorner.Parent = FloatingButton

-- Sistema de Minimização
MinimizeButton.MouseButton1Click:Connect(function()
    MainUI.Visible = false
    FloatingButton.Visible = true
end)

FloatingButton.MouseButton1Click:Connect(function()
    MainUI.Visible = true
    FloatingButton.Visible = false
end)

-- Implementar Interface
CreateSection("Main")
CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Fast Attack", "FastAttack")
CreateMobDropdown()

CreateSection("Combat")
CreateToggle("Kill Aura", "KillAura")

CreateSection("Fruits")
CreateToggle("Auto Fruit", "AutoFruit")

-- Ajustar ScrollingFrame
FunctionContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)

-- Mostrar Interface Principal após Login
LoginButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == "theusgostoso" then
        AnimateLogin()
        wait(0.5)
        MainUI.Visible = true
        -- Iniciar as funções de farm aqui
    end
end)

-- Notificação Mobile
local function CreateMobileNotification(text)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0.8, 0, 0.1, 0)
    Notification.Position = UDim2.new(0.1, 0, 0.85, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Notification.Parent = TheusUI

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 15)
    NotifCorner.Parent = Notification

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, 0, 1, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 20
    NotifText.Font = Enum.Font.GothamSemibold
    NotifText.Parent = Notification

    game:GetService("Debris"):AddItem(Notification, 2)
end

CreateMobileNotification("THEUS HUB Loaded!")