-- Blox Fruits Ultimate Script (Parte 1/10 - Configurações Iniciais)
local TweenService = game:GetService("TweenService")
local Interface = script.Parent:WaitForChild("Part9") -- Carrega a interface da Parte 9

-- Configurações Gerais
local Config = {
    AutoHaki = true, -- Ativa o Haki automaticamente
    BringMob = true, -- Traz os inimigos (mobs) para perto
    DistanceMob = 30, -- Distância dos inimigos (mobs)
    FastAttack = true -- Ativa o ataque rápido
}

-- Função de ataque
local function AttackFunction()
    -- Lógica de ataque aqui
end

-- Parte 1 concluída

-- Blox Fruits Ultimate Script (Parte 2/10 - Sistema de Farm e Quest do First Sea)
local TweenService = game:GetService("TweenService")
local Interface = require(script.Parent:WaitForChild("Part9")) -- Carrega a interface da Parte 9

-- Tabela de Mobs e Quests do First Sea
local FirstSeaMobsTable = {
    ['Bandit'] = {
        Quest = {
            Name = "BanditQuest1",
            LevelReq = 1,
            NameQuest = "Bandit Quest",
            QuestLabel = "Bandits (Lv. 1+)",
            CFrame = CFrame.new(1059.37195, 15.4495068, 1550.4231)
        },
        Name = "Bandit",
        CFrameSpawn = CFrame.new(1158.19141, 16.7761021, 1598.75867)
    },
    ['Monkey'] = {
        Quest = {
            Name = "MonkeyQuest",
            LevelReq = 14,
            NameQuest = "Monkey Quest",
            QuestLabel = "Monkey (Lv. 14+)",
            CFrame = CFrame.new(-1598.08911, 35.5501175, 153.377838)
        },
        Name = "Monkey",
        CFrameSpawn = CFrame.new(-1448.51806, 50.851993, 102.934296)
    },
    ['Gorilla'] = {
        Quest = {
            Name = "GorrillaQuest",
            LevelReq = 20,
            NameQuest = "Gorilla Quest",
            QuestLabel = "Gorilla (Lv. 20+)",
            CFrame = CFrame.new(-1379.81335, 24.9508553, -288.136475)
        },
        Name = "Gorilla",
        CFrameSpawn = CFrame.new(-1378.89258, 24.9508553, -229.291992)
    },
    ['Pirate'] = {
        Quest = {
            Name = "PirateQuest1",
            LevelReq = 30,
            NameQuest = "Pirate Quest",
            QuestLabel = "Pirate (Lv. 30+)",
            CFrame = CFrame.new(-1057.65222, 25.5923767, 3831.4563)
        },
        Name = "Pirate",
        CFrameSpawn = CFrame.new(-1163.66382, 5.34081984, 4032.30713)
    },
    ['Tribal Member'] = {
        Quest = {
            Name = "TribeMemberQuest",
            LevelReq = 35,
            NameQuest = "Tribe Member Quest",
            QuestLabel = "Tribal Member (Lv. 35+)",
            CFrame = CFrame.new(-3850.00098, 20.9700699, -697.999084)
        },
        Name = "Tribal Member",
        CFrameSpawn = CFrame.new(-3943.30957, 38.8274612, -697.299316)
    },
    ['Desert Bandit'] = {
        Quest = {
            Name = "DesertBanditQuest1",
            LevelReq = 45,
            NameQuest = "Desert Bandit Quest",
            QuestLabel = "Desert Bandit (Lv. 45+)",
            CFrame = CFrame.new(1114.26343, 4.8425708, 4350.59277)
        },
        Name = "Desert Bandit",
        CFrameSpawn = CFrame.new(1154.24487, 8.36347198, 4525.90918)
    },
    ['Fishman'] = {
        Quest = {
            Name = "FishmanQuest",
            LevelReq = 55,
            NameQuest = "Fishman Quest",
            QuestLabel = "Fishman (Lv. 55+)",
            CFrame = CFrame.new(-3054.44458, 236.834885, -10153.2529)
        },
        Name = "Fishman",
        CFrameSpawn = CFrame.new(-3118.16357, 236.834885, -10148.0273)
    },
    ['Pirate Captain'] = {
        Quest = {
            Name = "PiratePortQuest",
            LevelReq = 75,
            NameQuest = "Pirate Port Quest",
            QuestLabel = "Pirate Captain (Lv. 75+)",
            CFrame = CFrame.new(-289.81, 43.83, 5582.03)
        },
        Name = "Pirate Captain",
        CFrameSpawn = CFrame.new(-290.074677, 42.9034653, 5581.58984)
    }
}

