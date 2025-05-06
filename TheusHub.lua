-- Delta Theus Hub Premium V1
local Delta = loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaHubDevs/Delta/main/Source.lua"))()

local Window = Delta:CreateWindow({
    Title = "Theus Hub Premium",
    SubTitle = "by Theus",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 350),
    Acrylic = true,
    Theme = "Dark"
})

-- Tabs
local MainTab = Window:CreateTab("Principal", "rbxassetid://4483345998")
local CombatTab = Window:CreateTab("Combate", "rbxassetid://7733674079")
local VisualsTab = Window:CreateTab("Visual", "rbxassetid://4483362458")
local VehicleTab = Window:CreateTab("Veículos", "rbxassetid://4483364237")
local TrollTab = Window:CreateTab("Troll", "rbxassetid://4483345998")

-- Variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Seção Principal
local MainSection = MainTab:CreateSection("Modificadores")

MainSection:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MainSection:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

MainSection:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        local InfiniteJumpEnabled = true
        UserInputService.JumpRequest:Connect(function()
            if InfiniteJumpEnabled then
                LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end
})

-- Seção de Combate
local CombatSection = CombatTab:CreateSection("Recursos de Combate")

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    
    return closestPlayer
end

CombatSection:CreateToggle({
    Name = "Hitbox Expander",
    Default = false,
    Callback = function(Value)
        _G.HitboxEnabled = Value
        while _G.HitboxEnabled do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                        player.Character.HumanoidRootPart.Transparency = 0.5
                    end
                end
            end
            wait(1)
        end
    end
})

-- Seção Visual
local VisualSection = VisualsTab:CreateSection("ESP")

VisualSection:CreateToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
        while _G.ESPEnabled do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
            wait(1)
        end
        
        if not _G.ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
})

-- Seção de Veículos
local VehicleSection = VehicleTab:CreateSection("Modificadores de Veículos")

VehicleSection:CreateButton({
    Name = "Spawn Carro",
    Callback = function()
        local args = {
            [1] = "SpawnVehicle",
            [2] = "Vehicle1"
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
    end
})

VehicleSection:CreateToggle({
    Name = "Veículo Voador",
    Default = false,
    Callback = function(Value)
        _G.VehicleFly = Value
        while _G.VehicleFly do
            local vehicle = LocalPlayer.Character:FindFirstChild("Humanoid").SeatPart
            if vehicle then
                local bf = vehicle:FindFirstChild("BodyForce")
                if not bf then
                    bf = Instance.new("BodyForce")
                    bf.Parent = vehicle
                end
                bf.Force = Vector3.new(0, vehicle:GetMass() * workspace.Gravity, 0)
            end
            wait()
        end
    end
})

-- Seção Troll
local TrollSection = TrollTab:CreateSection("Funções Troll")

TrollSection:CreateButton({
    Name = "Fling All",
    Callback = function()
        local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    for i = 1, 3 do
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0)
                        wait(0.1)
                    end
                end
            end
        end
        LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
    end
})

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Notificação de Inicialização
Delta:Notify({
    Title = "Theus Hub Premium",
    Content = "Script carregado com sucesso!",
    Duration = 6.5
})

-- Auto-Update Check
local function checkUpdate()
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/version.txt")
    end)
    
    if success and result ~= "1.0" then
        Delta:Notify({
            Title = "Atualização Disponível",
            Content = "Nova versão do Theus Hub disponível!",
            Duration = 6.5
        })
    end
end

checkUpdate()