-- Configurações Iniciais
if game.CoreGui:FindFirstChild("TheusHUB") then
    game.CoreGui:FindFirstChild("TheusHUB"):Destroy()
end

-- Variáveis e Serviços
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
Logo.Image = "rbxassetid://12774664227" -- Substitua pelo ID da sua logo
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
LoadingBarCorner.Parent = LoadingBar

-- Sistema de Notificação
local function CreateNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0.8, 0, 0.1, 0)
    Notification.Position = UDim2.new(0.1, 0, 0.85, 0)
    Notification.BackgroundColor3 = Settings.Theme.Foreground
    Notification.BorderSizePixel = 0
    Notification.Parent = TheusHUB

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notification

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, 0, 1, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Settings.Theme.Text
    NotifText.TextSize = 20
    NotifText.Font = Enum.Font.GothamSemibold
    NotifText.Parent = Notification

    TweenService:Create(Notification, TweenInfo.new(0.5), {
        Position = UDim2.new(0.1, 0, 0.8, 0)
    }):Play()

    game:GetService("Debris"):AddItem(Notification, duration or 2)
end

-- Animação de Login
local function AnimateLogin()
    LoginButton.Visible = false
    LoadingFrame.Visible = true
    
    local Tween = TweenService:Create(LoadingBar, TweenInfo.new(1), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    Tween:Play()
    
    Tween.Completed:Wait()
    LoadingFrame.Visible = false
    
    TweenService:Create(LoginContainer, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    wait(0.5)
    LoginContainer:Destroy()
end

-- Sistema de Login
LoginButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == "theusgostoso" then
        CreateNotification("Login Successful!", 2)
        AnimateLogin()
        wait(1)
        -- Aqui será chamada a Parte 2 do script
    else
        CreateNotification("Invalid Key!", 2)
        TweenService:Create(KeyBox, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        }):Play()
        wait(0.3)
        TweenService:Create(KeyBox, TweenInfo.new(0.3), {
            BackgroundColor3 = Settings.Theme.Foreground
        }):Play()
    end
end)

-- Efeitos de Hover
LoginButton.MouseEnter:Connect(function()
    TweenService:Create(LoginButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(0, 100, 220)
    }):Play()
end)

LoginButton.MouseLeave:Connect(function()
    TweenService:Create(LoginButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Settings.Theme.Accent
    }):Play()
end)-- Interface Principal (MainUI)
local MainUI = Instance.new("Frame")
MainUI.Name = "MainUI"
MainUI.Size = UDim2.new(0.8, 0, 0.8, 0)
MainUI.Position = UDim2.new(0.1, 0, 0.1, 0)
MainUI.BackgroundColor3 = Settings.Theme.Background
MainUI.BorderSizePixel = 0
MainUI.Parent = TheusHUB

-- Efeitos UI Principal
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainUI

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

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0.12, 0)
TopBar.BackgroundColor3 = Settings.Theme.Foreground
TopBar.BorderSizePixel = 0
TopBar.Parent = MainUI

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 20)
TopBarCorner.Parent = TopBar

-- Título do Hub
local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0.3, 0, 1, 0)
HubTitle.Position = UDim2.new(0.35, 0, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "THEUS HUB"
HubTitle.TextColor3 = Settings.Theme.Text
HubTitle.TextSize = 25
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Parent = TopBar

-- Botão de Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0.1, 0, 0.8, 0)
MinimizeButton.Position = UDim2.new(0.88, 0, 0.1, 0)
MinimizeButton.BackgroundColor3 = Settings.Theme.Accent
MinimizeButton.Text = "-"
MinimizeButton.TextSize = 30
MinimizeButton.TextColor3 = Settings.Theme.Text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0.3, 0)
MinimizeCorner.Parent = MinimizeButton

-- Barra Lateral
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0.25, 0, 0.87, 0)
SideBar.Position = UDim2.new(0, 0, 0.13, 0)
SideBar.BackgroundColor3 = Settings.Theme.Foreground
SideBar.BorderSizePixel = 0
SideBar.Parent = MainUI

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(0, 20)
SideBarCorner.Parent = SideBar

-- Container de Tabs
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = SideBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 10)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = TabContainer

