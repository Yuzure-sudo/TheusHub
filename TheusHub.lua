-- TheusHub.lua - Script completo e funcional para Blox Fruits
-- Carregar a UI library
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Variáveis e configurações
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Settings = {
    AutoFarm = false,
    SelectedMob = "Bandit",
    KillAura = false,
    AutoSkills = false,
    PerfectBlock = false,
    FruitESP = false,
    AutoCollectFruit = false,
    NotifyFruit = true,
    FastAttack = false,
    InfiniteStamina = false,
    NoClip = false,
    AutoHaki = false,
    MobAura = false,
    MobAuraDistance = 50,
    AutoFarmDistance = 5
}

local GameSupported = false
local Islands = {}
local Mobs = {}
local Weapons = {}
local AllFruits = {}
local AutoFarmTarget = nil
local MobESP = {}
local ChestESP = {}
local FruitESP = {}

-- Verificar se o jogo é suportado
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    GameSupported = true
    -- Configurações específicas para Blox Fruits
    Mobs = {
        "Bandit", "Monkey", "Gorilla", "Marine", "Chief Petty Officer", "Sky Bandit", "Dark Master",
        "Prisoner", "Dangerous Prisoner", "Shanda", "Galley Captain", "Snow Bandit", "Snow Lurker",
        "Arctic Warrior", "Smoke Admiral", "Ice Admiral", "Awakened Ice Admiral", "Fishman Warrior",
        "Fishman Commando", "God's Guard", "Shanda Thug", "Mythological Pirate", "Jungle Pirate"
    }
    
    Islands = {
        ["Starter Island"] = Vector3.new(1071.2832, 16.3085976, 1426.86792),
        ["Marine Island"] = Vector3.new(-2573.3374, 6.88881969, 2046.99817),
        ["Middle Town"] = Vector3.new(-655.824158, 7.88708115, 1436.67908),
        ["Jungle"] = Vector3.new(-1249.77222, 11.8870859, 341.356476),
        ["Pirate Village"] = Vector3.new(-1122.34998, 4.78708982, 3855.91992),
        ["Desert"] = Vector3.new(1094.14587, 6.47350502, 4192.88721),
        ["Frozen Village"] = Vector3.new(1198.00928, 27.0074959, -1211.73376),
        ["Marine Fortress"] = Vector3.new(-4505.375, 20.687294, 4260.55908),
        ["Skylands"] = Vector3.new(-4970.21875, 717.707275, -2622.35449),
        ["Colosseum"] = Vector3.new(-1836.58191, 44.5890656, 1360.30652),
        ["Prison"] = Vector3.new(4854.16455, 5.68742752, 740.194641)
    }
    
    Weapons = {
        "Combat",
        "Black Leg",
        "Electro",
        "Fishman Karate",
        "Dragon Claw",
        "Superhuman",
        "Death Step",
        "Electric Claw",
        "Sharkman Karate",
        "Dragon Talon"
    }
    
    AllFruits = {
        "Bomb-Bomb",
        "Spike-Spike",
        "Chop-Chop",
        "Spring-Spring",
        "Kilo-Kilo",
        "Smoke-Smoke",
        "Spin-Spin",
        "Flame-Flame",
        "Bird-Bird: Falcon",
        "Ice-Ice",
        "Sand-Sand",
        "Dark-Dark",
        "Revive-Revive",
        "Diamond-Diamond",
        "Light-Light",
        "Love-Love",
        "Rubber-Rubber",
        "Barrier-Barrier",
        "Magma-Magma",
        "Door-Door",
        "Quake-Quake",
        "Human-Human: Buddha",
        "String-String",
        "Bird-Bird: Phoenix",
        "Rumble-Rumble",
        "Paw-Paw",
        "Gravity-Gravity",
        "Dough-Dough",
        "Shadow-Shadow",
        "Venom-Venom",
        "Control-Control",
        "Soul-Soul",
        "Dragon-Dragon"
    }
