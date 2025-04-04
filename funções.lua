-- Variáveis Globais e Configurações
getgenv().AutoFarm = false
getgenv().TweenSpeed = 250
getgenv().AutoFarmBone = false
getgenv().AutoEliteHunter = false
getgenv().AutoFactory = false
getgenv().AutoNewWorld = false
getgenv().AutoThirdWorld = false
getgenv().AutoBartilo = false
getgenv().AutoRengoku = false
getgenv().AutoEctoplasm = false
getgenv().AutoBudySword = false
getgenv().AutoFarmBoss = false
getgenv().AutoFarmAllBoss = false
getgenv().AutoFarmFruitMastery = false
getgenv().AutoFarmGunMastery = false
getgenv().AutoHolyTorch = false
getgenv().AutoCombo = false
getgenv().AutoSeaBeast = false
getgenv().AutoPole = false
getgenv().AutoSaber = false
getgenv().AutoSuperhuman = false
getgenv().AutoSharkman = false
getgenv().AutoDeathStep = false
getgenv().AutoElectricClaw = false
getgenv().AutoDragonTalon = false
getgenv().AutoGodhuman = false
getgenv().AutoStoreFruit = false

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Quest Data Sea 1
local QuestData = {
    ["1-9"] = {
        Monster = "Bandit [Lv. 5]",
        Quest = "BanditQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905),
        CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516)
    },
    ["10-14"] = {
        Monster = "Monkey [Lv. 14]",
        Quest = "JungleQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1772.4093017578, 60.860641479492, 54.872589111328)
    },
    ["15-29"] = {
        Monster = "Gorilla [Lv. 20]",
        Quest = "JungleQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664)
    },
    ["30-39"] = {
        Monster = "Pirate [Lv. 35]",
        Quest = "BuggyQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211),
        CFrameMon = CFrame.new(-1219.32324, 4.75205183, 3915.63452)
    },
    ["40-59"] = {
        Monster = "Brute [Lv. 45]",
        Quest = "BuggyQuest1",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211),
        CFrameMon = CFrame.new(-1146.49646, 96.0936813, 4312.1333)
    },
    ["60-74"] = {
        Monster = "Desert Bandit [Lv. 60]",
        Quest = "DesertQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168),
        CFrameMon = CFrame.new(932.788818, 6.4503746, 4488.24609)
    },
    ["75-89"] = {
        Monster = "Desert Officer [Lv. 70]",
        Quest = "DesertQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168),
        CFrameMon = CFrame.new(1580.03198, 4.61375761, 4366.86426)
    },
    ["90-99"] = {
        Monster = "Snow Bandit [Lv. 90]",
        Quest = "SnowQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482),
        CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905)
    },
    ["100-119"] = {
        Monster = "Snowman [Lv. 100]",
        Quest = "SnowQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482),
        CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905)
    },
    ["120-149"] = {
        Monster = "Chief Petty Officer [Lv. 120]",
        Quest = "MarineQuest2",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-5035.0835, 28.6520386, 4325.29443),
        CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516)
    },
    ["150-174"] = {
        Monster = "Sky Bandit [Lv. 150]",
        Quest = "SkyQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353)
    },
    ["175-189"] = {
        Monster = "Dark Master [Lv. 175]",
        Quest = "SkyQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436),
        CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456)
    },
    ["190-209"] = {
        Monster = "Prisoner [Lv. 190]",
        Quest = "PrisonerQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(5310.61035, 0.350014925, 474.946594),
        CFrameMon = CFrame.new(5093.04199, -0.144462526, 478.985931)
    },    ["210-249"] = {
        Monster = "Dangerous Prisoner [Lv. 210]",
        Quest = "PrisonerQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(5310.61035, 0.350014925, 474.946594),
        CFrameMon = CFrame.new(5093.04199, -0.144462526, 478.985931)
    },
    ["250-274"] = {
        Monster = "Toga Warrior [Lv. 250]",
        Quest = "ColosseumQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762),
        CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474)
    },
    ["275-299"] = {
        Monster = "Gladiator [Lv. 275]",
        Quest = "ColosseumQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762),
        CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309)
    },
}

