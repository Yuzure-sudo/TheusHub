-- Serviços Principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variáveis Globais Otimizadas
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Sistema de Login Seguro
local function CreateLoginUI()
    local LoginGui = Instance.new("ScreenGui")
    LoginGui.Name = "ZeusLoginSystem"
    LoginGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = LoginGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "Zeus Hub V3"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "Insira sua Key"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    KeyInput.BorderSizePixel = 0
    KeyInput.Parent = MainFrame
    
    local LoginButton = Instance.new("TextButton")
    LoginButton.Size = UDim2.new(0.8, 0, 0, 35)
    LoginButton.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginButton.Text = "Login"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    LoginButton.BorderSizePixel = 0
    LoginButton.Parent = MainFrame
    
    return {
        gui = LoginGui,
        button = LoginButton,
        input = KeyInput
    }
end

-- Sistema de Configurações Avançado
local Settings = {
    Farm = {
        Active = false,
        AutoQuest = true,
        Height = 25,
        Distance = 5,
        Method = "Behind", -- Behind, Above, Below
        FastAttack = true,
        AutoSkills = true
    },
    Fruits = {
        AutoStore = true,
        AutoSnipe = true,
        TargetFruits = {
            "Dragon-Dragon",
            "Soul-Soul",
            "Venom-Venom",
            "Shadow-Shadow"
        },
        MinimumValue = 1000000
    },
    Combat = {
        FastAttackDelay = 0.1,
        SkillsDelay = 1,
        AutoHaki = true,
        SafeHealth = 25
    },
    Misc = {
        AutoRejoin = true,
        HideNames = true,
        AntiAFK = true
    }
}

-- Sistema de Cache Avançado
local Cache = {
    Weapons = {},
    Fruits = {},
    Quests = {},
    Mobs = {},
    LastPositions = {},
    Cooldowns = {},
    
    clearCache = function()
        for k, v in pairs(Cache) do
            if type(v) == "table" then
                table.clear(v)
            end
        end
    end,
    
    updateCache = function()
        Cache.Weapons = {}
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(Cache.Weapons, {
                    Name = tool.Name,
                    Tool = tool,
                    Damage = tool:FindFirstChild("ToolTip") and tonumber(tool.ToolTip.Value) or 0
                })
            end
        end
        
        table.sort(Cache.Weapons, function(a,b)
            return a.Damage > b.Damage
        end)
    end
}

-- Sistema de Farm Ultra Otimizado
local FarmSystem = {
    State = {
        CurrentTarget = nil,
        CurrentQuest = nil,
        Farming = false,
        LastAttack = 0
    },
    
    getClosestMob = function(questMob)
        local closest = {distance = math.huge, mob = nil}
        
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob.Name:find(questMob) and mob:FindFirstChild("Humanoid") 
            and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                if distance < closest.distance then
                    closest = {distance = distance, mob = mob}
                end
            end
        end
        
        return closest.mob
    end,
    
    teleportToPosition = function(position, offset)
        local targetCFrame = typeof(position) == "CFrame" and position or CFrame.new(position)
        
        if offset then
            targetCFrame = targetCFrame * offset
        end
        
        local tween = TweenService:Create(
            HumanoidRootPart,
            TweenInfo.new(
                (HumanoidRootPart.Position - targetCFrame.Position).Magnitude/500,
                Enum.EasingStyle.Linear
            ),
            {CFrame = targetCFrame}
        )
        
        tween:Play()
        return tween
    end,
    
    attack = function()
        if tick() - FarmSystem.State.LastAttack < Settings.Combat.FastAttackDelay then
            return
        end
        
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new())
        
        if Settings.Combat.FastAttack then
            for i = 1, 3 do
                ReplicatedStorage.Remotes.Combat:FireServer("ComboHit", "Melee")
                task.wait(0.1)
            end
        end
        
        FarmSystem.State.LastAttack = tick()
    end
}-- Sistema de Interface Avançada
local Interface = {
    Colors = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 125),
        Error = Color3.fromRGB(255, 50, 50)
    },
    
    Elements = {},
    
    Create = function(type, properties)
        local instance = Instance.new(type)
        for k, v in pairs(properties or {}) do
            instance[k] = v
        end
        return instance
    end,
    
    CreateMainUI = function()
        local ScreenGui = Interface.Create("ScreenGui", {
            Name = "ZeusHubV3",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = game:GetService("CoreGui")
        })
        
        local MainFrame = Interface.Create("Frame", {
            Name = "MainFrame",
            Size = UDim2.new(0, 600, 0, 400),
            Position = UDim2.new(0.5, -300, 0.5, -200),
            BackgroundColor3 = Interface.Colors.Background,
            BorderSizePixel = 0,
            Active = true,
            Draggable = true,
            Parent = ScreenGui
        })
        
        -- Barra Superior
        local TopBar = Interface.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Interface.Colors.Secondary,
            Parent = MainFrame
        })
        
        Interface.Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = "Zeus Hub V3 - Premium",
            TextColor3 = Interface.Colors.Text,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TopBar
        })
        
        -- Sistema de Tabs
        local TabContainer = Interface.Create("Frame", {
            Size = UDim2.new(0, 150, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundColor3 = Interface.Colors.Secondary,
            Parent = MainFrame
        })
        
        local ContentContainer = Interface.Create("Frame", {
            Size = UDim2.new(1, -150, 1, -30),
            Position = UDim2.new(0, 150, 0, 30),
            BackgroundColor3 = Interface.Colors.Background,
            Parent = MainFrame
        })
        
        return {
            ScreenGui = ScreenGui,
            MainFrame = MainFrame,
            TabContainer = TabContainer,
            ContentContainer = ContentContainer
        }
    end,
    
    CreateTab = function(name, icon)
        local tab = Interface.Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Interface.Colors.Secondary,
            Text = name,
            TextColor3 = Interface.Colors.Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold
        })
        
        local content = Interface.Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false
        })
        
        return {tab = tab, content = content}
    end
}

