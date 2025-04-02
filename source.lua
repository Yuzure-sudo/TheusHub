-- Serviços Principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configurações Avançadas
local Settings = {
    Combat = {
        AutoFarm = false,
        FastAttack = false,
        InstantKill = false,
        KillAura = false,
        AutoSkill = false,
        SkillDelay = 1,
        HitboxExpander = false,
        HitboxSize = 50,
        AttackSpeed = 0.01,
        FarmHeight = 25,
        AutoWeapon = false
    },
    Movement = {
        NoClip = false,
        InfiniteJump = false,
        SpeedHack = false,
        SpeedMultiplier = 5,
        FlightEnabled = false,
        FlightSpeed = 50
    },
    Farming = {
        AutoQuest = false,
        ChestFarm = false,
        FruitSniper = false,
        AutoRaid = false,
        BossSniper = false,
        AutoSell = false
    },
    Visual = {
        ESP = {
            Players = false,
            Mobs = false,
            Fruits = false,
            Chests = false,
            Bosses = false
        },
        ShowDistance = true,
        ShowHealth = true,
        RainbowTheme = false
    }
}

-- Funções de Combate Aprimoradas
local function getFastestWeapon()
    local tools = Player.Backpack:GetChildren()
    local fastestTool = nil
    local fastestSpeed = 0
    
    for _, tool in pairs(tools) do
        if tool:FindFirstChild("AttackSpeed") and tool.AttackSpeed.Value > fastestSpeed then
            fastestSpeed = tool.AttackSpeed.Value
            fastestTool = tool
        end
    end
    
    return fastestTool
end

local function equipBestWeapon()
    local weapon = getFastestWeapon()
    if weapon then
        weapon.Parent = Player.Character
    end
end

-- Kill Aura Otimizado
local function killAura()
    while Settings.Combat.KillAura do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and 
               mob:FindFirstChild("HumanoidRootPart") and 
               mob.Humanoid.Health > 0 and
               (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 50 then
                
                local args = {
                    [1] = mob.Humanoid,
                    [2] = 100000 -- Dano máximo
                }
                
                game:GetService("ReplicatedStorage").Remotes.Damage:FireServer(unpack(args))
            end
        end
        wait(0.1)
    end
end

-- Fast Attack Ultra Rápido
local function ultraFastAttack()
    while Settings.Combat.FastAttack do
        local args = {
            [1] = "ComboChange",
            [2] = "M1",
            [3] = true
        }
        
        for i = 1, 10 do
            game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
        end
        
        game:GetService("RunService").Heartbeat:Wait()
    end
end

-- Hitbox Expander Melhorado
local function expandHitbox(mob)
    if mob:FindFirstChild("HumanoidRootPart") then
        mob.HumanoidRootPart.Size = Vector3.new(
            Settings.Combat.HitboxSize,
            Settings.Combat.HitboxSize,
            Settings.Combat.HitboxSize
        )
        mob.HumanoidRootPart.Transparency = 0.8
        mob.HumanoidRootPart.Color = Color3.fromRGB(255, 0, 0)
        mob.HumanoidRootPart.CanCollide = false
    end
end

-- Auto Farm Otimizado
local function getClosestMob()
    local closest = nil
    local maxDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and 
           mob:FindFirstChild("HumanoidRootPart") and 
           mob.Humanoid.Health > 0 then
            
            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if distance < maxDistance then
                maxDistance = distance
                closest = mob
            end
        end
    end
    
    return closest
end

local function autoFarm()
    while Settings.Combat.AutoFarm do
        if Settings.Combat.AutoWeapon then
            equipBestWeapon()
        end
        
        local mob = getClosestMob()
        if mob then
            if Settings.Combat.HitboxExpander then
                expandHitbox(mob)
            end
            
            local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.Combat.FarmHeight, 0)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            
            local tween = TweenService:Create(
                Player.Character.HumanoidRootPart,
                tweenInfo,
                {CFrame = CFrame.new(targetPosition, mob.HumanoidRootPart.Position)}
            )
            tween:Play()
            
            if Settings.Combat.FastAttack then
                ultraFastAttack()
            end
            
            if Settings.Combat.InstantKill then
                local args = {
                    [1] = mob.Humanoid,
                    [2] = 100000
                }
                game:GetService("ReplicatedStorage").Remotes.Damage:FireServer(unpack(args))
            end
        end
        wait()
    end
