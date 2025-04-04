local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Muscle Legends Script", "Ocean")

-- Main
local Main = Window:NewTab("Principal")
local MainSection = Main:NewSection("Funções Principais")

MainSection:NewToggle("Auto Strength", "Treina força automaticamente", function(state)
    getgenv().autoStrength = state
    while getgenv().autoStrength do
        local args = {
            [1] = "rep"
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
        wait()
    end
end)

MainSection:NewToggle("Auto Sell", "Vende força automaticamente", function(state)
    getgenv().autoSell = state
    while getgenv().autoSell do
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer("sellMuscle")
        wait(0.1)
    end
end)

-- Stats Farm
local Farm = Window:NewTab("Farm")
local FarmSection = Farm:NewSection("Auto Farm")

FarmSection:NewToggle("Auto Durability", "Treina durabilidade automaticamente", function(state)
    getgenv().autoDurability = state
    while getgenv().autoDurability do
        local args = {
            [1] = "durability"
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
        wait()
    end
end)

FarmSection:NewToggle("Auto Agility", "Treina agilidade automaticamente", function(state)
    getgenv().autoAgility = state
    while getgenv().autoAgility do
        local args = {
            [1] = "speed"
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
        wait()
    end
end)

-- Teleports
local Teleport = Window:NewTab("Teleportes")
local TeleportSection = Teleport:NewSection("Areas")

TeleportSection:NewButton("Spawn", "Teleporta para o Spawn", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 3, 0)
end)

TeleportSection:NewButton("Muscle Island", "Teleporta para Muscle Island", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4000, 3, 0)
end)

-- Misc
local Misc = Window:NewTab("Outros")
local MiscSection = Misc:NewSection("Funções Extra")

MiscSection:NewToggle("Auto Rebirth", "Faz rebirth automaticamente", function(state)
    getgenv().autoRebirth = state
    while getgenv().autoRebirth do
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer("rebirth")
        wait(1)
    end
end)

MiscSection:NewSlider("WalkSpeed", "Altera velocidade do personagem", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

MiscSection:NewSlider("JumpPower", "Altera força do pulo", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- Anti AFK
local antiAFK = true
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    if antiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)