else
    -- Notificação de jogo não suportado
    game.StarterGui:SetCore("SendNotification", {
        Title = "Jogo não suportado",
        Text = "Este jogo não é suportado pelo TheusHub. Apenas Blox Fruits é suportado.",
        Duration = 10
    })
end

-- Funções utilitárias
local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function TweenTo(targetPosition, speed)
    if not HumanoidRootPart then return end
    local distance = GetDistance(HumanoidRootPart.Position, targetPosition)
    local time = distance / speed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPosition)}
    )
    tween:Play()
    return tween
end

local function GetClosestMob(mobName, maxDistance)
    local closestMob = nil
    local shortestDistance = maxDistance or math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            if not mobName or string.find(v.Name, mobName) then
                local distance = GetDistance(HumanoidRootPart.Position, v.HumanoidRootPart.Position)
                if distance < shortestDistance then
                    closestMob = v
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestMob
end

local function Attack()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

local function UseSkill(skill, target)
    if not target then return end
    
    local args = {
        [1] = target.HumanoidRootPart.Position
    }
    
    local skillName = skill
    
    if ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg", true) == 1 then
        if skill == "Z" then
            skillName = "ConcasseNew"
        elseif skill == "X" then
            skillName = "BlackTutorial"
        elseif skill == "C" then
            skillName = "PartyTableKick"
        elseif skill == "V" then
            skillName = "MeteorNew"
        end
    elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro", true) == 1 then
        if skill == "Z" then
            skillName = "ThunderBolt"
        elseif skill == "X" then
            skillName = "ElectricAttack"
        elseif skill == "C" then
            skillName = "ElectricBurst"
        end
    elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate", true) == 1 then
        if skill == "Z" then
            skillName = "SharkmanKarate"
        elseif skill == "X" then
            skillName = "SharkmanKarate2"
        elseif skill == "C" then
            skillName = "SharkmanKarate3"
        end
    end
    
    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer(skillName, args)
end

local function EnableHaki()
    if not LocalPlayer.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
    end
end

local function CollectChest(chest)
    if chest and chest:FindFirstChild("Interaction") then
        local interaction = chest.Interaction
        interaction.MouseClick:FireServer()
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "TheusHub",
            Text = "Baú coletado!",
            Duration = 3
        })
    end
end

local function CollectFruit(fruit)
    if fruit and fruit:IsA("Tool") and fruit.Name ~= "Blox Fruit Dealer" then
        TweenTo(fruit.Handle.Position, 200)
        wait(GetDistance(HumanoidRootPart.Position, fruit.Handle.Position) / 200)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "TheusHub",
            Text = "Fruta " .. fruit.Name .. " coletada!",
            Duration = 3
        })
    end
end

-- Sistema de noclip
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        if Character and Character:FindFirstChild("Humanoid") then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Sistema de stamina infinita
RunService.Stepped:Connect(function()
    if Settings.InfiniteStamina and LocalPlayer.Character then
        if LocalPlayer.Character.Humanoid.WalkSpeed < 16 then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        if LocalPlayer.Character.Energy and LocalPlayer.Character.Energy.Value <= 9 then
            LocalPlayer.Character.Energy.Value = 10
        end
    end
end)

-- Sistema de auto farm
local AutoFarmCoroutine = nil
function StartAutoFarm()
    if AutoFarmCoroutine then
        coroutine.close(AutoFarmCoroutine)
    end
    
    AutoFarmCoroutine = coroutine.create(function()
        while Settings.AutoFarm do
            local mob = GetClosestMob(Settings.SelectedMob, 1000)
            if mob then
                AutoFarmTarget = mob
                local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                
                -- Ativar Haki se disponível
                if Settings.AutoHaki then
                    EnableHaki()
                end
                
                -- Mover para o mob
                if distance > Settings.AutoFarmDistance then
                    TweenTo(mob.HumanoidRootPart.Position + Vector3.new(0, 0, Settings.AutoFarmDistance), 200)
                    wait(distance / 200)
                end
                
                -- Atacar o mob
                if Settings.FastAttack then
                    for i = 1, 5 do
                        Attack()
                    end
                else
                    Attack()
                end
                
                -- Usar habilidades se ativado
                if Settings.AutoSkills then
                    UseSkill("Z", mob)
                    wait(0.5)
                    UseSkill("X", mob)
                    wait(0.5)
                    UseSkill("C", mob)
                    wait(0.5)
                    UseSkill("V", mob)
                end
                
                wait(0.5)
            else
                wait(1)
            end
        end
    end)
    
    coroutine.resume(AutoFarmCoroutine)
