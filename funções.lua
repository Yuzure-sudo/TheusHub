-- Tween Service
local TweenService = game:GetService("TweenService")

-- Quest Data
local QuestData = {
    ["1-9"] = {
        Monster = "Bandit [Lv. 5]",
        Quest = "BanditQuest1",
        QuestLv = 1,
        CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905),
        CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516)
    },
    ["10-14"] = {
        Monster = "Monkey [Lv. 14]",
        Quest = "JungleQuest",
        QuestLv = 1,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1402.74609, 98.5633316, 90.6417007)
    },
    ["15-29"] = {
        Monster = "Gorilla [Lv. 20]",
        Quest = "JungleQuest",
        QuestLv = 2,
        CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732),
        CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664)
    }
}

-- Tween Function
local function Tween(targetCFrame)
    local character = game.Players.LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local distance = (targetCFrame.Position - humanoidRootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(
        distance/250,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- Auto Farm Function
spawn(function()
    while wait() do
        if getgenv().AutoFarm then
            pcall(function()
                local PlayerLevel = game.Players.LocalPlayer.Data.Level.Value
                local QuestInfo
                
                if PlayerLevel >= 1 and PlayerLevel <= 9 then
                    QuestInfo = QuestData["1-9"]
                elseif PlayerLevel >= 10 and PlayerLevel <= 14 then
                    QuestInfo = QuestData["10-14"]
                elseif PlayerLevel >= 15 and PlayerLevel <= 29 then
                    QuestInfo = QuestData["15-29"]
                end
                
                if QuestInfo then
                    if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                        Tween(QuestInfo.CFrameQuest)
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestInfo.Quest, QuestInfo.QuestLv)
                        wait(0.5)
                    end

                    -- Verifica se há mobs na área
                    local foundMob = false
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == QuestInfo.Monster and v.Humanoid.Health > 0 then
                            repeat 
                                foundMob = true
                                Tween(v.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                                v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                                v.HumanoidRootPart.Transparency = 0.8
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                
                                game:GetService'VirtualUser':CaptureController()
                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                wait()
                            until not getgenv().AutoFarm or v.Humanoid.Health <= 0
                        end
                    end
                    
                    if not foundMob then
                        Tween(QuestInfo.CFrameMon)
                        wait(3)
                    end
                end
            end)
        end
    end
end)

-- Auto Stats Function
spawn(function()
    while wait() do
        for _, stat in ipairs({"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}) do
            if getgenv()["Auto" .. stat] then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
            end
        end
    end
end)

-- Auto Buso Function
spawn(function()
    while wait(1) do
        if getgenv().AutoBuso then
            if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            end
        end
    end
end)

-- Remove Fog Function
spawn(function()
    while wait() do
        if getgenv().NoFog then
            game.Lighting.FogEnd = 100000
            game.Lighting.FogStart = 100000
            game.Lighting.ClockTime = 14
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
        end
    end
end)

-- Teleport Function
spawn(function()
    while wait() do
        if _G.SelectedIsland then
            Tween(Islands[_G.SelectedIsland])
            _G.SelectedIsland = nil
        end
    end
end)

-- Anti AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)