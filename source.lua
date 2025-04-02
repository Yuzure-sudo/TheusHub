local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Configurações Funcionais
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoQuest = false,
    SelectedMob = "Bandit",
    AutoFruit = false,
    BringMob = false,
    KillAura = false,
    AutoRaid = false,
    AutoStats = false,
    SelectedStat = "Melee"
}

-- Funções Utilitárias
local function Teleport(pos)
    if typeof(pos) == "CFrame" then
        Character.HumanoidRootPart.CFrame = pos
    else
        Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function BringMob(mob, target)
    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        mob.HumanoidRootPart.CFrame = target
        mob.HumanoidRootPart.CanCollide = false
        mob.HumanoidRootPart.Size = Vector3.new(5, 5, 5)
    end
end

-- Sistema de Fast Attack
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CameraShaker = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
local CombatFrameworkR = getupvalue(CombatFramework.initialize, 1)

local function FastAttack()
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

-- Sistema de Farm Otimizado
local function GetNearestMob()
    local closest = math.huge
    local target = nil
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            if Settings.SelectedMob ~= "Nearest" and mob.Name ~= Settings.SelectedMob then continue end
            
            local distance = (Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < closest then
                closest = distance
                target = mob
            end
        end
    end
    return target
end

local function AutoFarm()
    spawn(function()
        while Settings.AutoFarm do
            pcall(function()
                local mob = GetNearestMob()
                if mob then
                    if Settings.AutoQuest then
                        -- Implementação de Auto Quest aqui
                        local questInfo = {
                            ["Bandit"] = {Quest = "BanditQuest1", Level = 1},
                            ["Monkey"] = {Quest = "MonkeyQuest", Level = 10},
                            -- Adicione mais quests conforme necessário
                        }
                        
                        if not Player.PlayerGui.Main.Quest.Visible then
                            local quest = questInfo[Settings.SelectedMob]
                            if quest then
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quest.Quest, quest.Level)
                            end
                        end
                    end
                    
                    Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                    
                    if Settings.BringMob then
                        BringMob(mob, Character.HumanoidRootPart.CFrame * CFrame.new(0, -7, 0))
                    end
                    
                    FastAttack()
                end
            end)
            task.wait()
        end
    end)
end

-- Sistema de Frutas
local function AutoFruit()
    spawn(function()
        while Settings.AutoFruit do
            pcall(function()
                for _, fruit in pairs(workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                        Teleport(fruit.Handle.CFrame)
                        wait(1)
                        if Player.Character:FindFirstChild("Humanoid") then
                            Player.Character.Humanoid:ChangeState(15)
                        end
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
            wait(1)
        end
    end)
end-- Interface Funcional
local TheusHub = Instance.new("ScreenGui")
TheusHub.Name = "TheusHub"
TheusHub.Parent = game.CoreGui

-- Frame Principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = TheusHub

-- Botão de Minimizar
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0, 5)
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
MinimizedButton.Parent = TheusHub

-- Sistema de Minimização
MinButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    MinimizedButton.Visible = false
end)

-- Container de Opções
local OptionsContainer = Instance.new("ScrollingFrame")
OptionsContainer.Size = UDim2.new(1, -20, 1, -40)
OptionsContainer.Position = UDim2.new(0, 10, 0, 40)
OptionsContainer.BackgroundTransparency = 1
OptionsContainer.ScrollBarThickness = 2
OptionsContainer.Parent = Main

-- Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = OptionsContainer

-- Função para Criar Toggles
local function CreateToggle(text, setting)
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
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = Toggle

    Button.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        Button.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
        
        -- Ativar funções correspondentes
        if setting == "AutoFarm" then
            if Settings.AutoFarm then AutoFarm() end
        elseif setting == "AutoFruit" then
            if Settings.AutoFruit then AutoFruit() end
        elseif setting == "KillAura" then
            if Settings.KillAura then
                spawn(function()
                    while Settings.KillAura do
                        pcall(function()
                            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                                if mob:FindFirstChild("HumanoidRootPart") and 
                                   (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude <= 50 then
                                    FastAttack()
                                end
                            end
                        end)
                        wait()
                    end
                end)
            end
        elseif setting == "AutoStats" then
            if Settings.AutoStats then
                spawn(function()
                    while Settings.AutoStats do
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", Settings.SelectedStat, 1)
                        wait(0.1)
                    end
                end)
            end
        end
    end)
end

-- Criar Seções
local function CreateSection(text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Section.Text = text
    Section.TextColor3 = Color3.fromRGB(255, 255, 255)
    Section.Font = Enum.Font.GothamBold
    Section.Parent = OptionsContainer
end

-- Criar Dropdown para Seleção de Mob
local function CreateMobDropdown()
    local Dropdown = Instance.new("TextButton")
    Dropdown.Size = UDim2.new(1, 0, 0, 35)
    Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Dropdown.Text = "Selected: " .. Settings.SelectedMob
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.Parent = OptionsContainer

    local Mobs = {"Nearest", "Bandit", "Monkey", "Gorilla"} -- Adicione mais mobs conforme necessário
    
    Dropdown.MouseButton1Click:Connect(function()
        local current = table.find(Mobs, Settings.SelectedMob)
        current = current and current + 1 or 1
        if current > #Mobs then current = 1 end
        Settings.SelectedMob = Mobs[current]
        Dropdown.Text = "Selected: " .. Settings.SelectedMob
    end)
end

-- Implementar Interface
CreateSection("Main")
CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Fast Attack", "FastAttack")
CreateToggle("Auto Quest", "AutoQuest")
CreateMobDropdown()

CreateSection("Fruits")
CreateToggle("Auto Fruit", "AutoFruit")
CreateToggle("Bring Mob", "BringMob")

CreateSection("Combat")
CreateToggle("Kill Aura", "KillAura")
CreateToggle("Auto Raid", "AutoRaid")

CreateSection("Stats")
CreateToggle("Auto Stats", "AutoStats")

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Ajustar tamanho do ScrollingFrame
OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

-- Notificação de Inicialização
local function CreateNotification(text)
    local Notification = Instance.new("TextLabel")
    Notification.Size = UDim2.new(0, 200, 0, 40)
    Notification.Position = UDim2.new(0.5, -100, 0.8, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notification.Text = text
    Notification.Parent = TheusHub
    game:GetService("Debris"):AddItem(Notification, 2)
end

CreateNotification("THEUS HUB Loaded!")