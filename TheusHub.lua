-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- Configurações
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoQuest = false,
    NoClip = false,
    AutoHaki = false,
    TweenSpeed = 350
}

-- Interface Principal
local TheusHub = Instance.new("ScreenGui")
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui
TheusHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = TheusHub
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainWindow.BorderSizePixel = 0
MainWindow.Position = UDim2.new(0.5, -250, 0.5, -175)
MainWindow.Size = UDim2.new(0, 500, 0, 350)
MainWindow.Active = true
MainWindow.Draggable = true

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainWindow
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Buttons
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainWindow
TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0, 35)
TabButtons.Size = UDim2.new(0, 100, 1, -35)

-- Função para criar botões de tab com estilo moderno
local function CreateTabButton(name, imageId)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabButtons
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (#TabButtons:GetChildren() - 1) * 40)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 12
    TabButton.AutoButtonColor = false

    -- Efeito hover
    TabButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    TabButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)

    return TabButton
end

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainWindow
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 100, 0, 35)
ContentContainer.Size = UDim2.new(1, -100, 1, -35)

-- Criar páginas de conteúdo
local function CreateContentPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name.."Page"
    Page.Parent = ContentContainer
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Page
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = Page
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    
    return Page
end

-- Criar Toggles modernos
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text.."Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
    ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local enabled = false
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        }):Play()
        callback(enabled)
    end)

    return ToggleFrame
end

-- Criar Tabs
local FramingTab = CreateTabButton("Framing")
local TeleportTab = CreateTabButton("Teleport")
local FakeTab = CreateTabButton("Fake")

-- Criar Pages
local FramingPage = CreateContentPage("Framing")
local TeleportPage = CreateContentPage("Teleport")
local FakePage = CreateContentPage("Fake")

-- Sistema de Switch Tab
local function SwitchTab(tabName)
    for _, page in pairs(ContentContainer:GetChildren()) do
        if page:IsA("ScrollingFrame") then
            page.Visible = page.Name == tabName.."Page"
        end
    end
end

FramingTab.MouseButton1Click:Connect(function() SwitchTab("Framing") end)
TeleportTab.MouseButton1Click:Connect(function() SwitchTab("Teleport") end)
FakeTab.MouseButton1Click:Connect(function() SwitchTab("Fake") end)

-- Mostrar primeira tab por padrão
SwitchTab("Framing")