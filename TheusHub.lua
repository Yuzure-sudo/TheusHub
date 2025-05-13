-- Simple Wirtz Script - Sea 1 Blox Fruits

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- SETTINGS
local AutoFarmEnabled = false
local KillAuraEnabled = false
local NoClipEnabled = false

-- CHECK SEA1 MAP
if not workspace.Map:FindFirstChild("Spawn") then
    warn("Este script é feito para Sea 1 (Blox Fruits). Saindo...")
    return
end

-- FUNÇÃO PRA PEGAR O MOB MAIS PERTO
local function GetClosestMob()
    local closest = nil
    local dist = math.huge
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            local mag = (mob.HumanoidRootPart.Position - rootPart.Position).Magnitude
            if mag < dist and mag < 100 then -- só mobs até 100 studs perto
                closest = mob
                dist = mag
            end
        end
    end
    return closest
end

-- ATACAR MOB SIMPLESMENTE (CLICAR)
local function Attack()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(1280, 672))
end

-- AUTO FARM
local autoFarmThread = nil
local function StartAutoFarm()
    if autoFarmThread then
        coroutine.close(autoFarmThread)
    end
    autoFarmThread = coroutine.create(function()
        while AutoFarmEnabled do
            local mob = GetClosestMob()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                local mobPos = mob.HumanoidRootPart.Position
                if (rootPart.Position - mobPos).Magnitude > 5 then
                    local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(mobPos + Vector3.new(0,0,5))})
                    tween:Play()
                    tween.Completed:Wait()
                end
                Attack()
            else
                wait(1)
            end
            wait(0.3)
        end
    end)
    coroutine.resume(autoFarmThread)
end

-- KILL AURA
local killAuraThread = nil
local function StartKillAura()
    if killAuraThread then
        coroutine.close(killAuraThread)
    end
    killAuraThread = coroutine.create(function()
        while KillAuraEnabled do
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    local mag = (mob.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if mag <= 20 then
                        Attack()
                    end
                end
            end
            wait(0.1)
        end
    end)
    coroutine.resume(killAuraThread)
end

-- NOCLIP SIMPLES
RunService.Stepped:Connect(function()
    if NoClipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- CRIAR UI BÁSICA

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleWirtzUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Wirtz Scripts - Sea 1"
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Button Template function
local function CreateToggle(text, positionY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = text .. ": OFF"
    btn.Parent = MainFrame

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        callback(enabled)
    end)
end

-- Criar toggles
CreateToggle("Auto Farm", 40, function(val)
    AutoFarmEnabled = val
    if val then StartAutoFarm() end
end)

CreateToggle("Kill Aura", 80, function(val)
    KillAuraEnabled = val
    if val then StartKillAura() end
end)

CreateToggle("NoClip", 120, function(val)
    NoClipEnabled = val
end)

-- Mensagem inicial no chat
player:WaitForChild("PlayerGui")
player:WaitForChild("PlayerGui"):SetCore("ChatMakeSystemMessage", {
    Text = "[Wirtz Scripts] Script iniciado para Sea 1 - Use a UI (toggle no centro da tela).",
    Color = Color3.fromRGB(255,0,0),
    Font = Enum.Font.SourceSansBold,
    FontSize = Enum.FontSize.Size24
})

print("Wirtz Scripts inicializado com sucesso para Sea 1.")

