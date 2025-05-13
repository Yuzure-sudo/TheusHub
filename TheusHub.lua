-- WirtzScripts.lua - Script com UI Customizada para Blox Fruits
-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

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

-- Cores para UI
local Colors = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(50, 50, 50),
    ToggleOn = Color3.fromRGB(0, 255, 0),
    ToggleOff = Color3.fromRGB(255, 0, 0)
}

-- Criar UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WirtzScriptsUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Colors.Accent
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Wirtz Scripts Premium"
TitleLabel.TextColor3 = Colors.Text
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Abas
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Colors.Button
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local Tabs = {
    Main = Instance.new("TextButton"),
    Misc = Instance.new("TextButton")
}

local CurrentTab = "Main"

local function SetupTab(tab, name, position)
    tab.Name = name
    tab.Size = UDim2.new(0.5, 0, 1, 0)
    tab.Position = UDim2.new(0.5 * (position - 1), 0, 0, 0)
    tab.BackgroundColor3 = CurrentTab == name and Colors.Accent or Colors.Button
    tab.Text = name
    tab.TextColor3 = Colors.Text
    tab.Font = Enum.Font.SourceSans
    tab.TextSize = 16
    tab.BorderSizePixel = 0
    tab.Parent = TabContainer
    
    tab.MouseButton1Click:Connect(function()
        CurrentTab = name
        UpdateTabs()
        UpdateContent()
    end)
end

SetupTab(Tabs.Main, "Principal", 1)
SetupTab(Tabs.Misc, "Diversos", 2)

local function UpdateTabs()
    for name, tab in pairs(Tabs) do
        tab.BackgroundColor3 = CurrentTab == name and Colors.Accent or Colors.Button
    end
end

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Conteúdo das abas
local MainContent = Instance.new("Frame")
MainContent.Name = "MainContent"
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.Visible = true
MainContent.Parent = ContentFrame

local MiscContent = Instance.new("Frame")
MiscContent.Name = "MiscContent"
MiscContent.Size = UDim2.new(1, 0, 1, 0)
MiscContent.BackgroundTransparency = 1
MiscContent.Visible = false
MiscContent.Parent = ContentFrame

local function UpdateContent()
    MainContent.Visible = CurrentTab == "Main"
    MiscContent.Visible = CurrentTab == "Misc"
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

-- Componentes da UI - Principal
local FarmSection = Instance.new("Frame")
FarmSection.Name = "FarmSection"
FarmSection.Size = UDim2.new(1, 0, 0, 100)
FarmSection.Position = UDim2.new(0, 10, 0, 10)
FarmSection.BackgroundColor3 = Colors.Button
FarmSection.BorderSizePixel = 1
FarmSection.Parent = MainContent

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Name = "FarmTitle"
FarmTitle.Size = UDim2.new(1, 0, 0, 20)
FarmTitle.BackgroundTransparency = 1
FarmTitle.Text = "Auto Farm"
FarmTitle.TextColor3 = Colors.Text
FarmTitle.Font = Enum.Font.SourceSansBold
FarmTitle.TextSize = 16
FarmTitle.Parent = FarmSection

local FarmToggle = Instance.new("TextButton")
FarmToggle.Name = "FarmToggle"
FarmToggle.Size = UDim2.new(0, 60, 0, 30)
FarmToggle.Position = UDim2.new(0, 10, 0, 30)
FarmToggle.BackgroundColor3 = Settings.AutoFarm and Colors.ToggleOn or Colors.ToggleOff
FarmToggle.Text = Settings.AutoFarm and "ON" or "OFF"
FarmToggle.TextColor3 = Colors.Text
FarmToggle.Font = Enum.Font.SourceSans
FarmToggle.TextSize = 14
FarmToggle.Parent = FarmSection

FarmToggle.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    FarmToggle.BackgroundColor3 = Settings.AutoFarm and Colors.ToggleOn or Colors.ToggleOff
    FarmToggle.Text = Settings.AutoFarm and "ON" or "OFF"
    if Settings.AutoFarm then
        StartAutoFarm()
    elseif AutoFarmCoroutine then
        coroutine.close(AutoFarmCoroutine)
    end
end)

local MobDropdown = Instance.new("TextButton")
MobDropdown.Name = "MobDropdown"
MobDropdown.Size = UDim2.new(0, 150, 0, 30)
MobDropdown.Position = UDim2.new(0, 80, 0, 30)
MobDropdown.BackgroundColor3 = Colors.Button
MobDropdown.Text = "Mob: " .. Settings.SelectedMob
MobDropdown.TextColor3 = Colors.Text
MobDropdown.Font = Enum.Font.SourceSans
MobDropdown.TextSize = 14
MobDropdown.Parent = FarmSection

