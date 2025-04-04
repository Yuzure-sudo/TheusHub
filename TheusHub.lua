-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- Interface Principal
local BloxUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabsFrame = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")

-- Estilização
BloxUI.Name = "BloxUI"
BloxUI.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = BloxUI
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Criação das Tabs
local function CreateTab(name)
    local Tab = Instance.new("TextButton")
    Tab.Name = name
    Tab.Parent = TabsFrame
    Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(1, 0, 0, 35)
    Tab.Font = Enum.Font.GothamSemibold
    Tab.Text = name
    Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.TextSize = 12
    return Tab
end

-- Tabs
local FramingTab = CreateTab("Tab Framing")
local TeleportTab = CreateTab("Tab Teleport")
local FakeTab = CreateTab("Tab Fake")

-- Conteúdo das Tabs
local function CreateToggle(parent, text)
    local Toggle = Instance.new("Frame")
    Toggle.Name = text
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, -20, 0, 35)
    
    local Button = Instance.new("TextButton")
    Button.Parent = Toggle
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Position = UDim2.new(0, 5, 0.5, -10)
    Button.Size = UDim2.new(0, 20, 0, 20)
    Button.Text = ""
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Toggle
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 35, 0, 0)
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    end)
    
    return Toggle, enabled
end

-- Framing Content
local FramingContent = Instance.new("ScrollingFrame")
FramingContent.Parent = ContentFrame
FramingContent.BackgroundTransparency = 1
FramingContent.Size = UDim2.new(1, 0, 1, 0)
FramingContent.Visible = false

local AutoFarm, autoFarmEnabled = CreateToggle(FramingContent, "Auto Farm")
local AutoQuest, autoQuestEnabled = CreateToggle(FramingContent, "Auto Quest")
local FastAttack, fastAttackEnabled = CreateToggle(FramingContent, "Fast Attack")

-- Teleport Content
local TeleportContent = Instance.new("ScrollingFrame")
TeleportContent.Parent = ContentFrame
TeleportContent.BackgroundTransparency = 1
TeleportContent.Size = UDim2.new(1, 0, 1, 0)
TeleportContent.Visible = false

-- Adicione os locais de teleporte aqui
local locations = {"First Island", "Marine Base", "Middle Town", "Jungle", "Pirate Village", "Desert", "Frozen Village"}
for i, location in ipairs(locations) do
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Parent = TeleportContent
    TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Position = UDim2.new(0, 10, 0, (i-1)*40 + 10)
    TeleportButton.Size = UDim2.new(1, -20, 0, 35)
    TeleportButton.Font = Enum.Font.GothamSemibold
    TeleportButton.Text = location
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 12
end

-- Fake Content
local FakeContent = Instance.new("ScrollingFrame")
FakeContent.Parent = ContentFrame
FakeContent.BackgroundTransparency = 1
FakeContent.Size = UDim2.new(1, 0, 1, 0)
FakeContent.Visible = false

-- Adicione as opções de fake aqui
local fakeOptions = {"Fake Level", "Fake Beli", "Fake Stats", "Fake Inventory"}
for i, option in ipairs(fakeOptions) do
    local FakeButton = Instance.new("TextButton")
    FakeButton.Parent = FakeContent
    FakeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FakeButton.BorderSizePixel = 0
    FakeButton.Position = UDim2.new(0, 10, 0, (i-1)*40 + 10)
    FakeButton.Size = UDim2.new(1, -20, 0, 35)
    FakeButton.Font = Enum.Font.GothamSemibold
    FakeButton.Text = option
    FakeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FakeButton.TextSize = 12
end

-- Tab Switching
local function SwitchTab(tab)
    FramingContent.Visible = false
    TeleportContent.Visible = false
    FakeContent.Visible = false
    
    if tab == "Framing" then
        FramingContent.Visible = true
    elseif tab == "Teleport" then
        TeleportContent.Visible = true
    elseif tab == "Fake" then
        FakeContent.Visible = true
    end
end

FramingTab.MouseButton1Click:Connect(function() SwitchTab("Framing") end)
TeleportTab.MouseButton1Click:Connect(function() SwitchTab("Teleport") end)
FakeTab.MouseButton1Click:Connect(function() SwitchTab("Fake") end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Inicialização
SwitchTab("Framing")