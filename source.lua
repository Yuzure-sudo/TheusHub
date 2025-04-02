local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Configurações Principais
local Settings = {
    Combat = {
        AutoFarm = false,
        FastAttack = false,
        KillAura = false,
        HitboxExpander = false,
        AutoSkill = false,
        FarmHeight = 30
    },
    Farming = {
        AutoQuest = false,
        FruitSniper = false,
        BossSniper = false,
        AutoRaid = false
    },
    Visual = {
        ESP = {
            Players = false,
            Mobs = false,
            Fruits = false,
            Chests = false
        }
    },
    Movement = {
        NoClip = false,
        Speed = false,
        SpeedMultiplier = 2
    }
}

-- Sistema de Combate Otimizado
local function getFastestWeapon()
    local tools = Player.Backpack:GetChildren()
    local fastestTool = nil
    local fastestSpeed = 0
    
    for _, tool in pairs(tools) do
        if tool:IsA("Tool") and tool:FindFirstChild("ToolTip") then
            local attackSpeed = tonumber(tool.ToolTip.Value) or 0
            if attackSpeed > fastestSpeed then
                fastestSpeed = attackSpeed
                fastestTool = tool
            end
        end
    end
    
    return fastestTool
end

local function equipBestWeapon()
    local weapon = getFastestWeapon()
    if weapon then
        Character.Humanoid:EquipTool(weapon)
    end
end

local function ultraFastAttack()
    local animationTrack = Character.Humanoid.Animator:LoadAnimation(Character.Humanoid.Animator:GetPlayingAnimationTracks()[1])
    animationTrack:AdjustSpeed(2)
    
    local args = {
        [1] = "ComboHit",
        [2] = "Melee"
    }
    
    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
end

-- Sistema de Quest e Farm Integrado
local function getQuestLevel()
    local playerLevel = Player.Level.Value
    local quests = {
        -- First Sea (1-699)
        {level = 1, npc = "Bandit Quest Giver", quest = "BanditQuest1", mobName = "Bandit"},
        {level = 10, npc = "Monkey Quest Giver", quest = "MonkeyQuest", mobName = "Monkey"},
        {level = 15, npc = "Gorilla Quest Giver", quest = "GorillaQuest", mobName = "Gorilla"},
        -- Continua com todas as quests...
    }
    
    for i = #quests, 1, -1 do
        if playerLevel >= quests[i].level then
            return quests[i]
        end
    end
end

local function autoFarmWithQuest()
    while Settings.Combat.AutoFarm do
        local questInfo = getQuestLevel()
        if questInfo then
            -- Pegar Quest se não tiver
            if not Player.PlayerGui.Main.Quest.Visible then
                local questNPC = workspace.NPCs:FindFirstChild(questInfo.npc)
                if questNPC then
                    local targetCFrame = questNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    Player.Character.HumanoidRootPart.CFrame = targetCFrame
                    wait(0.5)
                    
                    local args = {
                        [1] = "StartQuest",
                        [2] = questInfo.quest,
                        [3] = questInfo.level
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end
            
            -- Farm dos Mobs
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob.Name == questInfo.mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    repeat
                        equipBestWeapon()
                        
                        local mobCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, Settings.Combat.FarmHeight, 0)
                        Player.Character.HumanoidRootPart.CFrame = mobCFrame
                        
                        if Settings.Combat.FastAttack then
                            ultraFastAttack()
                        end
                        
                        if Settings.Combat.AutoSkill then
                            useSkills()
                        end
                        
                        wait()
                    until not mob:FindFirstChild("Humanoid") or 
                          mob.Humanoid.Health <= 0 or 
                          not Settings.Combat.AutoFarm
                end
            end
        end
        wait()
    end
end

-- Sistema de Skills
local function useSkills()
    local skills = {"Z", "X", "C", "V", "F"}
    for _, skill in pairs(skills) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
    end
end