local mobList = {"Bandit", "Monkey", "Gorilla", "Marine"}
local mobDropdownOpen = false
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Size = UDim2.new(0, 150, 0, #mobList * 30)
DropdownFrame.Position = UDim2.new(0, 80, 0, 60)
DropdownFrame.BackgroundColor3 = Colors.Button
DropdownFrame.BorderSizePixel = 1
DropdownFrame.Visible = false
DropdownFrame.Parent = FarmSection

for i, mob in ipairs(mobList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
    btn.BackgroundColor3 = Colors.Button
    btn.Text = mob
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = DropdownFrame
    
    btn.MouseButton1Click:Connect(function()
        Settings.SelectedMob = mob
        MobDropdown.Text = "Mob: " .. mob
        DropdownFrame.Visible = false
        mobDropdownOpen = false
    end)
end

MobDropdown.MouseButton1Click:Connect(function()
    mobDropdownOpen = not mobDropdownOpen
    DropdownFrame.Visible = mobDropdownOpen
end)

-- Componentes da UI - Combate
local CombatSection = Instance.new("Frame")
CombatSection.Name = "CombatSection"
CombatSection.Size = UDim2.new(1, 0, 0, 70)
CombatSection.Position = UDim2.new(0, 10, 0, 120)
CombatSection.BackgroundColor3 = Colors.Button
CombatSection.BorderSizePixel = 1
CombatSection.Parent = MainContent

local CombatTitle = Instance.new("TextLabel")
CombatTitle.Name = "CombatTitle"
CombatTitle.Size = UDim2.new(1, 0, 0, 20)
CombatTitle.BackgroundTransparency = 1
CombatTitle.Text = "Combate"
CombatTitle.TextColor3 = Colors.Text
CombatTitle.Font = Enum.Font.SourceSansBold
CombatTitle.TextSize = 16
CombatTitle.Parent = CombatSection

local KillAuraToggle = Instance.new("TextButton")
KillAuraToggle.Name = "KillAuraToggle"
KillAuraToggle.Size = UDim2.new(0, 60, 0, 30)
KillAuraToggle.Position = UDim2.new(0, 10, 0, 30)
KillAuraToggle.BackgroundColor3 = Settings.KillAura and Colors.ToggleOn or Colors.ToggleOff
KillAuraToggle.Text = Settings.KillAura and "ON" or "OFF"
KillAuraToggle.TextColor3 = Colors.Text
KillAuraToggle.Font = Enum.Font.SourceSans
KillAuraToggle.TextSize = 14
KillAuraToggle.Parent = CombatSection

KillAuraToggle.MouseButton1Click:Connect(function()
    Settings.KillAura = not Settings.KillAura
    KillAuraToggle.BackgroundColor3 = Settings.KillAura and Colors.ToggleOn or Colors.ToggleOff
    KillAuraToggle.Text = Settings.KillAura and "ON" or "OFF"
    if Settings.KillAura then
        StartKillAura()
    elseif KillAuraCoroutine then
        coroutine.close(KillAuraCoroutine)
    end
end)

-- Componentes da UI - Diversos
local MiscSection = Instance.new("Frame")
MiscSection.Name = "MiscSection"
MiscSection.Size = UDim2.new(1, 0, 0, 70)
MiscSection.Position = UDim2.new(0, 10, 0, 10)
MiscSection.BackgroundColor3 = Colors.Button
MiscSection.BorderSizePixel = 1
MiscSection.Parent = MiscContent

local MiscTitle = Instance.new("TextLabel")
MiscTitle.Name = "MiscTitle"
MiscTitle.Size = UDim2.new(1, 0, 0, 20)
MiscTitle.BackgroundTransparency = 1
MiscTitle.Text = "Diversos"
MiscTitle.TextColor3 = Colors.Text
MiscTitle.Font = Enum.Font.SourceSansBold
MiscTitle.TextSize = 16
MiscTitle.Parent = MiscSection

local NoClipToggle = Instance.new("TextButton")
NoClipToggle.Name = "NoClipToggle"
NoClipToggle.Size = UDim2.new(0, 60, 0, 30)
NoClipToggle.Position = UDim2.new(0, 10, 0, 30)
NoClipToggle.BackgroundColor3 = Settings.NoClip and Colors.ToggleOn or Colors.ToggleOff
NoClipToggle.Text = Settings.NoClip and "ON" or "OFF"
NoClipToggle.TextColor3 = Colors.Text
NoClipToggle.Font = Enum.Font.SourceSans
NoClipToggle.TextSize = 14
NoClipToggle.Parent = MiscSection

NoClipToggle.MouseButton1Click:Connect(function()
    Settings.NoClip = not Settings.NoClip
    NoClipToggle.BackgroundColor3 = Settings.NoClip and Colors.ToggleOn or Colors.ToggleOff
    NoClipToggle.Text = Settings.NoClip and "ON" or "OFF"
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