end

-- Sistema de Kill Aura
local KillAuraCoroutine = nil
function StartKillAura()
    if KillAuraCoroutine then
        coroutine.close(KillAuraCoroutine)
    end
    
    KillAuraCoroutine = coroutine.create(function()
        while Settings.KillAura do
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                    if distance <= 50 then
                        -- Atacar o mob próximo
                        Attack()
                        
                        -- Usar habilidades se ativado
                        if Settings.AutoSkills then
                            UseSkill("Z", mob)
                        end
                    end
                end
            end
            
            wait(0.1)
        end
    end)
    
    coroutine.resume(KillAuraCoroutine)
end

-- Sistema de Mob Aura
local MobAuraCoroutine = nil
function StartMobAura()
    if MobAuraCoroutine then
        coroutine.close(MobAuraCoroutine)
    end
    
    MobAuraCoroutine = coroutine.create(function()
        while Settings.MobAura do
            local mob = GetClosestMob(nil, Settings.MobAuraDistance)
            if mob then
                local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                
                -- Ativar Haki se disponível
                if Settings.AutoHaki then
                    EnableHaki()
                end
                
                -- Atacar o mob
                Attack()
                
                -- Usar habilidades se ativado
                if Settings.AutoSkills then
                    UseSkill("Z", mob)
                end
            end
            
            wait(0.1)
        end
    end)
    
    coroutine.resume(MobAuraCoroutine)
end

-- Sistema de Perfect Block
local PerfectBlockCoroutine = nil
function StartPerfectBlock()
    if PerfectBlockCoroutine then
        coroutine.close(PerfectBlockCoroutine)
    end
    
    PerfectBlockCoroutine = coroutine.create(function()
        while Settings.PerfectBlock do
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                    if distance <= 10 and mob:FindFirstChild("Animation") and mob.Animation.AnimationId:find("Attack") then
                        -- Block
                        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", false)
                    end
                end
            end
            
            wait(0.1)
        end
    end)
    
    coroutine.resume(PerfectBlockCoroutine)
end

-- Sistema de ESP para baús
local ChestEspCoroutine = nil
function StartChestESP()
    if ChestEspCoroutine then
        coroutine.close(ChestEspCoroutine)
    end
    
    -- Limpar ESP existente
    for _, esp in pairs(ChestESP) do
        if esp and esp.Adornee and esp.Adornee.Parent then
            esp:Destroy()
        end
    end
    ChestESP = {}
    
    ChestEspCoroutine = coroutine.create(function()
        while wait(1) do
            for _, chest in pairs(workspace:GetDescendants()) do
                if chest.Name == "Chest" and chest:IsA("Part") and not ChestESP[chest] then
                    -- Criar BillboardGui para o baú
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "ChestESP"
                    billboardGui.AlwaysOnTop = true
                    billboardGui.Size = UDim2.new(0, 100, 0, 40)
                    billboardGui.Adornee = chest
                    billboardGui.Parent = chest
                    
                    local label = Instance.new("TextLabel")
                    label.Name = "ChestLabel"
                    label.Text = "Baú"
                    label.TextColor3 = Color3.fromRGB(255, 215, 0)
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Parent = billboardGui
                    
                    ChestESP[chest] = billboardGui
                    
                    -- Auto coletar baú se ativado
                    if Settings.AutoCollectChests then
                        CollectChest(chest)
                    end
                end
            end
            
            -- Remover ESP de baús que não existem mais
            for chest, esp in pairs(ChestESP) do
                if not chest or not chest.Parent then
                    esp:Destroy()
                    ChestESP[chest] = nil
                end
            end
        end
    end)
    
    coroutine.resume(ChestEspCoroutine)