-- Quest Data Sea 2
local QuestDataSecondSea = {
    ["300-324"] = {
        Monster = "Military Soldier [Lv. 300]",
        Quest = "MagmaQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998),
        CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266)
    },
    ["325-374"] = {
        Monster = "Military Spy [Lv. 325]",
        Quest = "MagmaQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998),
        CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293)
    },
    ["375-399"] = {
        Monster = "Fishman Warrior [Lv. 375]",
        Quest = "FishmanQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504),
        CFrameMon = CFrame.new(61163.8516, 5.3073043, 1819.78418)
    },
    ["400-449"] = {
        Monster = "Fishman Commando [Lv. 400]",
        Quest = "FishmanQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504),
        CFrameMon = CFrame.new(61163.8516, 5.3073043, 1819.78418)
    },
    ["450-474"] = {
        Monster = "God's Guard [Lv. 450]",
        Quest = "SkyExp1Quest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-4721.71436, 845.277161, -1954.20105),
        CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.925427)
    },
    ["475-524"] = {
        Monster = "Shanda [Lv. 475]",
        Quest = "SkyExp1Quest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-7863.63672, 5545.49316, -379.826324),
        CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509)
    },
    ["525-549"] = {
        Monster = "Royal Squad [Lv. 525]",
        Quest = "SkyExp2Quest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802),
        CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729)
    },
    ["550-624"] = {
        Monster = "Royal Soldier [Lv. 550]",
        Quest = "SkyExp2Quest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802),
        CFrameMon = CFrame.new(-7864.44775, 5661.94092, -1708.22351)
    },
    ["625-649"] = {
        Monster = "Galley Pirate [Lv. 625]",
        Quest = "FountainQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678),
        CFrameMon = CFrame.new(5595.06982, 41.5013695, 3961.47095)
    },
    ["650-699"] = {
        Monster = "Galley Captain [Lv. 650]",
        Quest = "FountainQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678),
        CFrameMon = CFrame.new(5658.5752, 38.5361786, 4928.93506)
    },
}

-- Quest Data Sea 3
local QuestDataThirdSea = {
    ["700-724"] = {
        Monster = "Raider [Lv. 700]",
        Quest = "Area1Quest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589),
        CFrameMon = CFrame.new(-737.026123, 39.1748352, 2392.57959)
    },
    ["725-774"] = {
        Monster = "Mercenary [Lv. 725]",
        Quest = "Area1Quest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589),
        CFrameMon = CFrame.new(-973.731995, 95.8733215, 1836.46936)
    },
    ["775-799"] = {
        Monster = "Swan Pirate [Lv. 775]",
        Quest = "Area2Quest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321),
        CFrameMon = CFrame.new(970.369446, 142.653198, 1217.3667)
    },
    ["800-874"] = {
        Monster = "Factory Staff [Lv. 800]",
        Quest = "Area2Quest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321),
        CFrameMon = CFrame.new(296.786499, 72.9948196, -57.1298141)
    },
    ["875-899"] = {
        Monster = "Marine Lieutenant [Lv. 875]",
        Quest = "MarineQuest3",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523),
        CFrameMon = CFrame.new(-2913.26367, 72.9919434, -2971.64282)
    },
    ["900-949"] = {
        Monster = "Marine Captain [Lv. 900]",
        Quest = "MarineQuest3",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523),
        CFrameMon = CFrame.new(-1868.67688, 73.0011826, -3321.66333)
    },
}

