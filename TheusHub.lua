-- Theus Hub Premium V2
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Theus Hub Premium",
   LoadingTitle = "Theus Hub Premium V2",
   LoadingSubtitle = "by Theus",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TheusHubPremium",
      FileName = "Config"
   }
})

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tabs
local MainTab = Window:CreateTab("Principal")
local PlayerTab = Window:CreateTab("Jogador")
local VehicleTab = Window:CreateTab("Veículos")
local TeleportTab = Window:CreateTab("Teleporte")

-- Sistema de Cópia de Jogador
local function copyCharacterAppearance(player)
    if player.Character then
        local appearance = player.Character:FindFirstChild("Appearance")
        if appearance then
            local args = {
                [1] = "LoadAppearance",
                [2] = appearance:GetChildren()
            }
            ReplicatedStorage.RemoteEvents.Character:FireServer(unpack(args))
        end
    end
end

local function copyOutfit(player)
    if player.Character then
        local args = {
            [1] = "LoadOutfit",
            [2] = player.Character:GetChildren()
        }
        ReplicatedStorage.RemoteEvents.Character:FireServer(unpack(args))
    end
end

local function copyAnimation(player)
    if player.Character and player.Character:FindFirstChild("Animate") then
        local args = {
            [1] = "LoadAnimation",
            [2] = player.Character.Animate:GetChildren()
        }
        ReplicatedStorage.RemoteEvents.Character:FireServer(unpack(args))
    end
end

-- Seção Principal
local PlayerSection = MainTab:CreateSection("Copiar Jogador")

local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Selecionar Jogador",
    Options = {},
    CurrentOption = "",
    Flag = "PlayerDropdown",
    Callback = function(Value)
        local selectedPlayer = Players:FindFirstChild(Value)
        if selectedPlayer then
            copyCharacterAppearance(selectedPlayer)
            copyOutfit(selectedPlayer)
            copyAnimation(selectedPlayer)
        end
    end
})

-- Atualizar lista de jogadores
local function updatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:Refresh(playerNames)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Modificadores de Jogador
local function modifyCharacter(property, value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid[property] = value
    end
end

PlayerTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        modifyCharacter("WalkSpeed", Value)
    end
})

PlayerTab:CreateSlider({
    Name = "Pulo",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        modifyCharacter("JumpPower", Value)
    end
})

-- Sistema de Veículos
local function spawnVehicle(vehicleType)
    local args = {
        [1] = "SpawnVehicle",
        [2] = vehicleType
    }
    ReplicatedStorage.RemoteEvents.Vehicle:FireServer(unpack(args))
end

local vehicles = {
    "Ambulance",
    "PoliceCar",
    "Taxi",
    "Bus",
    "Helicopter",
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

-- Sistema de Teleporte
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
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = position
            end
        end
    })
end

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Funções Adicionais do Ice Hub
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
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

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        _G.InfiniteJump = Value
        game:GetService("UserInputService").JumpRequest:connect(function()
            if _G.InfiniteJump then
                LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end
})

-- Notificação de Inicialização
Rayfield:Notify({
    Title = "Theus Hub Premium",
    Content = "Script carregado com sucesso!",
    Duration = 6.5,
    Image = 4483362458,
})