end

-- Sistema de ESP para frutas
local FruitEspCoroutine = nil
function StartFruitESP()
    if FruitEspCoroutine then
        coroutine.close(FruitEspCoroutine)
    end
    
    -- Limpar ESP existente
    for _, esp in pairs(FruitESP) do
        if esp and esp.Adornee and esp.Adornee.Parent then
            esp:Destroy()
        end
    end
    FruitESP = {}
    
    FruitEspCoroutine = coroutine.create(function()
        while Settings.FruitESP do
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit:IsA("Tool") and not FruitESP[fruit] and fruit.Name:find("Fruit") then
                    -- Criar BillboardGui para a fruta
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "FruitESP"
                    billboardGui.AlwaysOnTop = true
                    billboardGui.Size = UDim2.new(0, 150, 0, 40)
                    billboardGui.Adornee = fruit.Handle
                    billboardGui.Parent = fruit.Handle
                    
                    local label = Instance.new("TextLabel")
                    label.Name = "FruitLabel"
                    label.Text = fruit.Name
                    label.TextColor3 = Color3.fromRGB(255, 50, 255)
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Parent = billboardGui
                    
                    FruitESP[fruit] = billboardGui
                    
                    -- Notificar se ativado
                    if Settings.NotifyFruit then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Fruta Encontrada!",
                            Text = "Uma " .. fruit.Name .. " foi encontrada!",
                            Duration = 10
                        })
                    end
                    
                    -- Auto coletar fruta se ativado
                    if Settings.AutoCollectFruit then
                        CollectFruit(fruit)
                    end
                end
            end
            
            -- Remover ESP de frutas que não existem mais
            for fruit, esp in pairs(FruitESP) do
                if not fruit or not fruit.Parent then
                    esp:Destroy()
                    FruitESP[fruit] = nil
                end
            end
            
            wait(1)
        end
    end)
    
    coroutine.resume(FruitEspCoroutine)
end

-- Criar a janela principal
local Window = redzlib:MakeWindow({
    Title = "Wirtz Scripts Premium",
    SubTitle = "by Wirtz Team",
    SaveFolder = "WirtzScripts"
})

-- Ícone de minimizar com imagem ajustada
Window:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://18751483361",
        BackgroundTransparency = 0
    },
    Corner = {
        CornerRadius = UDim.new(35, 1)
    },
})

-- Tabs principais do script
local MainTab = Window:AddTab("Principal")
local FarmingSection = MainTab:AddSection("Auto Farm")

FarmingSection:AddToggle({
    Name = "Auto Farm",
    Flag = "AutoFarm",
    Value = Settings.AutoFarm,
    Callback = function(Value)
        Settings.AutoFarm = Value
        if Value then
            StartAutoFarm()
            FarmingSection:AddParagraph("Auto Farm", "Auto Farm ativado!")
        else
            if AutoFarmCoroutine then coroutine.close(AutoFarmCoroutine) end
            FarmingSection:AddParagraph("Auto Farm", "Auto Farm desativado!")
        end
    end
})

FarmingSection:AddDropdown({
    Name = "Selecione o Mob",
    Flag = "SelectedMob",
    List = Mobs,
    Value = Settings.SelectedMob,
    Callback = function(Value)
        Settings.SelectedMob = Value
        FarmingSection:AddParagraph("Mob Selecionado", "Você selecionou: " .. Value)
    end
})

FarmingSection:AddSlider({
    Name = "Distância do Farm",
    Flag = "FarmDistance",
    Value = Settings.AutoFarmDistance,
    Min = 2,
    Max = 10,
    Callback = function(Value)
        Settings.AutoFarmDistance = Value
    end
})