-- Configurações de Farm
local FarmConfig = {
    FarmMode = "Auto", -- "Auto" ou "Manual"
    FarmTarget = nil, -- Inimigo alvo
    FarmDistance = 15, -- Distância de farm
    FarmSpeed = 50, -- Velocidade de farm
    FarmEnabled = false -- Flag para ativar/desativar farm
}

-- Configurações de Quest
local QuestConfig = {
    QuestEnabled = false, -- Flag para ativar/desativar quest
    CurrentQuest = nil, -- Quest atual
    QuestReward = 0 -- Recompensa da quest
}

-- Função para iniciar o farm
local function StartFarm()
    FarmConfig.FarmEnabled = true
    -- Lógica de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Encontrar e atacar mobs do First Sea
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            for MobName, MobData in pairs(FirstSeaMobsTable) do
                if Enemy.Name == MobData.Name then
                    repeat
                        wait()
                        
                        -- Auto Haki
                        if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                        
                        -- Bring Mob
                        if Config.BringMob then
                            Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                            Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            Enemy.HumanoidRootPart.Transparency = 0.8
                        end
                        
                        -- Attack
                        HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        if Config.FastAttack then
                            AttackFunction()
                        end
                        
                    until not FarmConfig.FarmEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0
                end
            end
        end
    end
end

-- Função para parar o farm
local function StopFarm()
    FarmConfig.FarmEnabled = false
    -- Lógica de parada de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Função para iniciar a quest
local function StartQuest()
    QuestConfig.QuestEnabled = true
    -- Lógica de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Level = Player.Data.Level.Value
    
    -- Encontrar Quest apropriada para o nível
    local CurrentQuest = nil
    local CurrentMob = nil
    
    for MobName, MobData in pairs(FirstSeaMobsTable) do
        if Level >= MobData.Quest.LevelReq then
            CurrentQuest = MobData.Quest
            CurrentMob = MobData
        end
    end
    
    if not CurrentQuest then return end
    
    -- Pegar Quest se não tiver
    if not Player.PlayerGui.Main.Quest.Visible then
        HumanoidRootPart.CFrame = CurrentQuest.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", CurrentQuest.Name, CurrentQuest.LevelReq)
        wait(0.5)
    end
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy.Name == CurrentMob.Name and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not QuestConfig.QuestEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0 or not Player.PlayerGui.Main.Quest.Visible
        end
    end
end

-- Função para parar a quest
local function StopQuest()
    QuestConfig.QuestEnabled = false
    -- Lógica de parada de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Criar botões de farm e quest na interface
local FarmButton = Interface.CreateTab("Farm")
FarmButton.MouseButton1Click:Connect(function()
    if FarmConfig.FarmEnabled then
        StopFarm()
    else
        StartFarm()
    end
end)

local QuestButton = Interface.CreateTab("Quest")
QuestButton.MouseButton1Click:Connect(function()
    if QuestConfig.QuestEnabled then
        StopQuest()
    else
        StartQuest()
    end
end)

-- Atualizar o status dos botões de farm e quest
local function UpdateFarmQuestStatus()
    if FarmConfig.FarmEnabled then
        FarmButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        FarmButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end

    if QuestConfig.QuestEnabled then
        QuestButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        QuestButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end
end

-- Loop principal
while true do
    wait(1)
    UpdateFarmQuestStatus()
    
    -- Lógica de farm e quest
    if FarmConfig.FarmEnabled then
        StartFarm()
    end
    
    if QuestConfig.QuestEnabled then
        StartQuest()
    end