end

-- Sistema de Movimentação Avançado
local function enableSpeedHack()
    while Settings.Movement.SpeedHack do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16 * Settings.Movement.SpeedMultiplier
        end
        wait()
    end
end

local function enableFlight()
    while Settings.Movement.FlightEnabled do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -Settings.Movement.FlightSpeed/10)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.Movement.FlightSpeed/10)
            end
        end
        wait()
    end
end-- Interface e Funções Finais
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cores e Estilo
local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    DarkContrast = Color3.fromRGB(35, 35, 45),
    LightContrast = Color3.fromRGB(45, 45, 55),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(0, 170, 255),
    Success = Color3.fromRGB(0, 255, 125),
    Error = Color3.fromRGB(255, 50, 50),
    Gold = Color3.fromRGB(255, 215, 0)
}

-- Criar Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = math.random()
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Funções de Interface
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.AccentColor
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function createButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Theme.DarkContrast
    button.Text = text
    button.TextColor3 = Theme.TextColor
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = MainFrame
    
    createCorner(button, 8)
    createStroke(button)
    
    -- Efeitos do Botão
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = Theme.LightContrast
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
    
    return button
end

-- Sistema de Notificações
local function createNotification(text, type)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(1, -260, 0.8, 0)
    notif.BackgroundColor3 = type == "success" and Theme.Success or Theme.Error
    notif.Parent = ScreenGui
    
    createCorner(notif)
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Theme.TextColor
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamSemibold
    notifText.Parent = notif
    
    -- Animação
    TweenService:Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -260, 0.9, 0)
    }):Play()
    
    wait(2)
    
    TweenService:Create(notif, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 0, 0.9, 0)
    }):Play()
    
    wait(0.5)
    notif:Destroy()
end

-- Sistema de ESP Aprimorado
local function createESPObject(object, settings)
    local esp = Instance.new("BillboardGui")
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.AlwaysOnTop = true
    esp.Parent = object
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.Text = object.Name
    name.TextColor3 = settings.color or Theme.TextColor
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.Parent = esp
    
    if settings.showHealth and object:FindFirstChild("Humanoid") then
        local health = Instance.new("TextLabel")
        health.Size = UDim2.new(1, 0, 0.5, 0)
        health.Position = UDim2.new(0, 0, 0.5, 0)
        health.BackgroundTransparency = 1
        health.Text = "HP: " .. math.floor(object.Humanoid.Health)
        health.TextColor3 = Theme.Success
        health.TextSize = 12
        health.Font = Enum.Font.GothamSemibold
        health.Parent = esp
        
        object.Humanoid.HealthChanged:Connect(function(health)
            health.Text = "HP: " .. math.floor(health)
        end)
    end
    
    if settings.showDistance then
        RunService.RenderStepped:Connect(function()
            local distance = math.floor((object.Position - Player.Character.HumanoidRootPart.Position).Magnitude)
            name.Text = object.Name .. " [" .. distance .. "m]"
        end)
    end
end