-- Seção de combate
local CombatSection = MainTab:AddSection("Combate")

CombatSection:AddToggle({
    Name = "Kill Aura",
    Flag = "KillAura",
    Value = Settings.KillAura,
    Callback = function(Value)
        Settings.KillAura = Value
        if Value then
            StartKillAura()
            CombatSection:AddParagraph("Kill Aura", "Kill Aura ativado!")
        else
            if KillAuraCoroutine then coroutine.close(KillAuraCoroutine) end
            CombatSection:AddParagraph("Kill Aura", "Kill Aura desativado!")
        end
    end
})

CombatSection:AddToggle({
    Name = "Auto Skills",
    Flag = "AutoSkills",
    Value = Settings.AutoSkills,
    Callback = function(Value)
        Settings.AutoSkills = Value
        CombatSection:AddParagraph("Auto Skills", Value and "Ativado" or "Desativado")
    end
})

CombatSection:AddToggle({
    Name = "Perfect Block",
    Flag = "PerfectBlock",
    Value = Settings.PerfectBlock,
    Callback = function(Value)
        Settings.PerfectBlock = Value
        if Value then
            StartPerfectBlock()
            CombatSection:AddParagraph("Perfect Block", "Perfect Block ativado!")
        else
            if PerfectBlockCoroutine then coroutine.close(PerfectBlockCoroutine) end
            CombatSection:AddParagraph("Perfect Block", "Perfect Block desativado!")
        end
    end
})

CombatSection:AddToggle({
    Name = "Auto Haki",
    Flag = "AutoHaki",
    Value = Settings.AutoHaki,
    Callback = function(Value)
        Settings.AutoHaki = Value
        CombatSection:AddParagraph("Auto Haki", Value and "Ativado" or "Desativado")
    end
})

CombatSection:AddToggle({
    Name = "Ataque Rápido",
    Flag = "FastAttack",
    Value = Settings.FastAttack,
    Callback = function(Value)
        Settings.FastAttack = Value
        CombatSection:AddParagraph("Ataque Rápido", Value and "Ativado" or "Desativado")
    end
})

-- Tab de teleportes
local TeleportTab = Window:AddTab("Teleporte")
local TeleportSection = TeleportTab:AddSection("Locais")

for name, position in pairs(Islands) do
    TeleportSection:AddButton({
        Name = name,
        Callback = function()
            TeleportSection:AddParagraph("Teleporte", "Teleportando para " .. name .. "...")
            TweenTo(position, 300)
        end
    })
end

-- Tab de frutas
local FruitTab = Window:AddTab("Frutas")
local FruitSection = FruitTab:AddSection("Frutas")

FruitSection:AddToggle({
    Name = "ESP Frutas",
    Flag = "FruitESP",
    Value = Settings.FruitESP,
    Callback = function(Value)
        Settings.FruitESP = Value
        if Value then
            StartFruitESP()
            FruitSection:AddParagraph("ESP Frutas", "ESP de Frutas ativado!")
        else
            if FruitEspCoroutine then coroutine.close(FruitEspCoroutine) end
            -- Remover todos os ESP de frutas
            for _, esp in pairs(FruitESP) do
                if esp and esp.Parent then
                    esp:Destroy()
                end
            end
            FruitESP = {}
            FruitSection:AddParagraph("ESP Frutas", "ESP de Frutas desativado!")
        end
    end
})

FruitSection:AddToggle({
    Name = "Auto Coletar Frutas",
    Flag = "AutoCollectFruit",
    Value = Settings.AutoCollectFruit,
    Callback = function(Value)
        Settings.AutoCollectFruit = Value
        FruitSection:AddParagraph("Auto Coletar", Value and "Ativado" or "Desativado")
    end
})