end

-- Blox Fruits Ultimate Script (Parte 3/10 - Sistema de Farm e Quest do Second Sea)
local TweenService = game:GetService("TweenService")
local Interface = require(script.Parent:WaitForChild("Part9")) -- Carrega a interface da Parte 9

-- Tabela de Mobs e Quests do Second Sea
local SecondSeaMobsTable = {
    ['Sea Beast'] = {
        Quest = {
            Name = "SeaBeastQuest",
            LevelReq = 70,
            NameQuest = "Sea Beast Quest",
            QuestLabel = "Sea Beast (Lv. 70+)",
            CFrame = CFrame.new(82.9490662, 18.0710983, 33341.9062)
        },
        Name = "Sea Beast",
        CFrameSpawn = CFrame.new(83.0870209, 18.0710983, 33306.0039)
    },
    ['Cyclops'] = {
        Quest = {
            Name = "CyclopsQuest",
            LevelReq = 78,
            NameQuest = "Cyclops Quest",
            QuestLabel = "Cyclops (Lv. 78+)",
            CFrame = CFrame.new(-1765.54626, 198.997437, -16291.9062)
        },
        Name = "Cyclops",
        CFrameSpawn = CFrame.new(-1764.54626, 198.997437, -16292.9062)
    },
    ['Kraken'] = {
        Quest = {
            Name = "KrakenQuest",
            LevelReq = 82,
            NameQuest = "Kraken Quest",
            QuestLabel = "Kraken (Lv. 82+)",
            CFrame = CFrame.new(3806.2749, 12.9784794, -9707.7959)
        },
        Name = "Kraken",
        CFrameSpawn = CFrame.new(3806.2749, 12.9784794, -9707.7959)
    },
    ['Cursed Skeleton'] = {
        Quest = {
            Name = "CursedSkeletonQuest",
            LevelReq = 85,
            NameQuest = "Cursed Skeleton Quest",
            QuestLabel = "Cursed Skeleton (Lv. 85+)",
            CFrame = CFrame.new(5496.65527, 667.751343, -1408.12012)
        },
        Name = "Cursed Skeleton",
        CFrameSpawn = CFrame.new(5496.65527, 667.751343, -1408.12012)
    },
    ['Magma Ninja'] = {
        Quest = {
            Name = "MagmaNinjaQuest",
            LevelReq = 88,
            NameQuest = "Magma Ninja Quest",
            QuestLabel = "Magma Ninja (Lv. 88+)",
            CFrame = CFrame.new(-5496.65527, 424.026039, -5500.55371)
        },
        Name = "Magma Ninja",
        CFrameSpawn = CFrame.new(-5496.65527, 424.026039, -5500.55371)
    },
    ['Peanut Island Pirate'] = {
        Quest = {
            Name = "PeanutIslandPirateQuest",
            LevelReq = 92,
            NameQuest = "Peanut Island Pirate Quest",
            QuestLabel = "Peanut Island Pirate (Lv. 92+)",
            CFrame = CFrame.new(-10560.5576, 331.762634, -10551.9199)
        },
        Name = "Peanut Island Pirate",
        CFrameSpawn = CFrame.new(-10560.5576, 331.762634, -10551.9199)
    },
    ['Longma'] = {
        Quest = {
            Name = "LongmaQuest",
            LevelReq = 98,
            NameQuest = "Longma Quest",
            QuestLabel = "Longma (Lv. 98+)",
            CFrame = CFrame.new(-10248.9492, 353.79654, -10244.2832)
        },
        Name = "Longma",
        CFrameSpawn = CFrame.new(-10248.9492, 353.79654, -10244.2832)
    }
}

-- Configurações de Farm
local FarmConfig = {
    FarmMode = "Auto", -- "Auto" ou "Manual"
    FarmTarget = nil, -- Inimigo alvo
    FarmDistance = 15, -- Distância de farm
    FarmSpeed = 50, -- Velocidade de farm
    FarmEnabled = false -- Flag para ativar/desativar farm
}