-- Sistema de Frutas Avançado
local FruitSystem = {
    FruitList = {},
    
    initialize = function()
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") then
                table.insert(FruitSystem.FruitList, {
                    Name = fruit.Name,
                    Position = fruit:GetPivot().Position,
                    Value = FruitSystem.getFruitValue(fruit.Name)
                })
            end
        end
    end,
    
    getFruitValue = function(fruitName)
        local values = {
            ["Dragon-Dragon"] = 5000000,
            ["Soul-Soul"] = 4500000,
            ["Venom-Venom"] = 4000000,
            ["Shadow-Shadow"] = 3500000
        }
        return values[fruitName] or 0
    end,
    
    autoSnipe = function()
        for _, fruit in pairs(FruitSystem.FruitList) do
            if fruit.Value >= Settings.Fruits.MinimumValue then
                FarmSystem.teleportToPosition(fruit.Position)
                wait(0.5)
                -- Implementar lógica de coleta
            end
        end
    end
}

-- Sistema de Combate Avançado
local CombatSystem = {
    Skills = {
        Z = {Cooldown = 4.5, LastUse = 0},
        X = {Cooldown = 6.0, LastUse = 0},
        C = {Cooldown = 8.0, LastUse = 0},
        V = {Cooldown = 10.0, LastUse = 0}
    },
    
    useSkill = function(skill)
        local skillData = CombatSystem.Skills[skill]
        if tick() - skillData.LastUse >= skillData.Cooldown then
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(0,0))
            wait()
            VirtualUser:Button1Up(Vector2.new(0,0))
            skillData.LastUse = tick()
        end
    end,
    
    autoSkills = function()
        if Settings.Combat.AutoSkills then
            for skill, _ in pairs(CombatSystem.Skills) do
                CombatSystem.useSkill(skill)
            end
        end
    end,
    
    checkSafety = function()
        if Humanoid.Health <= (Humanoid.MaxHealth * (Settings.Combat.SafeHealth / 100)) then
            return false
        end
        return true
    end
}

-- Sistema de Teleporte
local TeleportSystem = {
    Locations = {
        ["First Island"] = Vector3.new(1000, 100, 1000),
        ["Second Island"] = Vector3.new(2000, 100, 2000),
        -- Adicionar mais localizações
    },
    
    teleportTo = function(location)
        if TeleportSystem.Locations[location] then
            FarmSystem.teleportToPosition(TeleportSystem.Locations[location])
        end
    end
}

-- Sistema de Notificações
local NotificationSystem = {
    create = function(text, duration)
        local notif = Interface.Create("Frame", {
            Size = UDim2.new(0, 250, 0, 60),
            Position = UDim2.new(1, -270, 1, -80),
            BackgroundColor3 = Interface.Colors.Secondary,
            Parent = Interface.Elements.ScreenGui
        })
        
        Interface.Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Interface.Colors.Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            Parent = notif
        })
        
        game:GetService("Debris"):AddItem(notif, duration or 3)
    end
}

-- Inicialização
local function Initialize()
    local loginUI = CreateLoginUI()
    loginUI.button.MouseButton1Click:Connect(function()
        if loginUI.input.Text == "theusgostoso" then
            loginUI.gui:Destroy()
            local ui = Interface.CreateMainUI()
            -- Iniciar sistemas
            FarmSystem.start()
            FruitSystem.initialize()
            NotificationSystem.create("Zeus Hub V3 iniciado com sucesso!", 5)
        else
            NotificationSystem.create("Key inválida!", 3)
        end
    end)
end

Initialize()