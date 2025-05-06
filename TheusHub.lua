local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
    Name = "Theus Hub Premium",
    LoadingTitle = "Theus Hub Premium V3",
    LoadingSubtitle = "by Theus",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheusHubPremium",
        FileName = "BrookhavenConfig"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Theus Hub Premium",
        Subtitle = "Sistema de Chave",
        Note = "Entre no Discord: discord.gg/theushub",
        FileName = "TheusKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"THEUSHUB2025", "PREMIUM2025"}
    }
})

local MainTab = Window:CreateTab("Principal")
local PlayerTab = Window:CreateTab("Jogador")
local VehicleTab = Window:CreateTab("Veículos")
local HouseTab = Window:CreateTab("Casa")
local AnimationTab = Window:CreateTab("Animações")
local TeleportTab = Window:CreateTab("Teleporte")
local VisualTab = Window:CreateTab("Visual")
local AdminTab = Window:CreateTab("Admin")
local MiscTab = Window:CreateTab("Misc")

local Connections = {}
local ESPEnabled = false
local FlyEnabled = false
local NoClipEnabled = false
local InfiniteJumpEnabled = false
local AutoFarmEnabled = false

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

local function DisconnectAll()
    for _, connection in ipairs(Connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    table.clear(Connections)
end

local function CreateESP(player)
    local esp = Drawing.new("Text")
    esp.Visible = false
    esp.Center = true
    esp.Outline = true
    esp.Font = 2
    esp.Size = 13
    esp.Color = Color3.new(1, 1, 1)
    esp.Text = player.Name

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false

    Connect(RunService.RenderStepped, function()
        if not ESPEnabled then
            esp.Visible = false
            box.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                esp.Position = Vector2.new(pos.X, pos.Y - 40)
                esp.Visible = true

                local rootPart = player.Character.HumanoidRootPart
                local size = rootPart.Size * Vector3.new(2, 3, 0)
                local pos2d = Camera:WorldToViewportPoint(rootPart.Position)
                local size2d = Camera:WorldToViewportPoint(rootPart.Position + size)
                
                box.Size = Vector2.new(size2d.X - pos2d.X, size2d.Y - pos2d.Y)
                box.Position = Vector2.new(pos2d.X - box.Size.X / 2, pos2d.Y - box.Size.Y / 2)
                box.Visible = true
            else
                esp.Visible = false
                box.Visible = false
            end
        else
            esp.Visible = false
            box.Visible = false
        end
    end)
end

local function SetupESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end

    Connect(Players.PlayerAdded, function(player)
        CreateESP(player)
    end)
end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        
        if FlyEnabled then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlyVelocity"
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart

            Connect(UserInputService.InputBegan, function(input)
                if input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                end
            end)

            Connect(UserInputService.InputEnded, function(input)
                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        else
            local bodyVelocity = rootPart:FindFirstChild("FlyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end

local function ModifyVehicle(vehicle)
    if vehicle then
        local configuration = vehicle:FindFirstChild("Configuration")
        if configuration then
            for _, value in ipairs(configuration:GetChildren()) do
                if value:IsA("NumberValue") then
                    if value.Name == "MaxSpeed" then
                        value.Value = 500
                    elseif value.Name == "Acceleration" then
                        value.Value = 1
                    end
                end
            end
        end
    end
end

local function TeleportTo(position)
    if typeof(position) == "Vector3" then
        position = CFrame.new(position)
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        local tween = TweenService:Create(humanoidRootPart, 
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = position}
        )
        tween:Play()
    end
end

local function CopyCharacter(player)
    if player.Character then
        local args = {
            [1] = "LoadCharacter",
            [2] = player.Character:GetChildren()
        }
        ReplicatedStorage.RemoteEvents.CharacterCustomization:FireServer(unpack(args))
    end
end

local function AutoFarm()
    while AutoFarmEnabled do
        local args = {
            [1] = "CollectPaycheck"
        }
        ReplicatedStorage.RemoteEvents.Job:FireServer(unpack(args))
        wait(1)
    end
end

MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            SetupESP()
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Voar",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        ToggleFly()
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoClipEnabled = Value
        
        if Value then
            Connect(RunService.Stepped, function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

VehicleTab:CreateButton({
    Name = "Modificar Veículo Atual",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local vehicle = LocalPlayer.Character.Humanoid.SeatPart
            if vehicle then
                ModifyVehicle(vehicle.Parent)
            end
        end
    end
})

local locations = {
    ["Banco"] = Vector3.new(-377, 21, 1163),
    ["Hospital"] = Vector3.new(-816, 21, 1602),
    ["Escola"] = Vector3.new(-636, 21, 1107),
    ["Shopping"] = Vector3.new(-379, 21, 1868),
    ["Delegacia"] = Vector3.new(-193, 21, 1627)
}

for name, position in pairs(locations) do
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            TeleportTo(position)
        end
    })
end

local playerList = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

MainTab:CreateDropdown({
    Name = "Copiar Jogador",
    Options = playerList,
    CurrentOption = "",
    Flag = "PlayerCopyDropdown",
    Callback = function(Value)
        local targetPlayer = Players:FindFirstChild(Value)
        if targetPlayer then
            CopyCharacter(targetPlayer)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        AutoFarmEnabled = Value
        if Value then
            AutoFarm()
        end
    end
})

Connect(LocalPlayer.Idled, function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

Connect(Players.PlayerAdded, function(player)
    local newList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(newList, p.Name)
        end
    end
    MainTab:Set("PlayerCopyDropdown", newList)
end)

Connect(Players.PlayerRemoving, function(player)
    local newList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(newList, p.Name)
        end
    end
    MainTab:Set("PlayerCopyDropdown", newList)
end)