-- Configurações de Quest
local QuestConfig = {
    QuestEnabled = false, -- Flag para ativar/desativar quest
    CurrentQuest = nil, -- Quest atual
    QuestReward = 0 -- Recompensa da quest
}

-- Função para iniciar o farm
local function StartFarm()
    FarmConfig.FarmEnabled = true
    -- Lógica de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Encontrar e atacar mobs do Second Sea
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            for MobName, MobData in pairs(SecondSeaMobsTable) do
                if Enemy.Name == MobData.Name then
                    repeat
                        wait()
                        
                        -- Auto Haki
                        if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                        
                        -- Bring Mob
                        if Config.BringMob then
                            Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                            Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            Enemy.HumanoidRootPart.Transparency = 0.8
                        end
                        
                        -- Attack
                        HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        if Config.FastAttack then
                            AttackFunction()
                        end
                        
                    until not FarmConfig.FarmEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0
                end
            end
        end
    end
end

-- Função para parar o farm
local function StopFarm()
    FarmConfig.FarmEnabled = false
    -- Lógica de parada de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Função para iniciar a quest
local function StartQuest()
    QuestConfig.QuestEnabled = true
    -- Lógica de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Level = Player.Data.Level.Value
    
    -- Encontrar Quest apropriada para o nível
    local CurrentQuest = nil
    local CurrentMob = nil
    
    for MobName, MobData in pairs(SecondSeaMobsTable) do
        if Level >= MobData.Quest.LevelReq then
            CurrentQuest = MobData.Quest
            CurrentMob = MobData
        end
    end
    
    if not CurrentQuest then return end
    
    -- Pegar Quest se não tiver
    if not Player.PlayerGui.Main.Quest.Visible then
        HumanoidRootPart.CFrame = CurrentQuest.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", CurrentQuest.Name, CurrentQuest.LevelReq)
        wait(0.5)
    end
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy.Name == CurrentMob.Name and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not QuestConfig.QuestEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0 or not Player.PlayerGui.Main.Quest.Visible
        end
    end
end

-- Função para parar a quest
local function StopQuest()
    QuestConfig.QuestEnabled = false
    -- Lógica de parada de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Criar botões de farm e quest na interface
local FarmButton = Interface.CreateTab("Farm")
FarmButton.MouseButton1Click:Connect(function()
    if FarmConfig.FarmEnabled then
        StopFarm()
    else
        StartFarm()
    end
end)

local QuestButton = Interface.CreateTab("Quest")
QuestButton.MouseButton1Click:Connect(function()
    if QuestConfig.QuestEnabled then
        StopQuest()
    else
        StartQuest()
    end
end)

-- Atualizar o status dos botões de farm e quest
local function UpdateFarmQuestStatus()
    if FarmConfig.FarmEnabled then
        FarmButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        FarmButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end

    if QuestConfig.QuestEnabled then
        QuestButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        QuestButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end
end

-- Loop principal
while true do
    wait(1)
    UpdateFarmQuestStatus()
    
    -- Lógica de farm e quest
    if FarmConfig.FarmEnabled then
        StartFarm()
    end
    
    if QuestConfig.QuestEnabled then
        StartQuest()
    end
end

-- Blox Fruits Ultimate Script (Parte 4/10 - Sistema de Farm e Quest do Third Sea)
local TweenService = game:GetService("TweenService")
local Interface = require(script.Parent:WaitForChild("Part9")) -- Carrega a interface da Parte 9

