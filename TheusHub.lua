local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Window = Rayfield:CreateWindow({
    Name = "Theus Hub Premium",
    LoadingTitle = "Theus Hub Premium V2",
    LoadingSubtitle = "by Theus",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheusHubPremium",
        FileName = "Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Theus Hub Premium",
        Subtitle = "Key System",
        Note = "Join Discord for key",
        FileName = "TheusKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"THEUSHUB2025"}
    }
})

local MainTab = Window:CreateTab("Principal", 4483362458)
local PlayerTab = Window:CreateTab("Jogador", 4483362458)
local VehicleTab = Window:CreateTab("Veículos", 4483362458)
local TeleportTab = Window:CreateTab("Teleporte", 4483362458)
local VisualsTab = Window:CreateTab("Visual", 4483362458)

local function updateCharacter(property, value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid[property] = value
    end
end

local function copyCharacter(targetPlayer)
    local args = {
        [1] = "LoadCharacter",
        [2] = targetPlayer.Character:GetChildren()
    }
    ReplicatedStorage.RemoteEvents.CharacterSetter:FireServer(unpack(args))
end

local function spawnVehicle(vehicleName)
    local args = {
        [1] = "SpawnVehicle",
        [2] = vehicleName
    }
    ReplicatedStorage.RemoteEvents.VehicleSpawner:FireServer(unpack(args))
end

local function teleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame = typeof(position) == "CFrame" and position or CFrame.new(position)
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        TweenService:Create(humanoidRootPart, 
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = targetCFrame}
        ):Play()
    end
end

local playerNames = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

MainTab:CreateDropdown({
    Name = "Copiar Jogador",
    Options = playerNames,
    CurrentOption = "",
    Flag = "PlayerCopy",
    Callback = function(Value)
        local targetPlayer = Players:FindFirstChild(Value)
        if targetPlayer then
            copyCharacter(targetPlayer)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        updateCharacter("WalkSpeed", Value)
    end
})

PlayerTab:CreateSlider({
    Name = "Força do Pulo",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        updateCharacter("JumpPower", Value)
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipEnabled",
    Callback = function(Value)
        getgenv().Noclip = Value
        
        if Value then
            RunService:BindToRenderStep("Noclip", 0, function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep("Noclip")
        end
    end
})

local vehicles = {
    "Ambulance",
    "PoliceCar",
    "FireTruck",
    "Helicopter",
    "SportsCar",
    "Motorcycle",
    "Bicycle",
    "Boat"
}

for _, vehicle in ipairs(vehicles) do
    VehicleTab:CreateButton({
        Name = "Spawnar " .. vehicle,
        Callback = function()
            spawnVehicle(vehicle)
        end
    })
end

VehicleTab:CreateToggle({
    Name = "Veículo Voador",
    CurrentValue = false,
    Flag = "VehicleFly",
    Callback = function(Value)
        getgenv().VehicleFly = Value
        
        if Value then
            RunService:BindToRenderStep("VehicleFly", 0, function()
                local vehicle = LocalPlayer.Character:FindFirstChild("Humanoid").SeatPart
                if vehicle then
                    local bf = vehicle:FindFirstChild("BodyForce") or Instance.new("BodyForce", vehicle)
                    bf.Force = Vector3.new(0, vehicle:GetMass() * workspace.Gravity, 0)
                end
            end)
        else
            RunService:UnbindFromRenderStep("VehicleFly")
        end
    end
})

local locations = {
    ["Banco"] = CFrame.new(-377, 21, 1163),
    ["Hospital"] = CFrame.new(-816, 21, 1602),
    ["Escola"] = CFrame.new(-636, 21, 1107),
    ["Shopping"] = CFrame.new(-379, 21, 1868),
    ["Delegacia"] = CFrame.new(-193, 21, 1627),
    ["Cinema"] = CFrame.new(-1005, 21, 1289)
}

for name, position in pairs(locations) do
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            teleportTo(position)
        end
    })
end

VisualsTab:CreateToggle({
    Name = "ESP Jogadores",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        getgenv().ESP = Value
        
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
})

local function onCharacterAdded(character)
    if getgenv().ESP then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

local VirtualUser = game:GetService('VirtualUser')
LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        if getgenv().InfiniteJump then
            LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end
end)

MainTab:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        getgenv().InfiniteJump = Value
    end
})

Players.PlayerRemoving:Connect(function()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    MainTab:Set("PlayerCopy", playerNames)
end)

Players.PlayerAdded:Connect(function()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    MainTab:Set("PlayerCopy", playerNames)
end)