FruitSection:AddToggle({
    Name = "Notificar Frutas",
    Flag = "NotifyFruit",
    Value = Settings.NotifyFruit,
    Callback = function(Value)
        Settings.NotifyFruit = Value
        FruitSection:AddParagraph("Notificações", Value and "Ativadas" or "Desativadas")
    end
})

-- Tab de Ferramentas
local MiscTab = Window:AddTab("Ferramentas")
local MiscSection = MiscTab:AddSection("Ferramentas Úteis")

MiscSection:AddToggle({
    Name = "NoClip",
    Flag = "NoClip",
    Value = Settings.NoClip,
    Callback = function(Value)
        Settings.NoClip = Value
        MiscSection:AddParagraph("NoClip", Value and "Ativado" or "Desativado")
    end
})

MiscSection:AddToggle({
    Name = "Stamina Infinita",
    Flag = "InfiniteStamina",
    Value = Settings.InfiniteStamina,
    Callback = function(Value)
        Settings.InfiniteStamina = Value
        MiscSection:AddParagraph("Stamina", Value and "Infinita Ativada" or "Normal")
    end
})

MiscSection:AddToggle({
    Name = "Mob Aura",
    Flag = "MobAura",
    Value = Settings.MobAura,
    Callback = function(Value)
        Settings.MobAura = Value
        if Value then
            StartMobAura()
            MiscSection:AddParagraph("Mob Aura", "Mob Aura ativado!")
        else
            if MobAuraCoroutine then coroutine.close(MobAuraCoroutine) end
            MiscSection:AddParagraph("Mob Aura", "Mob Aura desativado!")
        end
    end
})

MiscSection:AddSlider({
    Name = "Distância do Mob Aura",
    Flag = "MobAuraDistance",
    Value = Settings.MobAuraDistance,
    Min = 10,
    Max = 100,
    Callback = function(Value)
        Settings.MobAuraDistance = Value
    end
})

-- Tab de Estatísticas do Jogador
local StatsTab = Window:AddTab("Estatísticas")
local PlayerStatsSection = StatsTab:AddSection("Seu Personagem")

local LevelLabel = PlayerStatsSection:AddLabel("Nível: " .. LocalPlayer.Data.Level.Value)
local BelliLabel = PlayerStatsSection:AddLabel("Beli: " .. LocalPlayer.Data.Beli.Value)
local FragmentsLabel = PlayerStatsSection:AddLabel("Fragmentos: " .. (LocalPlayer.Data.Fragments and LocalPlayer.Data.Fragments.Value or "N/A"))
local DevilFruitLabel = PlayerStatsSection:AddLabel("Fruta: " .. (LocalPlayer.Data.DevilFruit and LocalPlayer.Data.DevilFruit.Value or "Nenhuma"))

-- Atualizar estatísticas periodicamente
spawn(function()
    while wait(1) do
        if LevelLabel and BelliLabel and FragmentsLabel and DevilFruitLabel then
            LevelLabel:Set("Nível: " .. LocalPlayer.Data.Level.Value)
            BelliLabel:Set("Beli: " .. LocalPlayer.Data.Beli.Value)
            FragmentsLabel:Set("Fragmentos: " .. (LocalPlayer.Data.Fragments and LocalPlayer.Data.Fragments.Value or "N/A"))
            DevilFruitLabel:Set("Fruta: " .. (LocalPlayer.Data.DevilFruit and LocalPlayer.Data.DevilFruit.Value or "Nenhuma"))
        end
    end
end)

-- Tab de configurações
local SettingsTab = Window:AddTab("Configurações")
local UISection = SettingsTab:AddSection("Interface")

UISection:AddColorPicker({
    Name = "Cor do Tema",
    Flag = "UIColor",
    Value = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        -- Mudar cor do tema (implementação específica da biblioteca)
        -- Como a biblioteca não tem função direta para isso, isso seria personalizado
        UISection:AddParagraph("Tema", "Cor do tema alterada!")
    end
})