-- Tabela de Mobs e Quests do Third Sea
local ThirdSeaMobsTable = {
    ['Ghoul'] = {
        Quest = {
            Name = "GhoulQuest",
            LevelReq = 100,
            NameQuest = "Ghoul Quest",
            QuestLabel = "Ghoul (Lv. 100+)",
            CFrame = CFrame.new(-5533.29785, 313.851196, -2926.53564)
        },
        Name = "Ghoul",
        CFrameSpawn = CFrame.new(-5574.59717, 313.199615, -2945.93506)
    },
    ['Shadow'] = {
        Quest = {
            Name = "ShadowQuest",
            LevelReq = 105,
            NameQuest = "Shadow Quest",
            QuestLabel = "Shadow (Lv. 105+)",
            CFrame = CFrame.new(5344.28565, 392.961182, 203.493622)
        },
        Name = "Shadow",
        CFrameSpawn = CFrame.new(5328.47168, 392.961182, 228.568481)
    },
    ['Reaper'] = {
        Quest = {
            Name = "ReaperQuest",
            LevelReq = 110,
            NameQuest = "Reaper Quest",
            QuestLabel = "Reaper (Lv. 110+)",
            CFrame = CFrame.new(5544.3291, 743.301819, 188.282806)
        },
        Name = "Reaper",
        CFrameSpawn = CFrame.new(5579.04834, 743.301819, 158.961853)
    },
    ['Vampire'] = {
        Quest = {
            Name = "VampireQuest",
            LevelReq = 120,
            NameQuest = "Vampire Quest",
            QuestLabel = "Vampire (Lv. 120+)",
            CFrame = CFrame.new(-6026.96484, 6.4457197, -1319.45557)
        },
        Name = "Vampire",
        CFrameSpawn = CFrame.new(-6030.32031, 6.4457197, -1314.95227)
    },
    ['Demon'] = {
        Quest = {
            Name = "DemonQuest",
            LevelReq = 125,
            NameQuest = "Demon Quest",
            QuestLabel = "Demon (Lv. 125+)",
            CFrame = CFrame.new(-9515.37109, 315.251282, 6479.42773)
        },
        Name = "Demon",
        CFrameSpawn = CFrame.new(-9521.39258, 315.251282, 6470.30762)
    },
    ['Cyborg'] = {
        Quest = {
            Name = "CyborgQuest",
            LevelReq = 130,
            NameQuest = "Cyborg Quest",
            QuestLabel = "Cyborg (Lv. 130+)",
            CFrame = CFrame.new(-6248.46875, 429.447784, -3436.89795)
        },
        Name = "Cyborg",
        CFrameSpawn = CFrame.new(-6257.70068, 429.447784, -3443.46777)
    }
}

-- Configurações de Farm
local FarmConfig = {
    FarmMode = "Auto", -- "Auto" ou "Manual"
    FarmTarget = nil, -- Inimigo alvo
    FarmDistance = 15, -- Distância de farm
    FarmSpeed = 50, -- Velocidade de farm
    FarmEnabled = false -- Flag para ativar/desativar farm
}

-- Configurações de Quest
local QuestConfig = {
    QuestEnabled = false, -- Flag para ativar/desativar quest
    CurrentQuest = nil, -- Quest atual
    QuestReward = 0 -- Recompensa da quest
}

-- Função para iniciar o farm
local function StartFarm()
    FarmConfig.FarmEnabled = true
    -- Lógica de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Encontrar e atacar mobs do Third Sea
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            for MobName, MobData in pairs(ThirdSeaMobsTable) do
                if Enemy.Name == MobData.Name then
                    repeat
                        wait()
                        
                        -- Auto Haki
                        if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                        
                        -- Bring Mob
                        if Config.BringMob then
                            Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                            Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            Enemy.HumanoidRootPart.Transparency = 0.8
                        end
                        
                        -- Attack
                        HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        if Config.FastAttack then
                            AttackFunction()
                        end
                        
                    until not FarmConfig.FarmEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0
                end
            end
        end
    end
end

-- Função para parar o farm
local function StopFarm()
    FarmConfig.FarmEnabled = false
    -- Lógica de parada de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Função para iniciar a quest
local function StartQuest()
    QuestConfig.QuestEnabled = true
    -- Lógica de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Level = Player.Data.Level.Value
    
    -- Encontrar Quest apropriada para o nível
    local CurrentQuest = nil
    local CurrentMob = nil
    
    for MobName, MobData in pairs(ThirdSeaMobsTable) do
        if Level >= MobData.Quest.LevelReq then
            CurrentQuest = MobData.Quest
            CurrentMob = MobData
        end
    end
    
    if not CurrentQuest then return end
    
    -- Pegar Quest se não tiver
    if not Player.PlayerGui.Main.Quest.Visible then
        HumanoidRootPart.CFrame = CurrentQuest.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", CurrentQuest.Name, CurrentQuest.LevelReq)
        wait(0.5)
    end
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy.Name == CurrentMob.Name and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not QuestConfig.QuestEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0 or not Player.PlayerGui.Main.Quest.Visible
        end
    end