-- Sistema de Auto Quest
local function autoQuest()
    while Settings.Farming.AutoQuest do
        local questInfo = getQuestLevel()
        if questInfo then
            -- Verificar se já tem uma quest ativa
            if not Player.PlayerGui.Main.Quest.Visible then
                -- Teleportar para o NPC
                local questNPC = workspace.NPCs:FindFirstChild(questInfo.npc)
                if questNPC and questNPC:FindFirstChild("HumanoidRootPart") then
                    -- Animação suave de teleporte
                    local targetCFrame = questNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    local startPos = Player.Character.HumanoidRootPart.Position
                    local distance = (targetCFrame.Position - startPos).Magnitude
                    local tweenTime = distance/1000 -- Velocidade do teleporte
                    
                    local tween = TweenService:Create(
                        Player.Character.HumanoidRootPart,
                        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
                        {CFrame = targetCFrame}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    
                    -- Pegar a quest
                    wait(0.5)
                    local args = {
                        [1] = "StartQuest",
                        [2] = questInfo.quest,
                        [3] = questInfo.level
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    wait(0.5)
                    
                    -- Notificação
                    createNotification("Iniciando Quest: " .. questInfo.quest, "success")
                end
            end
            
            -- Pegar informações do mob da quest
            local questData = Player.PlayerGui.Main.Quest
            if questData.Visible then
                local mobName = questData.Container.QuestTitle.Title.Text:gsub("Kill ", ""):gsub(" %(%d+/%d+%)", "")
                local mobCount = questData.Container.QuestTitle.Title.Text:match("%((%d+)/(%d+)%)")
                
                if mobCount then
                    local current, total = mobCount:match("(%d+)/(%d+)")
                    if tonumber(current) < tonumber(total) then
                        -- Procurar e matar mobs
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                repeat
                                    -- Teleportar para o mob
                                    local mobCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, Settings.Combat.FarmHeight, 0)
                                    Player.Character.HumanoidRootPart.CFrame = mobCFrame
                                    
                                    -- Ativar Fast Attack se disponível
                                    if Settings.Combat.FastAttack then
                                        ultraFastAttack()
                                    end
                                    
                                    -- Expandir Hitbox se ativado
                                    if Settings.Combat.HitboxExpander then
                                        expandHitbox(mob)
                                    end
                                    
                                    -- Auto Skill se ativado
                                    if Settings.Combat.AutoSkill then
                                        useSkills()
                                    end
                                    
                                    wait()
                                until not mob:FindFirstChild("Humanoid") or 
                                      not mob:FindFirstChild("HumanoidRootPart") or 
                                      mob.Humanoid.Health <= 0 or 
                                      not Settings.Farming.AutoQuest or
                                      not questData.Visible
                            end
                        end
                    else
                        -- Quest completa, pegar próxima
                        local args = {
                            [1] = "AbandonQuest"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end
            end
        end
        wait()
    end
end

-- Função auxiliar para usar skills automaticamente
local function useSkills()
    local skills = {"Z", "X", "C", "V", "F"}
    for _, skill in pairs(skills) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
    end
end

-- Função para verificar se está no mar correto
local function checkSea()
    local playerLevel = Player.Level.Value
    local currentSea = game.PlaceId
    
    if playerLevel >= 700 and currentSea == 2753915549 then -- First Sea
        createNotification("Nível suficiente para Second Sea! Mudando...", "success")
        local args = {
            [1] = "TravelDressrosa" -- Second Sea
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif playerLevel >= 1500 and currentSea == 4442272183 then -- Second Sea
        createNotification("Nível suficiente para Third Sea! Mudando...", "success")
        local args = {
            [1] = "TravelZou" -- Third Sea
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end

-- Função para coletar drops próximos
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
end

-- Melhorar a função principal do AutoQuest
local function enhancedAutoQuest()
    -- Verificar mar atual
    checkSea()
    
    -- Iniciar loop principal
    spawn(function()
        while Settings.Farming.AutoQuest do
            -- Coletar drops automaticamente
            collectDrops()
            
            -- Executar AutoQuest normal
            autoQuest()
            
            -- Pequena pausa para não sobrecarregar
            wait(0.1)
        end
    end)
end

-- Fruit Sniper
local function fruitSniper()
    while Settings.Farming.FruitSniper do
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
                Player.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                wait(0.5)
                fireproximityprompt(fruit.ProximityPrompt)
            end
        end
        wait(1)
    end
end

-- Boss Sniper
local function bossSniper()
    while Settings.Farming.BossSniper do
        for _, boss in pairs(workspace.Bosses:GetChildren()) do
            if boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                createNotification("Boss encontrado: " .. boss.Name, "success")
                Settings.Combat.AutoFarm = false
                wait(0.5)
                
                while boss.Humanoid.Health > 0 do
                    Player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    if Settings.Combat.FastAttack then
                        ultraFastAttack()
                    end
                    wait()
                end
                
                Settings.Combat.AutoFarm = true
            end
        end
        wait(1)
    end
end

-- Criar Botões e Menus
local function createMainMenu()
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Theme.DarkContrast
    title.Text = "THEUS HUB V2"
    title.TextColor3 = Theme.AccentColor
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = MainFrame
    
    createCorner(title)
    
    local buttonY = 50
    local function addButton(text, setting)
        local btn = createButton(text, UDim2.new(0.05, 0, 0, buttonY))
        buttonY = buttonY + 50
        
        btn.MouseButton1Click:Connect(function()
            Settings[setting] = not Settings[setting]
            btn.BackgroundColor3 = Settings[setting] and Theme.Success or Theme.DarkContrast
            createNotification(text .. (Settings[setting] and " Ativado" or " Desativado"), Settings[setting] and "success" or "error")
        end)
    end
    
    addButton("Auto Farm", "Combat.AutoFarm")
    addButton("Fast Attack", "Combat.FastAttack")
    addButton("Kill Aura", "Combat.KillAura")
    addButton("Hitbox Expander", "Combat.HitboxExpander")
    addButton("Auto Quest", "Farming.AutoQuest")
    addButton("Fruit Sniper", "Farming.FruitSniper")
    addButton("Boss Sniper", "Farming.BossSniper")
    addButton("ESP Players", "Visual.ESP.Players")
    addButton("ESP Mobs", "Visual.ESP.Mobs")
    addButton("No Clip", "Movement.NoClip")
end

-- Inicialização
createMainMenu()

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Key System
local function createKeySystem()
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 300, 0, 150)
    keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    keyFrame.BackgroundColor3 = Theme.Background
    keyFrame.Parent = ScreenGui
    
    createCorner(keyFrame)
    
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, 0, 0, 30)
    keyTitle.Text = "THEUS HUB V2 - KEY SYSTEM"
    keyTitle.TextColor3 = Theme.AccentColor
    keyTitle.TextSize = 16
    keyTitle.Font = Enum.Font.GothamBold
    keyTitle.Parent = keyFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0.8, 0, 0, 30)
    keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    keyInput.BackgroundColor3 = Theme.DarkContrast
    keyInput.TextColor3 = Theme.TextColor
    keyInput.TextSize = 14
    keyInput.PlaceholderText = "Enter Key..."
    keyInput.Parent = keyFrame
    
    createCorner(keyInput)
    
    local submitButton = createButton("Submit", UDim2.new(0.1, 0, 0.7, 0))
    submitButton.Parent = keyFrame
    
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == "THEUSHUB" then
            keyFrame:Destroy()
            MainFrame.Visible = true
            createNotification("Key correta! Bem-vindo ao Theus Hub V2", "success")
        else
            keyInput.Text = ""
            createNotification("Key incorreta!", "error")
        end
    end)
    
    MainFrame.Visible = false
end

createKeySystem()

-- Iniciar funções principais
RunService.Heartbeat:Connect(function()
    if Settings.Combat.AutoFarm then autoFarm() end
    if Settings.Combat.KillAura then killAura() end
    if Settings.Farming.AutoQuest then autoQuest() end
    if Settings.Farming.FruitSniper then fruitSniper() end
    if Settings.Farming.BossSniper then bossSniper() end
end)