-- Container Principal
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0.74, 0, 0.87, 0)
MainContainer.Position = UDim2.new(0.26, 0, 0.13, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = MainUI

-- Função para criar Tabs
local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 45)
    TabButton.BackgroundColor3 = Settings.Theme.Background
    TabButton.Text = name
    TabButton.TextColor3 = Settings.Theme.Text
    TabButton.TextSize = 18
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0.2, 0)
    TabCorner.Parent = TabButton
    
    local IconImage = Instance.new("ImageLabel")
    IconImage.Size = UDim2.new(0.2, 0, 0.7, 0)
    IconImage.Position = UDim2.new(0.05, 0, 0.15, 0)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = icon
    IconImage.Parent = TabButton
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 4
    TabPage.Visible = false
    TabPage.Parent = MainContainer
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = TabPage
    
    TabButton.MouseButton1Click:Connect(function()
        for _, page in pairs(MainContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.Visible = false
            end
        end
        TabPage.Visible = true
        
        for _, button in pairs(TabContainer:GetChildren()) do
            if button:IsA("TextButton") then
                TweenService:Create(button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Settings.Theme.Background
                }):Play()
            end
        end
        
        TweenService:Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Settings.Theme.Accent
        }):Play()
    end)
    
    return TabPage
end

-- Função para criar Seção
local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(0.95, 0, 0, 35)
    Section.BackgroundColor3 = Settings.Theme.Foreground
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0.2, 0)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Settings.Theme.Text
    SectionTitle.TextSize = 18
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Parent = Section
end

-- Criação das Tabs
local MainTab = CreateTab("Main", "rbxassetid://6034509993")
local FarmTab = CreateTab("Farm", "rbxassetid://6034509993")
local CombatTab = CreateTab("Combat", "rbxassetid://6034509993")
local TeleportTab = CreateTab("Teleport", "rbxassetid://6034509993")
local MiscTab = CreateTab("Misc", "rbxassetid://6034509993")

-- Botão Flutuante (quando minimizado)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.new(0.15, 0, 0.08, 0)
FloatingButton.Position = UDim2.new(0.02, 0, 0.5, 0)
FloatingButton.BackgroundColor3 = Settings.Theme.Accent
FloatingButton.Text = "T"
FloatingButton.TextSize = 30
FloatingButton.TextColor3 = Settings.Theme.Text
FloatingButton.Visible = false
FloatingButton.Parent = TheusHUB

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
end)-- Funções de Criação de Elementos
local function CreateToggle(parent, text, value)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 50)
    ToggleFrame.BackgroundColor3 = Settings.Theme.Foreground
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.1, 0, 0.7, 0)
    ToggleButton.Position = UDim2.new(0.87, 0, 0.15, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(0.5, 0)
    ToggleButtonCorner.Parent = ToggleButton

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(0.8, 0, 1, 0)
    ToggleText.Position = UDim2.new(0.05, 0, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = text
    ToggleText.TextColor3 = Settings.Theme.Text
    ToggleText.TextSize = 18
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    ToggleButton.MouseButton1Click:Connect(function()
        Settings[value] = not Settings[value]
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Settings[value] and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
end

local function CreateSlider(parent, text, min, max, default, value)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.95, 0, 0, 70)
    SliderFrame.BackgroundColor3 = Settings.Theme.Foreground
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame

    local SliderText = Instance.new("TextLabel")
    SliderText.Size = UDim2.new(0.9, 0, 0.4, 0)
    SliderText.Position = UDim2.new(0.05, 0, 0.1, 0)
    SliderText.BackgroundTransparency = 1
    SliderText.Text = text
    SliderText.TextColor3 = Settings.Theme.Text
    SliderText.TextSize = 18
    SliderText.Font = Enum.Font.GothamSemibold
    SliderText.TextXAlignment = Enum.TextXAlignment.Left
    SliderText.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.9, 0, 0.1, 0)
    SliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
    SliderBar.BackgroundColor3 = Settings.Theme.Background
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0.5, 0)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Settings.Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0.5, 0)
    SliderFillCorner.Parent = SliderFill

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(0.1, 0, 0.4, 0)
    ValueText.Position = UDim2.new(0.85, 0, 0.1, 0)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = tostring(default)
    ValueText.TextColor3 = Settings.Theme.Text
    ValueText.TextSize = 18
    ValueText.Font = Enum.Font.GothamSemibold
    ValueText.Parent = SliderFrame

    local IsDragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local AbsolutePosition = SliderBar.AbsolutePosition
            local AbsoluteSize = SliderBar.AbsoluteSize
            local Position = math.clamp((input.Position.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)
            local Value = math.floor(min + (max - min) * Position)
            
            Settings[value] = Value
            ValueText.Text = tostring(Value)
            TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                Size = UDim2.new(Position, 0, 1, 0)
            }):Play()
        end
    end)
end