end

-- Função para parar a quest
local function StopQuest()
    QuestConfig.QuestEnabled = false
    -- Lógica de parada de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Criar botões de farm e quest na interface
local FarmButton = Interface.CreateTab("Farm")
FarmButton.MouseButton1Click:Connect(function()
    if FarmConfig.FarmEnabled then
        StopFarm()
    else
        StartFarm()
    end
end)

local QuestButton = Interface.CreateTab("Quest")
QuestButton.MouseButton1Click:Connect(function()
    if QuestConfig.QuestEnabled then
        StopQuest()
    else
        StartQuest()
    end
end)

-- Atualizar o status dos botões de farm e quest
local function UpdateFarmQuestStatus()
    if FarmConfig.FarmEnabled then
        FarmButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        FarmButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end

    if QuestConfig.QuestEnabled then
        QuestButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        QuestButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end
end

-- Loop principal
while true do
    wait(1)
    UpdateFarmQuestStatus()
    
    -- Lógica de farm e quest
    if FarmConfig.FarmEnabled then
        StartFarm()
    end
    
    if QuestConfig.QuestEnabled then
        StartQuest()
    end
end

-- Blox Fruits Ultimate Script (Parte 5/10 - Sistema de Farm e Quest do Fourth Sea)
local TweenService = game:GetService("TweenService")
local Interface = require(script.Parent:WaitForChild("Part9")) -- Carrega a interface da Parte 9

-- Tabela de Mobs e Quests do Fourth Sea
local FourthSeaMobsTable = {
    ['Cake Prince'] = {
        Quest = {
            Name = "CakePrinceQuest",
            LevelReq = 135,
            NameQuest = "Cake Prince Quest",
            QuestLabel = "Cake Prince (Lv. 135+)",
            CFrame = CFrame.new(-2103.38342, 448.931, -12027.9443)
        },
        Name = "Cake Prince",
        CFrameSpawn = CFrame.new(-2103.38342, 448.931, -12027.9443)
    },
    ['Cookie Crafter'] = {
        Quest = {
            Name = "CookieCrafterQuest",
            LevelReq = 140,
            NameQuest = "Cookie Crafter Quest",
            QuestLabel = "Cookie Crafter (Lv. 140+)",
            CFrame = CFrame.new(-2270.9375, 448.931, -12151.6953)
        },
        Name = "Cookie Crafter",
        CFrameSpawn = CFrame.new(-2270.9375, 448.931, -12151.6953)
    },
    ['Awakened Ice Admiral'] = {
        Quest = {
            Name = "IceAdmiralQuest",
            LevelReq = 150,
            NameQuest = "Ice Admiral Quest",
            QuestLabel = "Awakened Ice Admiral (Lv. 150+)",
            CFrame = CFrame.new(-5445.81738, 848.083923, -1505.22351)
        },
        Name = "Awakened Ice Admiral",
        CFrameSpawn = CFrame.new(-5445.81738, 848.083923, -1505.22351)
    },
    ['Saber Expert'] = {
        Quest = {
            Name = "SaberExpertQuest",
            LevelReq = 155,
            NameQuest = "Saber Expert Quest",
            QuestLabel = "Saber Expert (Lv. 155+)",
            CFrame = CFrame.new(-5954.4834, 848.083923, -1724.8269)
        },
        Name = "Saber Expert",
        CFrameSpawn = CFrame.new(-5954.4834, 848.083923, -1724.8269)
    },
    ['Mystical Pirate Captain'] = {
        Quest = {
            Name = "MysticalPirateQuest",
            LevelReq = 160,
            NameQuest = "Mystical Pirate Quest",
            QuestLabel = "Mystical Pirate Captain (Lv. 160+)",
            CFrame = CFrame.new(-13359.0273, 577.201294, -6631.9312)
        },
        Name = "Mystical Pirate Captain",
        CFrameSpawn = CFrame.new(-13359.0273, 577.201294, -6631.9312)
    },
    ['Cursed Skull'] = {
        Quest = {
            Name = "CursedSkullQuest",
            LevelReq = 165,
            NameQuest = "Cursed Skull Quest",
            QuestLabel = "Cursed Skull (Lv. 165+)",
            CFrame = CFrame.new(-9515.37109, 315.251282, 6479.42773)
        },
        Name = "Cursed Skull",
        CFrameSpawn = CFrame.new(-9521.39258, 315.251282, 6470.30762)
    }
}