-- Sistema de Drops
local function collectDrops()
    for _, drop in pairs(workspace.Dropped:GetChildren()) do
        if drop:IsA("Tool") or drop:IsA("Model") then
            local distance = (drop.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance < 50 then
                firetouchinterest(Player.Character.HumanoidRootPart, drop, 0)
                wait()
                firetouchinterest(Player.Character.HumanoidRootPart, drop, 1)
            end
        end
    end
end-- Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheusHubV2"
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Abas
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 40)
TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TabButtons.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Funções de Interface
local function createCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

local function createTab(name)
    -- Botão da Aba
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name.."Tab"
    tabButton.Size = UDim2.new(0.25, 0, 1, 0)
    tabButton.Position = UDim2.new(0.25 * (#TabButtons:GetChildren()), 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 14
    tabButton.Parent = TabButtons
    createCorner(tabButton)

    -- Conteúdo da Aba
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name.."Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.Parent = TabContainer

    -- Layout do Conteúdo
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = tabContent

    return tabContent
end

local function createToggle(parent, text, setting)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0.9, 0, 0, 40)
    toggle.Position = UDim2.new(0.05, 0, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggle.Parent = parent
    createCorner(toggle)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.Parent = toggle

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 25)
    button.Position = UDim2.new(0.85, 0, 0.5, -12.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    button.Text = ""
    button.Parent = toggle
    createCorner(button, 25)

    local function updateToggle()
        button.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
    end

    button.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        updateToggle()
    end)

    updateToggle()
    return toggle
end

-- Criar Abas
local combatTab = createTab("Combat")
local farmingTab = createTab("Farming")
local visualTab = createTab("Visual")
local movementTab = createTab("Movement")

-- Adicionar Toggles
-- Combat Tab
createToggle(combatTab, "Auto Farm + Quest", "Combat.AutoFarm")
createToggle(combatTab, "Fast Attack", "Combat.FastAttack")
createToggle(combatTab, "Kill Aura", "Combat.KillAura")
createToggle(combatTab, "Auto Skill", "Combat.AutoSkill")

-- Farming Tab
createToggle(farmingTab, "Auto Quest", "Farming.AutoQuest")
createToggle(farmingTab, "Fruit Sniper", "Farming.FruitSniper")
createToggle(farmingTab, "Boss Sniper", "Farming.BossSniper")
createToggle(farmingTab, "Auto Raid", "Farming.AutoRaid")

-- Visual Tab
createToggle(visualTab, "Player ESP", "Visual.ESP.Players")
createToggle(visualTab, "Mob ESP", "Visual.ESP.Mobs")
createToggle(visualTab, "Fruit ESP", "Visual.ESP.Fruits")
createToggle(visualTab, "Chest ESP", "Visual.ESP.Chests")

-- Movement Tab
createToggle(movementTab, "No Clip", "Movement.NoClip")
createToggle(movementTab, "Speed Hack", "Movement.Speed")

-- Sistema de Notificações
local function createNotification(text, type)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(1, -260, 0.8, 0)
    notif.BackgroundColor3 = type == "success" and Color3.fromRGB(0, 255, 125) or Color3.fromRGB(255, 50, 50)
    notif.Parent = ScreenGui
    createCorner(notif)

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamSemibold
    notifText.Parent = notif

    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -260, 0.9, 0)
    }):Play()

    wait(2)

    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 0, 0.9, 0)
    }):Play()

    wait(0.5)
    notif:Destroy()
end

-- Inicialização
combatTab.Visible = true
for _, button in pairs(TabButtons:GetChildren()) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            for _, content in pairs(TabContainer:GetChildren()) do
                content.Visible = content.Name == button.Name:gsub("Tab", "Content")
            end
        end)
    end
end

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Loop Principal
RunService.Heartbeat:Connect(function()
    if Settings.Combat.AutoFarm then
        autoFarmWithQuest()
    end
    
    if Settings.Movement.NoClip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    if Settings.Movement.Speed then
        Character.Humanoid.WalkSpeed = 16 * Settings.Movement.SpeedMultiplier
    else
        Character.Humanoid.WalkSpeed = 16
    end
    
    collectDrops()
end)

-- Mensagem Inicial
createNotification("Theus Hub V2 carregado com sucesso!", "success")