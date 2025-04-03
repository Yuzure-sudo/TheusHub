-- Criando a interface principal
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

-- Configurando a GUI principal
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22

-- Campos de login
local UsernameBox = Instance.new("TextBox")
local PasswordBox = Instance.new("TextBox")
local LoginButton = Instance.new("TextButton")

-- Configurando campos de texto
UsernameBox.Parent = MainFrame
UsernameBox.Position = UDim2.new(0.2, 0, 0.3, 0)
UsernameBox.Size = UDim2.new(0.6, 0, 0, 30)
UsernameBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
UsernameBox.PlaceholderText = "Username"
UsernameBox.Text = ""
UsernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)

PasswordBox.Parent = MainFrame
PasswordBox.Position = UDim2.new(0.2, 0, 0.5, 0)
PasswordBox.Size = UDim2.new(0.6, 0, 0, 30)
PasswordBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PasswordBox.PlaceholderText = "Password"
PasswordBox.Text = ""
PasswordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PasswordBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)

-- Configurando botão de login
LoginButton.Parent = MainFrame
LoginButton.Position = UDim2.new(0.2, 0, 0.7, 0)
LoginButton.Size = UDim2.new(0.6, 0, 0, 30)
LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LoginButton.Text = "Login"
LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginButton.TextSize = 16

-- Funções principais
local functions = {}
local enabled = false

function functions.Toggle()
    enabled = not enabled
    if enabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

function functions.SuperJump()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
end

function functions.Teleport(player)
    local character = game.Players.LocalPlayer.Character
    local targetPlayer = game.Players:FindFirstChild(player)
    if targetPlayer and targetPlayer.Character then
        character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
    end
end

-- Sistema de login
LoginButton.MouseButton1Click:Connect(function()
    local username = UsernameBox.Text
    local password = PasswordBox.Text
    
    if (username == "admin" and password == "123") then
        MainFrame.Visible = false
        -- Aqui você pode adicionar o que acontece após o login
        -- Por exemplo, mostrar os botões das funções
        loadFunctions()
    end
end)

-- Função para carregar os botões das funções
function loadFunctions()
    local FunctionsFrame = Instance.new("Frame")
    FunctionsFrame.Name = "FunctionsFrame"
    FunctionsFrame.Parent = ScreenGui
    FunctionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    FunctionsFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    FunctionsFrame.Size = UDim2.new(0, 300, 0, 350)
    FunctionsFrame.Active = true
    FunctionsFrame.Draggable = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = FunctionsFrame
    UICorner.CornerRadius = UDim.new(0, 10)
    
    -- Criando botões para as funções
    local function createFunctionButton(name, position)
        local button = Instance.new("TextButton")
        button.Parent = FunctionsFrame
        button.Position = position
        button.Size = UDim2.new(0.8, 0, 0, 30)
        button.Position = UDim2.new(0.1, 0, position, 0)
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        local ButtonUICorner = Instance.new("UICorner")
        ButtonUICorner.Parent = button
        ButtonUICorner.CornerRadius = UDim.new(0, 6)
        return button
    end

    local toggleButton = createFunctionButton("Toggle Speed", 0.2)
    local jumpButton = createFunctionButton("Super Jump", 0.4)
    local teleportButton = createFunctionButton("Teleport", 0.6)

    toggleButton.MouseButton1Click:Connect(functions.Toggle)
    jumpButton.MouseButton1Click:Connect(functions.SuperJump)
    teleportButton.MouseButton1Click:Connect(function()
        functions.Teleport("NomeDoJogador")
    end)
end

-- Efeitos visuais
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 100, 220)}):Play()
    end)
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
    end)
end

addHoverEffect(LoginButton)