-- Configurações de Farm
local FarmConfig = {
    FarmMode = "Auto", -- "Auto" ou "Manual"
    FarmTarget = nil, -- Inimigo alvo
    FarmDistance = 15, -- Distância de farm
    FarmSpeed = 50, -- Velocidade de farm
    FarmEnabled = false -- Flag para ativar/desativar farm
}

-- Configurações de Quest
local QuestConfig = {
    QuestEnabled = false, -- Flag para ativar/desativar quest
    CurrentQuest = nil, -- Quest atual
    QuestReward = 0 -- Recompensa da quest
}

-- Função para iniciar o farm
local function StartFarm()
    FarmConfig.FarmEnabled = true
    -- Lógica de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Encontrar e atacar mobs do Fourth Sea
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            for MobName, MobData in pairs(FourthSeaMobsTable) do
                if Enemy.Name == MobData.Name then
                    repeat
                        wait()
                        
                        -- Auto Haki
                        if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                        
                        -- Bring Mob
                        if Config.BringMob then
                            Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                            Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            Enemy.HumanoidRootPart.Transparency = 0.8
                        end
                        
                        -- Attack
                        HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        if Config.FastAttack then
                            AttackFunction()
                        end
                        
                    until not FarmConfig.FarmEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0
                end
            end
        end
    end
end

-- Função para parar o farm
local function StopFarm()
    FarmConfig.FarmEnabled = false
    -- Lógica de parada de farm aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Função para iniciar a quest
local function StartQuest()
    QuestConfig.QuestEnabled = true
    -- Lógica de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Level = Player.Data.Level.Value
    
    -- Encontrar Quest apropriada para o nível
    local CurrentQuest = nil
    local CurrentMob = nil
    
    for MobName, MobData in pairs(FourthSeaMobsTable) do
        if Level >= MobData.Quest.LevelReq then
            CurrentQuest = MobData.Quest
            CurrentMob = MobData
        end
    end
    
    if not CurrentQuest then return end
    
    -- Pegar Quest se não tiver
    if not Player.PlayerGui.Main.Quest.Visible then
        HumanoidRootPart.CFrame = CurrentQuest.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", CurrentQuest.Name, CurrentQuest.LevelReq)
        wait(0.5)
    end
    
    -- Encontrar e atacar mobs
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy.Name == CurrentMob.Name and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            repeat
                wait()
                
                -- Auto Haki
                if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bring Mob
                if Config.BringMob then
                    Enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.DistanceMob)
                    Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    Enemy.HumanoidRootPart.Transparency = 0.8
                end
                
                -- Attack
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                if Config.FastAttack then
                    AttackFunction()
                end
                
            until not QuestConfig.QuestEnabled or not Enemy.Parent or Enemy.Humanoid.Health <= 0 or not Player.PlayerGui.Main.Quest.Visible
        end
    end
end

-- Função para parar a quest
local function StopQuest()
    QuestConfig.QuestEnabled = false
    -- Lógica de parada de quest aqui
    local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Parar de atacar inimigos
    local Enemies = workspace.Enemies:GetChildren()
    for _, Enemy in pairs(Enemies) do
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            Enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            Enemy.HumanoidRootPart.Transparency = 0
        end
    end
    
    -- Retornar o personagem para sua posição original
    HumanoidRootPart.CFrame = Character.PrimaryPart.CFrame
