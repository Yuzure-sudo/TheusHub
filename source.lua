-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configurações
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    ESP = {
        Players = false,
        Mobs = false,
        Chests = false
    },
    ChestFarm = false,
    AttackSpeed = 0.01,
    HoverHeight = 20,
    AutoSkill = false,
    FastAttack = false,
    NoClip = false
}

-- Tela de Login (mantida do script anterior)
local function createLoginScreen()
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "TheusHubLogin"
    LoginGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = LoginGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0.1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "THEUS HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 30
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 18
    KeyInput.Parent = MainFrame

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = KeyInput

    local LoginButton = Instance.new("TextButton")
    LoginButton.Size = UDim2.new(0.8, 0, 0, 40)
    LoginButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    LoginButton.Text = "Login"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.Font = Enum.Font.GothamBold
    LoginButton.TextSize = 18
    LoginButton.Parent = MainFrame

    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = LoginButton

    -- Animação de carregamento
    local function showLoadingScreen()
        LoginGui:Destroy()
        
        local LoadingGui = Instance.new("ScreenGui")
        LoadingGui.Name = "TheusHubLoading"
        LoadingGui.Parent = game.CoreGui

        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
        LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        LoadingFrame.BorderSizePixel = 0
        LoadingFrame.Parent = LoadingGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 15)
        UICorner.Parent = LoadingFrame

        local LoadingText = Instance.new("TextLabel")
        LoadingText.Size = UDim2.new(1, 0, 0, 30)
        LoadingText.Position = UDim2.new(0, 0, 0.2, 0)
        LoadingText.BackgroundTransparency = 1
        LoadingText.Text = "Loading..."
        LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
        LoadingText.TextSize = 24
        LoadingText.Font = Enum.Font.GothamBold
        LoadingText.Parent = LoadingFrame

        local LoadingBar = Instance.new("Frame")
        LoadingBar.Size = UDim2.new(0.8, 0, 0, 10)
        LoadingBar.Position = UDim2.new(0.1, 0, 0.6, 0)
        LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        LoadingBar.BorderSizePixel = 0
        LoadingBar.Parent = LoadingFrame

        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(1, 0)
        UICorner2.Parent = LoadingBar

        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(0, 0, 1, 0)
        Progress.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        Progress.BorderSizePixel = 0
        Progress.Parent = LoadingBar

        local UICorner3 = Instance.new("UICorner")
        UICorner3.CornerRadius = UDim.new(1, 0)
        UICorner3.Parent = Progress

        local function animateLoading()
            local tween = TweenService:Create(Progress, 
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, 0, 1, 0)}
            )
            tween:Play()
            wait(2.5)
            LoadingGui:Destroy()
            createMainGUI()
        end

        animateLoading()
    end

    LoginButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "THEUSHUB" then
            showLoadingScreen()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end
    end)
end

