-- Biblioteca da UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/sol"))()

-- Criação da Janela Principal
local win = Library:New({
    Name = "TheusHub - Muscle Legends",
    FolderToSave = "TheusHubML"
})

-- Tabs Principais
local mainTab = win:Tab("Principal")
local farmTab = win:Tab("Farming")
local petsTab = win:Tab("Pets")
local teleportTab = win:Tab("Teleportes")
local visualTab = win:Tab("Visual")
local miscTab = win:Tab("Misc")

-- Seção Principal
local mainSection = mainTab:Section({
    Name = "Funções Principais",
    Side = "Left"
})

mainSection:Toggle({
    Name = "Auto Strength",
    Default = false,
    Flag = "autoStrength",
    Callback = function(state)
        getgenv().autoStrength = state
        while getgenv().autoStrength do
            local args = {
                [1] = "rep"
            }
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
            wait()
        end
    end
})

mainSection:Toggle({
    Name = "Auto Sell",
    Default = false,
    Flag = "autoSell",
    Callback = function(state)
        getgenv().autoSell = state
        while getgenv().autoSell do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("sellMuscle")
            wait(0.1)
        end
    end
})

-- Seção de Farm
local farmSection = farmTab:Section({
    Name = "Auto Farm",
    Side = "Left"
})

farmSection:Toggle({
    Name = "Auto Durability",
    Default = false,
    Flag = "autoDurability",
    Callback = function(state)
        getgenv().autoDurability = state
        while getgenv().autoDurability do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("durability")
            wait()
        end
    end
})

farmSection:Toggle({
    Name = "Auto Jungle Training",
    Default = false,
    Flag = "autoJungle",
    Callback = function(state)
        getgenv().autoJungle = state
        while getgenv().autoJungle do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("jungleTraining")
            wait()
        end
    end
})

-- Seção de Pets
local petsSection = petsTab:Section({
    Name = "Gerenciamento de Pets",
    Side = "Left"
})

petsSection:Toggle({
    Name = "Auto Hatch Jungle Crystal",
    Default = false,
    Flag = "autoHatch",
    Callback = function(state)
        getgenv().autoHatch = state
        while getgenv().autoHatch do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("hatchJungleEgg")
            wait(2)
        end
    end
})

petsSection:Toggle({
    Name = "Auto Equip Best Pets",
    Default = false,
    Flag = "autoBestPets",
    Callback = function(state)
        getgenv().autoBestPets = state
        while getgenv().autoBestPets do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("equipBestPets")
            wait(5)
        end
    end
})

-- Seção de Teleportes
local teleportSection = teleportTab:Section({
    Name = "Áreas do Jogo",
    Side = "Left"
})

local locations = {
    ["Spawn"] = CFrame.new(0, 3, 0),
    ["Muscle Island"] = CFrame.new(-4000, 3, 0),
    ["Jungle Gym"] = CFrame.new(2500, 3, 0),
    ["Ancient Training Grounds"] = CFrame.new(-2000, 3, 2000)
}

for locationName, locationCFrame in pairs(locations) do
    teleportSection:Button({
        Name = locationName,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locationCFrame
        end
    })
end

-- Seção Visual
local visualSection = visualTab:Section({
    Name = "Customização Visual",
    Side = "Left"
})

visualSection:Colorpicker({
    Name = "UI Color",
    Default = Color3.fromRGB(110, 205, 255),
    Flag = "uiColor",
    Callback = function(color)
        -- Implementar mudança de cor da UI
    end
})

-- Seção Misc
local miscSection = miscTab:Section({
    Name = "Funções Extras",
    Side = "Left"
})

miscSection:Toggle({
    Name = "Auto Rebirth",
    Default = false,
    Flag = "autoRebirth",
    Callback = function(state)
        getgenv().autoRebirth = state
        while getgenv().autoRebirth do
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("rebirth")
            wait(1)
        end
    end
})

miscSection:Slider({
    Name = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 500,
    Flag = "walkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

miscSection:Slider({
    Name = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Flag = "jumpPower",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Anti AFK
local antiAFKSection = miscTab:Section({
    Name = "Anti AFK",
    Side = "Right"
})

antiAFKSection:Toggle({
    Name = "Anti AFK",
    Default = true,
    Flag = "antiAFK",
    Callback = function(state)
        local antiAFK = state
        local VirtualUser = game:GetService('VirtualUser')
        if antiAFK then
            game:GetService('Players').LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

-- Configurações de Salvamento
local savedSettings = {}
local HttpService = game:GetService("HttpService")

-- Função para salvar configurações
local function SaveSettings()
    local fileData = {}
    for flag, value in pairs(win.Flags) do
        fileData[flag] = value
    end
    writefile("TheusHubML/settings.json", HttpService:JSONEncode(fileData))
end

-- Função para carregar configurações
local function LoadSettings()
    if isfile("TheusHubML/settings.json") then
        local fileData = HttpService:JSONDecode(readfile("TheusHubML/settings.json"))
        for flag, value in pairs(fileData) do
            if win.Flags[flag] ~= nil then
                win.Flags[flag] = value
            end
        end
    end
end

-- Carregar configurações ao iniciar
LoadSettings()

-- Salvar configurações ao fechar
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == win.Name then
        SaveSettings()
    end
end)