-- Funções Utilitárias Base
function Tween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local distance = (targetCFrame.Position - humanoidRootPart.Position).Magnitude
    
    local tweenInfo = TweenInfo.new(
        distance/getgenv().TweenSpeed,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return tween
end

-- Sistema de Auto Farm Principal
function AutoFarmQuest()
    if getgenv().AutoFarm then
        pcall(function()
            local PlayerLevel = LocalPlayer.Data.Level.Value
            local QuestInfo
            
            -- Determina qual tabela de quests usar baseado no nível
            local CurrentQuestData = QuestData
            if PlayerLevel >= 700 then
                CurrentQuestData = QuestDataThirdSea
            elseif PlayerLevel >= 300 then
                CurrentQuestData = QuestDataSecondSea
            end
            
            -- Encontra a quest apropriada para o nível
            for range, info in pairs(CurrentQuestData) do
                local min, max = range:match("(%d+)-(%d+)")
                if PlayerLevel >= tonumber(min) and PlayerLevel <= tonumber(max) then
                    QuestInfo = info
                    break
                end
            end
            
            if QuestInfo then
                if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(QuestInfo.CFrameQuest)
                    wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestInfo.Quest, QuestInfo.QuestLv)
                    wait(0.5)
                end
                
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == QuestInfo.Monster and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            mob.HumanoidRootPart.Size = Vector3.new(60,60,60)
                            mob.HumanoidRootPart.Transparency = 0.8
                            mob.Humanoid.JumpPower = 0
                            mob.Humanoid.WalkSpeed = 0
                            mob.HumanoidRootPart.CanCollide = false
                            mob.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,-50)
                            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until not getgenv().AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent
                    end
                end
                
                if not workspace.Enemies:FindFirstChild(QuestInfo.Monster) then
                    Tween(QuestInfo.CFrameMon)
                end
            end
        end)
    end
end

-- Sistema de Auto Stats
function AutoStats()
    spawn(function()
        while wait() do
            if getgenv().AutoMelee then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if getgenv().AutoDefense then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if getgenv().AutoSword then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if getgenv().AutoGun then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if getgenv().AutoDevilFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end
    end)
end

-- Sistema de Auto Haki
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Sistema de Auto Skills
function AutoSkills()
    spawn(function()
        while wait() do
            if getgenv().AutoFarm then
                pcall(function()
                    local args = {
                        [1] = "Z",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "X",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "C",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                    wait(0.5)
                    local args = {
                        [1] = "V",
                        [2] = Vector3.new()
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                end)
            end
        end
    end)
end

-- Sistema de Auto Superhuman
function AutoSuperhuman()
    spawn(function()
        while wait() do
            if getgenv().AutoSuperhuman then
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
                    local args = {
                        [1] = "BuyBlackLeg"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end   
                if game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") then
                    SelectWeapon = "Superhuman"
                end  
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") or game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value <= 299 then
                        SelectWeapon = "Black Leg"
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value <= 299 then
                        SelectWeapon = "Electro"
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value <= 299 then
                        SelectWeapon = "Fishman Karate"
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value <= 299 then
                        SelectWeapon = "Dragon Claw"
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 then
                        local args = {
                            [1] = "BuyElectro"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 then
                        local args = {
                            [1] = "BuyElectro"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 then
                        local args = {
                            [1] = "BuyFishmanKarate"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 then
                        local args = {
                            [1] = "BuyFishmanKarate"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300 then
                        local args = {
                            [1] = "BlackbeardReward",
                            [2] = "DragonClaw",
                            [3] = "1"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        local args = {
                            [1] = "BlackbeardReward",
                            [2] = "DragonClaw",
                            [3] = "2"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
                    end
                    if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300 then
                        local args = {
                            [1] = "BlackbeardReward",
                            [2] = "DragonClaw",
                            [3] = "1"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        local args = {
                            [1] = "BlackbeardReward",
                            [2] = "DragonClaw",
                            [3] = "2"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
                    end
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 then
                        local args = {
                            [1] = "BuySuperhuman"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                    if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 then
                        local args = {
                            [1] = "BuySuperhuman"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end
            end
        end
    end)
end