-- Interface Principal Melhorada
local function createMainGUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "TheusHubMain"
    MainGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    -- Barra Superior
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local UICornerTop = Instance.new("UICorner")
    UICornerTop.CornerRadius = UDim.new(0, 15)
    UICornerTop.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.15, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "THEUS HUB V2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TopBar

    -- Tabs
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(0.25, 0, 0.9, 0)
    TabsFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = MainFrame

    local UICornerTabs = Instance.new("UICorner")
    UICornerTabs.CornerRadius = UDim.new(0, 10)
    UICornerTabs.Parent = TabsFrame

    -- Conteúdo
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(0.7, 0, 0.9, 0)
    ContentFrame.Position = UDim2.new(0.28, 0, 0.1, 0)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame

    local UICornerContent = Instance.new("UICorner")
    UICornerContent.CornerRadius = UDim.new(0, 10)
    UICornerContent.Parent = ContentFrame

    -- Função para criar tabs
    local function createTab(name, position)
        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(0.9, 0, 0, 35)
        Tab.Position = position
        Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Tab.Text = name
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 14
        Tab.Font = Enum.Font.GothamSemibold
        Tab.Parent = TabsFrame

        local UICornerTab = Instance.new("UICorner")
        UICornerTab.CornerRadius = UDim.new(0, 8)
        UICornerTab.Parent = Tab

        return Tab
    end

    -- Função para criar botões de função
    local function createFunctionButton(name, position, parent)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 35)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.Parent = parent

        local UICornerButton = Instance.new("UICorner")
        UICornerButton.CornerRadius = UDim.new(0, 8)
        UICornerButton.Parent = Button

        local ToggleState = Instance.new("Frame")
        ToggleState.Size = UDim2.new(0, 8, 0, 8)
        ToggleState.Position = UDim2.new(0.95, -4, 0.5, -4)
        ToggleState.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleState.Parent = Button

        local UICornerToggle = Instance.new("UICorner")
        UICornerToggle.CornerRadius = UDim.new(1, 0)
        UICornerToggle.Parent = ToggleState

        return Button, ToggleState
    end

    -- Criando Tabs
    local tabY = 0.02
    local tabSpacing = 0.08

    local farmingTab = createTab("Farming", UDim2.new(0.05, 0, tabY, 0))
    tabY = tabY + tabSpacing
    local combatTab = createTab("Combat", UDim2.new(0.05, 0, tabY, 0))
    tabY = tabY + tabSpacing
    local visualsTab = createTab("Visuals", UDim2.new(0.05, 0, tabY, 0))
    tabY = tabY + tabSpacing
    local miscTab = createTab("Misc", UDim2.new(0.05, 0, tabY, 0))

    -- Criando páginas de conteúdo
    local function createContentPage()
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.Parent = ContentFrame
        return Page
    end

    local farmingPage = createContentPage()
    local combatPage = createContentPage()
    local visualsPage = createContentPage()
    local miscPage = createContentPage()

    -- Função para alternar entre páginas
    local function showPage(page)
        farmingPage.Visible = false
        combatPage.Visible = false
        visualsPage.Visible = false
        miscPage.Visible = false
        page.Visible = true
    end

    -- Eventos dos tabs
    farmingTab.MouseButton1Click:Connect(function() showPage(farmingPage) end)
    combatTab.MouseButton1Click:Connect(function() showPage(combatPage) end)
    visualsTab.MouseButton1Click:Connect(function() showPage(visualsPage) end)
    miscTab.MouseButton1Click:Connect(function() showPage(miscPage) end)

    -- Adicionando botões às páginas
    -- Farming Page
    local farmY = 0.02
    local buttonSpacing = 0.08

    local autoFarmButton, autoFarmState = createFunctionButton("Auto Farm", UDim2.new(0.05, 0, farmY, 0), farmingPage)
    farmY = farmY + buttonSpacing
    local autoQuestButton, autoQuestState = createFunctionButton("Auto Quest", UDim2.new(0.05, 0, farmY, 0), farmingPage)
    farmY = farmY + buttonSpacing
    local chestFarmButton, chestFarmState = createFunctionButton("Chest Farm", UDim2.new(0.05, 0, farmY, 0), farmingPage)

    -- Combat Page
    local combatY = 0.02
    local fastAttackButton, fastAttackState = createFunctionButton("Fast Attack", UDim2.new(0.05, 0, combatY, 0), combatPage)
    combatY = combatY + buttonSpacing
    local autoSkillButton, autoSkillState = createFunctionButton("Auto Skill", UDim2.new(0.05, 0, combatY, 0), combatPage)

    -- Visuals Page
    local visualsY = 0.02
    local espMobsButton, espMobsState = createFunctionButton("ESP Mobs", UDim2.new(0.05, 0, visualsY, 0), visualsPage)
    visualsY = visualsY + buttonSpacing
    local espChestButton, espChestState = createFunctionButton("ESP Chests", UDim2.new(0.05, 0, visualsY, 0), visualsPage)

    -- Misc Page
    local miscY = 0.02
    local noClipButton, noClipState = createFunctionButton("No Clip", UDim2.new(0.05, 0, miscY, 0), miscPage)
    miscY = miscY + buttonSpacing
    local walkSpeedButton, walkSpeedState = createFunctionButton("Walk Speed", UDim2.new(0.05, 0, miscY, 0), miscPage)

    -- Mostrar página inicial
    showPage(farmingPage)

    -- Funções dos botões
    autoFarmButton.MouseButton1Click:Connect(function()
        Settings.AutoFarm = not Settings.AutoFarm
        autoFarmState.BackgroundColor3 = Settings.AutoFarm and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        if Settings.AutoFarm then
            -- Iniciar Auto Farm
        end
    end)

    -- Adicione eventos similares para os outros botões...
end

-- Inicialização
createLoginScreen()