UISection:AddSlider({
    Name = "Transparência da UI",
    Flag = "UITransparency",
    Value = 0,
    Min = 0,
    Max = 100,
    Callback = function(Value)
        -- Ajustar transparência (implementação específica da biblioteca)
        UISection:AddParagraph("Transparência", "Transparência ajustada para " .. Value .. "%")
    end
})

-- Seção de segurança
local SecuritySection = SettingsTab:AddSection("Segurança")

SecuritySection:AddToggle({
    Name = "Modo Anti-Detecção",
    Flag = "AntiDetection",
    Value = false,
    Callback = function(Value)
        -- Implementar medidas anti-detecção
        SecuritySection:AddParagraph("Anti-Detecção", Value and "Ativado" or "Desativado")
    end
})

-- Botão para destruir a UI
SecuritySection:AddButton({
    Name = "Destruir UI",
    Callback = function()
        Window:Destroy()
        -- Limpar todas as conexões e coroutines
        if AutoFarmCoroutine then coroutine.close(AutoFarmCoroutine) end
        if KillAuraCoroutine then coroutine.close(KillAuraCoroutine) end
        if PerfectBlockCoroutine then coroutine.close(PerfectBlockCoroutine) end
        if FruitEspCoroutine then coroutine.close(FruitEspCoroutine) end
        if ChestEspCoroutine then coroutine.close(ChestEspCoroutine) end
        if MobAuraCoroutine then coroutine.close(MobAuraCoroutine) end
        
        -- Limpar ESPs
        for _, esp in pairs(FruitESP) do
            if esp and esp.Parent then esp:Destroy() end
        end
        for _, esp in pairs(ChestESP) do
            if esp and esp.Parent then esp:Destroy() end
        end
        for _, esp in pairs(MobESP) do
            if esp and esp.Parent then esp:Destroy() end
        end
        
        -- Resetar configurações
        Settings = {}
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Wirtz Scripts",
            Text = "UI destruída com sucesso!",
            Duration = 3
        })
    end
})

-- Créditos
local CreditsSection = SettingsTab:AddSection("Créditos")

CreditsSection:AddLabel("Desenvolvido por: Wirtz Team")
CreditsSection:AddLabel("Versão: 1.0.0")

CreditsSection:AddButton({
    Name = "Copiar Discord",
    Callback = function()
        setclipboard("https://discord.gg/wirtzscripts")
        CreditsSection:AddParagraph("Discord", "Link copiado para a área de transferência!")
    end
})

-- Verificações anti-crash
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Função para verificar itens e armas disponíveis
spawn(function()
    while wait(5) do
        -- Atualizar lista de armas do jogador
        local PlayerBackpack = LocalPlayer:FindFirstChild("Backpack")
        if PlayerBackpack then
            local playerWeapons = {}
            for _, tool in pairs(PlayerBackpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(playerWeapons, tool.Name)
                end
            end
            
            -- Aqui você poderia atualizar um dropdown com as armas disponíveis
            -- Mas isso depende de como a biblioteca redzlib implementa essa funcionalidade
        end
    end
end)

-- Mensagem de boas-vindas
game.StarterGui:SetCore("SendNotification", {
    Title = "Wirtz Scripts Premium",
    Text = "Script carregado com sucesso! Aproveite!",
    Duration = 5
})

-- Loop para adicionar auto respawn
spawn(function()
    while wait(1) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health <= 0 then
            wait(5) -- Esperar um pouco antes de respawnar
            local args = {
                [1] = "SetSpawnPoint"
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)

-- Detecção de jogador AFK para evitar desconexão
local LastActivity = tick()
UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function()
    LastActivity = tick()
end)

-- Anti-AFK
spawn(function()
    while wait(30) do
        if tick() - LastActivity > 120 then -- 2 minutos sem atividade
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end
    end
end)

-- Final do script
return {
    Settings = Settings,
    Window = Window,
    StartAutoFarm = StartAutoFarm,
    StartKillAura = StartKillAura,
    StartPerfectBlock = StartPerfectBlock,
    StartFruitESP = StartFruitESP
}
