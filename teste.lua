local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "BLOX FRUITS RAID MASTER",
   LoadingTitle = "CARREGANDO SCRIPT...",
   LoadingSubtitle = "by Lek do Black",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BFRaidConfig",
      FileName = "RaidMaster"
   }
})

-- Variáveis Principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- Tabs
local MainTab = Window:CreateTab("Principal", 4483362458)
local RaidTab = Window:CreateTab("Raid Config", 4483362458)
local MiscTab = Window:CreateTab("Extra", 4483362458)

-- Funções de Auto Raid
local RaidConfig = {
    AutoRaid = false,
    AutoBuy = false,
    SelectedChip = "Flame",
    AutoCollect = false,
    KillAura = false
}

-- Auto Farm Function
local function StartAutoRaid()
    spawn(function()
        while RaidConfig.AutoRaid do
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Timer.Visible == false then
                if not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", RaidConfig.SelectedChip)
                end
            end
            task.wait(1)
        end
    end)
end

-- Kill Aura Function
local function KillAuraFunc()
    spawn(function()
        while RaidConfig.KillAura do
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                        v.HumanoidRootPart.Transparency = 0.9
                        v.Humanoid.WalkSpeed = 0
                        v.Humanoid.JumpPower = 0
                        if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                        end
                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,50,0)
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    until not RaidConfig.KillAura or not v.Parent or v.Humanoid.Health <= 0
                end
            end
            task.wait()
        end
    end)
end

-- Auto Collect Function
local function AutoCollectFunc()
    spawn(function()
        while RaidConfig.AutoCollect do
            for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v.Name == "Fruit" and v:IsA("Tool") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                end
            end
            task.wait(1)
        end
    end)
end

-- Interface Elements
MainTab:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Flag = "AutoRaidToggle",
    Callback = function(Value)
        RaidConfig.AutoRaid = Value
        StartAutoRaid()
    end,
})

MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAuraToggle", 
    Callback = function(Value)
        RaidConfig.KillAura = Value
        KillAuraFunc()
    end,
})

RaidTab:CreateDropdown({
    Name = "Select Raid",
    Options = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"},
    CurrentOption = "Flame",
    Flag = "RaidDropdown",
    Callback = function(Option)
        RaidConfig.SelectedChip = Option
    end,
})

MainTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Flag = "AutoCollectToggle",
    Callback = function(Value)
        RaidConfig.AutoCollect = Value
        AutoCollectFunc()
    end,
})

-- Auto Buy Microchip
RaidTab:CreateToggle({
    Name = "Auto Buy Chip",
    CurrentValue = false,
    Flag = "AutoBuyToggle",
    Callback = function(Value)
        RaidConfig.AutoBuy = Value
        spawn(function()
            while RaidConfig.AutoBuy do
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc","Buy")
                task.wait(1)
            end
        end)
    end,
})

-- Misc Features
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end,
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local PlaceID = game.PlaceId
        local AllIDs = {}
        local foundAnything = ""
        local actualHour = os.date("!*t").hour
        local Deleted = false

        local File = pcall(function()
            AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
        end)
        if not File then
            table.insert(AllIDs, actualHour)
            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
        end

        function TPReturner()
            local Site;
            if foundAnything == "" then
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
            local ID = ""
            if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                foundAnything = Site.nextPageCursor
            end
            local num = 0;
            for i,v in pairs(Site.data) do
                local Possible = true
                ID = tostring(v.id)
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    for _,Existing in pairs(AllIDs) do
                        if num ~= 0 then
                            if ID == tostring(Existing) then
                                Possible = false
                            end
                        else
                            if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                    delfile("NotSameServers.json")
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end)
                            end
                        end
                        num = num + 1
                    end
                    if Possible == true then
                        table.insert(AllIDs, ID)
                        wait()
                        pcall(function()
                            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                            wait()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                        end)
                        wait(4)
                    end
                end
            end
        end

        function Teleport()
            while wait() do
                pcall(function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end)
            end
        end

        Teleport()
    end,
})

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Proteção Anti-Kick
local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(...)
    local Args = {...}
    local Self = Args[1]
    if getnamecallmethod() == "Kick" then
        return nil
    end
    return OldNameCall(...)
end)