local function CreateDropdown(parent, text, options, value)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(0.95, 0, 0, 50)
    DropdownFrame.BackgroundColor3 = Settings.Theme.Foreground
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 10)
    DropdownCorner.Parent = DropdownFrame

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = text .. ": " .. Settings[value]
    DropdownButton.TextColor3 = Settings.Theme.Text
    DropdownButton.TextSize = 18
    DropdownButton.Font = Enum.Font.GothamSemibold
    DropdownButton.Parent = DropdownFrame

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 40)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
    OptionsFrame.BackgroundColor3 = Settings.Theme.Foreground
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 2
    OptionsFrame.Parent = DropdownFrame

    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 10)
    OptionsCorner.Parent = OptionsFrame

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 40)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = Settings.Theme.Text
        OptionButton.TextSize = 16
        OptionButton.Font = Enum.Font.GothamSemibold
        OptionButton.ZIndex = 2
        OptionButton.Parent = OptionsFrame

        OptionButton.MouseButton1Click:Connect(function()
            Settings[value] = option
            DropdownButton.Text = text .. ": " .. option
            OptionsFrame.Visible = false
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)
end

-- Preenchendo as Tabs
-- Main Tab
CreateSection(MainTab, "Main Functions")
CreateToggle(MainTab, "Auto Farm", "AutoFarm")
CreateToggle(MainTab, "Fast Attack", "FastAttack")
CreateDropdown(MainTab, "Selected Mob", {
    "Nearest",
    "Bandit",
    "Monkey",
    "Gorilla",
    "Marine",
    "Chief Petty Officer"
}, "SelectedMob")
CreateSlider(MainTab, "Farm Distance", 0, 100, 50, "FarmDistance")

-- Farm Tab
CreateSection(FarmTab, "Farming Options")
CreateToggle(FarmTab, "Auto Quest", "AutoQuest")
CreateToggle(FarmTab, "Bring Mob", "BringMob")
CreateToggle(FarmTab, "Auto Raid", "AutoRaid")
CreateSlider(FarmTab, "Farm Speed", 1, 10, 5, "FarmSpeed")

-- Combat Tab
CreateSection(CombatTab, "Combat Settings")
CreateToggle(CombatTab, "Kill Aura", "KillAura")
CreateToggle(CombatTab, "Auto Block", "AutoBlock")
CreateSlider(CombatTab, "Kill Aura Range", 0, 100, 50, "KillAuraRange")

-- Teleport Tab
CreateSection(TeleportTab, "Locations")
CreateDropdown(TeleportTab, "Select Island", {
    "Starter Island",
    "Marine Island",
    "Desert Island",
    "Snow Island",
    "Sky Island"
}, "SelectedIsland")

-- Misc Tab
CreateSection(MiscTab, "Miscellaneous")
CreateToggle(MiscTab, "Auto Fruit", "AutoFruit")
CreateToggle(MiscTab, "Hide Name", "HideName")
CreateToggle(MiscTab, "Walk on Water", "WalkOnWater")-- Variáveis e Funções Principais
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Sistema Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Funções de Utilidade
local function GetNearestMob()
    local Nearest = nil
    local MinDistance = math.huge
    
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 then
            if Settings.SelectedMob ~= "Nearest" and Mob.Name ~= Settings.SelectedMob then continue end
            
            local Distance = (HumanoidRootPart.Position - Mob.HumanoidRootPart.Position).Magnitude
            if Distance < MinDistance then
                MinDistance = Distance
                Nearest = Mob
            end
        end
    end
    return Nearest
end

local function GetQuest()
    local QuestNPCs = workspace.NPCs:GetChildren()
    for _, NPC in pairs(QuestNPCs) do
        if NPC:FindFirstChild("QuestPrompt") then
            local Distance = (HumanoidRootPart.Position - NPC.HumanoidRootPart.Position).Magnitude
            if Distance <= 10 then
                fireproximityprompt(NPC.QuestPrompt)
            end
        end
    end
end

-- Sistema de Fast Attack
local CombatFramework = require(Player.PlayerScripts.CombatFramework)
local CameraShaker = require(Player.PlayerScripts.CombatFramework.CameraShaker)
local CombatFrameworkR = getupvalue(CombatFramework.initialize, 1)

spawn(function()
    while wait() do
        if Settings.FastAttack then
            pcall(function()
                CameraShaker.CameraShakeInstance.CameraShakeState.Inactive = 0
                CombatFrameworkR.activeController.hitboxMagnitude = 55
                CombatFrameworkR.activeController.increment = 3
                CombatFrameworkR.activeController.timeToNextAttack = 0
                CombatFrameworkR.activeController.attacking = false
                CombatFrameworkR.activeController.blocking = false
                CombatFrameworkR.activeController.timeToNextBlock = 0
            end)
        end
    end
end)

