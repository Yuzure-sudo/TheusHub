if game.CoreGui:FindFirstChild("TheusUI") then
    game.CoreGui:FindFirstChild("TheusUI"):Destroy()
end

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configurações
_G.AutoFarm = false
_G.FastAttack = false
_G.AutoFruit = false
_G.KillAura = false
_G.SelectedMob = "Bandit"

-- Interface Principal
local TheusUI = Instance.new("ScreenGui")
TheusUI.Name = "TheusUI"
TheusUI.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = TheusUI

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "THEUS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1
Container.Parent = Main

-- Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Container

-- Função para criar toggles
local function CreateToggle(text, value)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Container

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
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = Toggle

    Button.MouseButton1Click:Connect(function()
        _G[value] = not _G[value]
        Button.BackgroundColor3 = _G[value] and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
    end)
end

-- Funções de Farm
local function GetNearestMob()
    local closest = math.huge
    local target = nil
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            if _G.SelectedMob ~= "Nearest" and mob.Name ~= _G.SelectedMob then continue end
            
            local distance = (Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < closest then
                closest = distance
                target = mob
            end
        end
    end
    return target
end 

-- Sistema de Fast Attack
local CombatFramework = require(Player.PlayerScripts.CombatFramework)
local CameraShaker = require(Player.PlayerScripts.CombatFramework.CameraShaker)
local CombatFrameworkR = getupvalue(CombatFramework.initialize, 1)

spawn(function()
    while wait() do
        if _G.FastAttack then
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
        if _G.AutoFarm then
            pcall(function()
                local mob = GetNearestMob()
                if mob then
                    local targetCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    Character.HumanoidRootPart.CFrame = targetCFrame
                    
                    -- Auto Attack
                    if _G.FastAttack then
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    end
                end
            end)
        end
    end
end)

-- Sistema de Auto Fruit
spawn(function()
    while wait(1) do
        if _G.AutoFruit then
            pcall(function()
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                        Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                        wait(1)
                    end
                end
                
                -- Auto Store Fruits
                for _, tool in pairs(Player.Backpack:GetChildren()) do
                    if tool.Name:find("Fruit") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                        wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- Sistema de Kill Aura
spawn(function()
    while wait() do
        if _G.KillAura then
            pcall(function()
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and 
                       (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude <= 50 then
                        if _G.FastAttack then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end
end)

-- Criar Seções
local function CreateSection(text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Section.Text = text
    Section.TextColor3 = Color3.fromRGB(255, 255, 255)
    Section.Font = Enum.Font.GothamBold
    Section.Parent = Container
end

-- Criar Dropdown de Mobs
local function CreateMobDropdown()
    local Dropdown = Instance.new("TextButton")
    Dropdown.Size = UDim2.new(1, 0, 0, 35)
    Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Dropdown.Text = "Selected: " .. _G.SelectedMob
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.Parent = Container

    local Mobs = {
        "Nearest",
        "Bandit",
        "Monkey",
        "Gorilla",
        "Marine",
        "Chief Petty Officer",
        "Sky Bandit",
        "Dark Master",
        "Prisoner",
        "Dangerous Prisoner",
        "Mob Leader",
        "Shanda"
    }
    
    Dropdown.MouseButton1Click:Connect(function()
        local current = table.find(Mobs, _G.SelectedMob)
        current = current and current + 1 or 1
        if current > #Mobs then current = 1 end
        _G.SelectedMob = Mobs[current]
        Dropdown.Text = "Selected: " .. _G.SelectedMob
    end)
end

-- Botão de Minimizar
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0, 0)
MinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinButton.Text = "-"
MinButton.TextSize = 20
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Parent = Main

-- Botão Minimizado
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Size = UDim2.new(0, 40, 0, 40)
MinimizedButton.Position = UDim2.new(0, 0, 0.5, -20)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MinimizedButton.Text = "T"
MinimizedButton.TextSize = 20
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.Visible = false
MinimizedButton.Parent = TheusUI

-- Sistema de Minimização
MinButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    MinimizedButton.Visible = false
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

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Notificação de Inicialização
local function CreateNotification(text, duration)
    local Notification = Instance.new("TextLabel")
    Notification.Size = UDim2.new(0, 200, 0, 40)
    Notification.Position = UDim2.new(0.5, -100, 0.8, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notification.Text = text
    Notification.TextSize = 16
    Notification.Font = Enum.Font.GothamBold
    Notification.Parent = TheusUI
    
    game:GetService("Debris"):AddItem(Notification, duration or 2)
end

CreateNotification("THEUS HUB Loaded!", 3)

-- Teclas de Atalho
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
            MinimizedButton.Visible = not Main.Visible
        end
    end
end)

-- Auto Refresh
spawn(function()
    while wait(1) do
        pcall(function()
            if Character and Character.Humanoid.Health <= 0 then
                _G.AutoFarm = false
                wait(5)
                _G.AutoFarm = true
            end
        end)
    end
end)