-- WirtzScripts.lua - Script funcional simplificado para Blox Fruits
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

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
    NoClip = false,
    FruitESP = false
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

-- Criar UI
local Window = redzlib:MakeWindow({
    Title = "Wirtz Scripts Premium",
    SubTitle = "by Wirtz Team",
    SaveFolder = "WirtzScripts"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://18751483361", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) }
})

-- Tab Principal
local MainTab = Window:AddTab("Principal")
local FarmSection = MainTab:AddSection("Auto Farm")

FarmSection:AddToggle({
    Name = "Auto Farm",
    Flag = "AutoFarm",
    Value = Settings.AutoFarm,
    Callback = function(Value)
        Settings.AutoFarm = Value
        if Value then
            StartAutoFarm()
            FarmSection:AddParagraph("Status", "Auto Farm ATIVADO!")
        else
            if AutoFarmCoroutine then coroutine.close(AutoFarmCoroutine) end
            FarmSection:AddParagraph("Status", "Auto Farm DESATIVADO!")
        end
    end
})

FarmSection:AddDropdown({
    Name = "Selecione Mob",
    Flag = "SelectedMob",
    List = {"Bandit", "Monkey", "Gorilla", "Marine"},
    Value = Settings.SelectedMob,
    Callback = function(Value)
        Settings.SelectedMob = Value
        FarmSection:AddParagraph("Mob", "Selecionado: " .. Value)
    end
})

local CombatSection = MainTab:AddSection("Combate")

CombatSection:AddToggle({
    Name = "Kill Aura",
    Flag = "KillAura",
    Value = Settings.KillAura,
    Callback = function(Value)
        Settings.KillAura = Value
        if Value then
            StartKillAura()
            CombatSection:AddParagraph("Status", "Kill Aura ATIVADO!")
        else
            if KillAuraCoroutine then coroutine.close(KillAuraCoroutine) end
            CombatSection:AddParagraph("Status", "Kill Aura DESATIVADO!")
        end
    end
})

local MiscTab = Window:AddTab("Diversos")
local MiscSection = MiscTab:AddSection("Ferramentas")

MiscSection:AddToggle({
    Name = "NoClip",
    Flag = "NoClip",
    Value = Settings.NoClip,
    Callback = function(Value)
        Settings.NoClip = Value
        MiscSection:AddParagraph("Status", "NoClip " .. (Value and "ATIVADO!" or "DESATIVADO!"))
    end
})

-- Mensagem de inicialização
game.StarterGui:SetCore("SendNotification", {
    Title = "Wirtz Scripts",
    Text = "Script carregado! Use a UI para ativar funções.",
    Duration = 5
})

-- Atualizar personagem
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    print("Personagem atualizado!")
end)

print("Wirtz Scripts carregado com sucesso!")