-- Sistema de Auto Farm
spawn(function()
    while wait() do
        if Settings.AutoFarm then
            pcall(function()
                local Mob = GetNearestMob()
                if Mob then
                    local Distance = Settings.FarmDistance or 50
                    local TargetCFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0, Distance/10, Distance/10)
                    
                    if Settings.AutoQuest then
                        GetQuest()
                    end
                    
                    if Settings.BringMob then
                        Mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        HumanoidRootPart.CFrame = TargetCFrame
                    end
                    
                    if Settings.FastAttack then
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(1280, 672))
                    end
                end
            end)
        end
    end
end)

-- Sistema de Kill Aura
spawn(function()
    while wait() do
        if Settings.KillAura then
            pcall(function()
                local Range = Settings.KillAuraRange or 50
                for _, Mob in pairs(workspace.Enemies:GetChildren()) do
                    if Mob:FindFirstChild("HumanoidRootPart") and 
                       (Mob.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= Range then
                        if Settings.FastAttack then
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end
end)

-- Sistema de Auto Fruit
spawn(function()
    while wait(1) do
        if Settings.AutoFruit then
            pcall(function()
                for _, Fruit in pairs(workspace:GetChildren()) do
                    if Fruit.Name:find("Fruit") and Fruit:FindFirstChild("Handle") then
                        HumanoidRootPart.CFrame = Fruit.Handle.CFrame
                        wait(1)
                    end
                end
                
                for _, Tool in pairs(Player.Backpack:GetChildren()) do
                    if Tool.Name:find("Fruit") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", Tool.Name)
                        wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- Sistema de Auto Raid
spawn(function()
    while wait(1) do
        if Settings.AutoRaid then
            pcall(function()
                if workspace:FindFirstChild("RaidMap") then
                    for _, Mob in pairs(workspace.RaidMap.Enemies:GetChildren()) do
                        if Mob:FindFirstChild("Humanoid") and Mob.Humanoid.Health > 0 then
                            repeat
                                wait()
                                HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                                if Settings.FastAttack then
                                    VirtualUser:CaptureController()
                                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                                end
                            until not Settings.AutoRaid or not Mob or Mob.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Sistema de Teleporte
local function Teleport(Position)
    HumanoidRootPart.CFrame = Position
end

local TeleportLocations = {
    ["Starter Island"] = CFrame.new(1000, 100, 1000),
    ["Marine Island"] = CFrame.new(2000, 100, 2000),
    ["Desert Island"] = CFrame.new(3000, 100, 3000),
    ["Snow Island"] = CFrame.new(4000, 100, 4000),
    ["Sky Island"] = CFrame.new(5000, 1000, 5000)
}

spawn(function()
    while wait() do
        if Settings.SelectedIsland and TeleportLocations[Settings.SelectedIsland] then
            Teleport(TeleportLocations[Settings.SelectedIsland])
            wait(1)
        end
    end
end)

-- Sistema de Walk on Water
local WaterLevel = 50
spawn(function()
    while wait() do
        if Settings.WalkOnWater then
            pcall(function()
                if HumanoidRootPart.Position.Y <= WaterLevel then
                    HumanoidRootPart.CFrame = CFrame.new(
                        HumanoidRootPart.Position.X,
                        WaterLevel,
                        HumanoidRootPart.Position.Z
                    )
                end
            end)
        end
    end
end)

-- Sistema de Hide Name
spawn(function()
    while wait() do
        if Settings.HideName then
            pcall(function()
                for _, v in pairs(Character:GetDescendants()) do
                    if v.Name == "NameTag" or v.Name == "Head" then
                        if v:FindFirstChild("NameBillboard") then
                            v.NameBillboard:Destroy()
                        end
                    end
                end
            end)
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

-- Sistema de Auto Refresh
Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    
    if Settings.AutoFarm then
        SendWebhook("Character respawned, continuing farm...")
    end
end)

-- Salvar Configurações
local function SaveSettings()
    writefile("TheusHUB_Settings.json", game:GetService("HttpService"):JSONEncode(Settings))
end

-- Carregar Configurações
pcall(function()
    if isfile("TheusHUB_Settings.json") then
        local LoadedSettings = game:GetService("HttpService"):JSONDecode(readfile("TheusHUB_Settings.json"))
        for Setting, Value in pairs(LoadedSettings) do
            Settings[Setting] = Value
        end
    end
end)

-- Auto Save
spawn(function()
    while wait(30) do
        SaveSettings()
    end
end)

CreateNotification("Script loaded successfully!", 3)