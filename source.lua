-- Serviços e Configurações Otimizadas
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Configurações Compactas usando Metatables para Otimização
local Settings = setmetatable({
    Farm = {Active = false, Height = 25},
    Combat = {Fast = false, Skills = false},
    Misc = {Fruits = false, Bosses = false},
    Visual = {ESP = false},
}, {
    __index = function(t,k) 
        return rawget(t,k) or false 
    end
})

-- Sistema de Cache para Performance
local Cache = {
    Weapons = {},
    Mobs = {},
    NPCs = {}
}

-- Sistema de Combate Ultra Otimizado
local CombatSystem = {
    getWeapon = function()
        if #Cache.Weapons > 0 then return Cache.Weapons[1] end
        
        local best = {tool = nil, damage = 0}
        for _,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("ToolTip") then
                local dmg = tonumber(v.ToolTip.Value) or 0
                if dmg > best.damage then
                    best = {tool = v, damage = dmg}
                end
            end
        end
        
        table.insert(Cache.Weapons, best.tool)
        return best.tool
    end,
    
    attack = function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        
        local args = {
            [1] = "ComboHit",
            [2] = "Melee"
        }
        game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
    end,
    
    useSkills = function()
        for _,key in pairs({"Z","X","C","V","F"}) do
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            wait()
            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
        end
    end
}

-- Sistema de Quest Ultra Otimizado
local QuestSystem = {
    current = nil,
    
    getQuest = function()
        local level = Player.Level.Value
        local quests = {
            {l=1, n="Bandit", q="BanditQuest1"},
            {l=10, n="Monkey", q="MonkeyQuest"},
            {l=15, n="Gorilla", q="GorillaQuest"},
            -- Mais quests aqui
        }
        
        for i=#quests,1,-1 do
            if level >= quests[i].l then
                return quests[i]
            end
        end
    end,
    
    start = function(quest)
        if not Player.PlayerGui.Main.Quest.Visible then
            local npc = workspace.NPCs:FindFirstChild(quest.n.." Quest Giver")
            if npc then
                local cf = npc.HumanoidRootPart.CFrame
                local tween = TweenService:Create(
                    Character.HumanoidRootPart,
                    TweenInfo.new(0.5),
                    {CFrame = cf * CFrame.new(0,0,3)}
                )
                tween:Play()
                tween.Completed:Wait()
                
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                    "StartQuest", quest.q, quest.l
                )
            end
        end
    end
}

-- Sistema de Farm Ultra Otimizado
local FarmSystem = {
    running = false,
    
    start = function()
        if FarmSystem.running then return end
        FarmSystem.running = true
        
        spawn(function()
            while Settings.Farm.Active and FarmSystem.running do
                local quest = QuestSystem.getQuest()
                if quest then
                    QuestSystem.start(quest)
                    
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name:find(quest.n) and mob:FindFirstChild("Humanoid") 
                        and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            repeat
                                local weapon = CombatSystem.getWeapon()
                                if weapon then
                                    Character.Humanoid:EquipTool(weapon)
                                end
                                
                                local cf = mob.HumanoidRootPart.CFrame * 
                                         CFrame.new(0,Settings.Farm.Height,0)
                                Character.HumanoidRootPart.CFrame = cf
                                
                                if Settings.Combat.Fast then
                                    CombatSystem.attack()
                                end
                                
                                if Settings.Combat.Skills then
                                    CombatSystem.useSkills()
                                end
                                
                                RunService.Heartbeat:Wait()
                            until not mob:FindFirstChild("Humanoid") 
                                  or mob.Humanoid.Health <= 0 
                                  or not Settings.Farm.Active
                        end
                    end
                end
                wait()
            end
        end)
    end,
    
    stop = function()
        FarmSystem.running = false
    end
}-- Interface Moderna e Otimizada para Mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZeusHubV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Utilitários de UI
local function Create(type, properties)
    local instance = Instance.new(type)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    return instance
end

-- Frame Principal Compacto
local MainFrame = Create("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 250, 0, 300), -- Tamanho reduzido para mobile
    Position = UDim2.new(0.5, -125, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = ScreenGui
})

-- Título Elegante
local Title = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    Text = "Zeus Hub V2",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    Parent = MainFrame
})

-- Subtítulo
local SubTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 25),
    BackgroundColor3 = Color3.fromRGB(35, 35, 45),
    Text = "Em desenvolvimento por Zeus",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextSize = 12,
    Font = Enum.Font.GothamSemibold,
    Parent = MainFrame
})

-- Container Principal
local Container = Create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -55),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    Parent = MainFrame
})

-- Layout
local UIListLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = Container
})

-- Função para Criar Toggles
local function CreateToggle(text, setting)
    local toggle = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        Parent = Container
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = toggle
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle
    })

    local button = Create("TextButton", {
        Size = UDim2.new(0, 35, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        Text = "",
        Parent = toggle
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = button
    })

    button.MouseButton1Click:Connect(function()
        if setting == "Farm.Active" then
            Settings.Farm.Active = not Settings.Farm.Active
            if Settings.Farm.Active then
                FarmSystem.start()
            else
                FarmSystem.stop()
            end
        elseif setting == "Combat.Fast" then
            Settings.Combat.Fast = not Settings.Combat.Fast
        elseif setting == "Combat.Skills" then
            Settings.Combat.Skills = not Settings.Combat.Skills
        elseif setting == "Misc.Fruits" then
            Settings.Misc.Fruits = not Settings.Misc.Fruits
        end
        
        button.BackgroundColor3 = Settings[setting:split(".")[1]][setting:split(".")[2]] 
            and Color3.fromRGB(0, 255, 125) 
            or Color3.fromRGB(255, 50, 50)
    end)

    return toggle
end

-- Criar Toggles
CreateToggle("Auto Farm", "Farm.Active")
CreateToggle("Fast Attack", "Combat.Fast")
CreateToggle("Auto Skills", "Combat.Skills")
CreateToggle("Auto Fruits", "Misc.Fruits")

-- Botão de Fechar
local CloseButton = Create("TextButton", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0, 2),
    BackgroundColor3 = Color3.fromRGB(255, 50, 50),
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    Parent = MainFrame
})

Create("UICorner", {
    CornerRadius = UDim.new(0, 4),
    Parent = CloseButton
})

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    FarmSystem.stop()
end)

-- Notificações
local function CreateNotification(text, color)
    local notif = Create("Frame", {
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(0.5, -100, 0.8, 0),
        BackgroundColor3 = color or Color3.fromRGB(35, 35, 45),
        Parent = ScreenGui
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = notif
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        Parent = notif
    })

    game:GetService("TweenService"):Create(notif, 
        TweenInfo.new(0.5), 
        {Position = UDim2.new(0.5, -100, 0.9, 0)}
    ):Play()

    wait(2)

    game:GetService("TweenService"):Create(notif,
        TweenInfo.new(0.5),
        {Position = UDim2.new(0.5, -100, 1, 0)}
    ):Play()

    wait(0.5)
    notif:Destroy()
end

-- Notificação Inicial
CreateNotification("Zeus Hub V2 carregado com sucesso!", Color3.fromRGB(0, 255, 125))

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)