end

-- Criar botões de farm e quest na interface
local FarmButton = Interface.CreateTab("Farm")
FarmButton.MouseButton1Click:Connect(function()
    if FarmConfig.FarmEnabled then
        StopFarm()
    else
        StartFarm()
    end
end)

local QuestButton = Interface.CreateTab("Quest")
QuestButton.MouseButton1Click:Connect(function()
    if QuestConfig.QuestEnabled then
        StopQuest()
    else
        StartQuest()
    end
end)

-- Atualizar o status dos botões de farm e quest
local function UpdateFarmQuestStatus()
    if FarmConfig.FarmEnabled then
        FarmButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        FarmButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end

    if QuestConfig.QuestEnabled then
        QuestButton.BackgroundColor3 = Interface.UIConfig.MainColor
    else
        QuestButton.BackgroundColor3 = Interface.UIConfig.AccentColor
    end
end

-- Loop principal
while true do
    wait(1)
    UpdateFarmQuestStatus()
    
    -- Lógica de farm e quest
    if FarmConfig.FarmEnabled then
        StartFarm()
    end
    
    if QuestConfig.QuestEnabled then
        StartQuest()
    end
end

-- Theus Hub (Parte 9/10 - Interface)
local TweenService = game:GetService("TweenService")

-- Configurações da Interface
local UIConfig = {
    MainColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(85, 85, 85),
    TextColor = Color3.fromRGB(255, 255, 255),
    FontSize = 14,
    CornerRadius = 5
}

-- Função para criar um novo botão na interface
local function CreateTab(text)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = text
    TabButton.Text = text
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextColor3 = UIConfig.TextColor
    TabButton.TextSize = UIConfig.FontSize
    TabButton.BackgroundColor3 = UIConfig.AccentColor
    TabButton.BorderSizePixel = 0
    TabButton.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
    TabButton.Size = UDim2.new(0, 100, 0, 30)
    TabButton.Parent = script.Parent:WaitForChild("Tabs")
    return TabButton
end

-- Função para criar uma nova janela na interface
local function CreateWindow(title)
    local Window = Instance.new("Frame")
    Window.Name = title
    Window.BackgroundColor3 = UIConfig.MainColor
    Window.BorderSizePixel = 0
    Window.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
    Window.Size = UDim2.new(0, 400, 0, 300)
    Window.Position = UDim2.new(0.5, -200, 0.5, -150)
    
    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "Title"
    WindowTitle.Text = title
    WindowTitle.Font = Enum.Font.SourceSansBold
    WindowTitle.TextColor3 = UIConfig.TextColor
    WindowTitle.TextSize = UIConfig.FontSize + 2
    WindowTitle.BackgroundColor3 = UIConfig.AccentColor
    WindowTitle.BorderSizePixel = 0
    WindowTitle.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
    WindowTitle.Size = UDim2.new(1, 0, 0, 30)
    WindowTitle.Parent = Window
    
    local WindowContent = Instance.new("ScrollingFrame")
    WindowContent.Name = "Content"
    WindowContent.BackgroundTransparency = 1
    WindowContent.Size = UDim2.new(1, 0, 1, -30)
    WindowContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    WindowContent.ScrollBarThickness = 5
    WindowContent.Parent = Window
    
    return Window
end

-- Função para criar um novo botão dentro de uma janela
local function CreateButton(text, parent)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Text = text
    Button.Font = Enum.Font.SourceSansBold
    Button.TextColor3 = UIConfig.TextColor
    Button.TextSize = UIConfig.FontSize
    Button.BackgroundColor3 = UIConfig.AccentColor
    Button.BorderSizePixel = 0
    Button.CornerRadius = UDim.new(0, UIConfig.CornerRadius)
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Parent = parent
    return Button
end

-- Retornar as funções públicas
return {
    CreateTab = CreateTab,
    CreateWindow = CreateWindow,
    CreateButton = CreateButton,
    UIConfig = UIConfig
}