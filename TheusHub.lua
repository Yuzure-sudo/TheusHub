-- WirtzScripts.lua - Script com UI Rayfield para Blox Fruits Sea 1
-- Carregar a UI library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrustAllRoblox/Rayfield/main/source"))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- Variáveis básicas
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações
local Settings = {
    AutoFarm = false,
    SelectedMob = "Bandit",
    KillAura = false,
    NoClip = false
}

-- Verificar se é Blox Fruits
local GameSupported = false
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    GameSupported = true
    print("Wirtz Scripts - Blox Fruits detectado!")
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Erro",
        Text = "Jogo não suportado! Apenas Blox Fruits é compatível.",
        Duration = 5
    })
    return
end

-- Criar janela principal usando Rayfield
local Window = Rayfield:CreateWindow({
    Name = "Wirtz Scripts Premium",
    Location = UDim2.new(0.5, -300, 0.5, -200),
    Keybind = Enum.KeyCode.P
})

-- Tab Principal
local MainTab = Window:CreateTab("Principal")
local FarmSection = MainTab:CreateSection("Auto Farm")

FarmSection:AddButton({
    Text = "Auto Farm",
    Callback = function(Value)
        Settings.AutoFarm = Value
        if Settings.AutoFarm then
            StartAutoFarm()
            FarmSection:AddParagraph("Auto Farm ATIVADO!")
        else
            if AutoFarmCoroutine then coroutine.close(AutoFarmCoroutine) end
            FarmSection:AddParagraph("Auto Farm DESATIVADO!")
        end
    end,
    Menu = {
        "On",
        "Off"
    }
})

-- Selecionar Mob
local Mobs = {
    "Bandit",
    "Monkey",
    "Gorilla",
    "Marine"
}

FarmSection:AddDropdown({
    Text = "Selecionar Mob",
    Callback = function(Value)
        Settings.SelectedMob = Value
        FarmSection:AddParagraph("Mob selecionado: " .. Value)
    end,
    Options = Mobs
})

-- Tab Combate
local CombatTab = Window:CreateTab("Combate")
local CombatSection = CombatTab:CreateSection("Combate")

CombatSection:AddToggle({
    Text = "Kill Aura",
    Callback = function(Value)
        Settings.KillAura = Value
        if Settings.KillAura then
            StartKillAura()
            CombatSection:AddParagraph("Kill Aura ATIVADO!")
        else
            if KillAuraCoroutine then coroutine.close(KillAuraCoroutine) end
            CombatSection:AddParagraph("Kill Aura DESATIVADO!")
        end
    end
})

-- Tab Diversos
local MiscTab = Window:CreateTab("Diversos")
local MiscSection = MiscTab:CreateSection("Diversos")

MiscSection:AddToggle({
    Text = "NoClip",
    Callback = function(Value)
        Settings.NoClip = Value
        MiscSection:AddParagraph("NoClip " .. (Value and "ATIVADO!" or "DESATIVADO!"))
    end
})

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
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(1280, 672))
end

-- Sistema de Auto Farm
local AutoFarmCoroutine = nil
local function StartAutoFarm()
    if AutoFarmCoroutine then
        coroutine.close(AutoFarmCoroutine)
    end

    AutoFarmCoroutine = coroutine.create(function()
        while Settings.AutoFarm do
            local mob = GetClosestMob(Settings.SelectedMob, 1000)
            if mob then
                local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                if distance > 5 then
                    TweenTo(mob.HumanoidRootPart.Position + Vector3.new(0, 0, 5), 200)
                    wait(distance / 200)
                end
                Attack()
            end
            wait(0.5)
        end
    end)
    coroutine.resume(AutoFarmCoroutine)
end

-- Sistema de Kill Aura
local KillAuraCoroutine = nil
local function StartKillAura()
    if KillAuraCoroutine then
        coroutine.close(KillAuraCoroutine)
    end

    KillAuraCoroutine = coroutine.create(function()
        while Settings.KillAura do
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                    if distance <= 50 then
                        Attack()
                    end
                end
            end
            wait(0.1)
        end
    end)
    coroutine.resume(KillAuraCoroutine)
end

-- Sistema de NoClip
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

-- Atualizar personagem
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    print("Personagem atualizado!")
end)

-- Mensagem de inicialização
game.StarterGui:SetCore("SendNotification", {
    Title = "Wirtz Scripts",
    Text = "Script carregado! Use a UI para ativar funções.",
    Duration = 5
})

print("Wirtz Scripts carregado com sucesso!")

-- Finalização do script
return {
    Window = Window,
    StartAutoFarm = StartAutoFarm,
    StartKillAura = StartKillAura
}
