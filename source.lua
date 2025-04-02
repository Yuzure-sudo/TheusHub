local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Configurações
local Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoSkill = false,
    NoClip = false,
    ChestFarm = false,
    ESP = {
        Mobs = false
    }
}

-- Key do Script
_G.Key = "THEUSHUB"

-- Interface Mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Botões Mobile
local function createButton(text, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0.1, 0)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button

    return Button
end

-- Auto Farm
local function autoFarm()
    while Settings.AutoFarm do
        local nearestMob = nil
        local shortestDistance = math.huge
        
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and 
               mob:FindFirstChild("HumanoidRootPart") and 
               mob.Humanoid.Health > 0 then
                local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestMob = mob
                end
            end
        end
        
        if nearestMob then
            local targetPos = nearestMob.HumanoidRootPart.Position + Vector3.new(0, 20, 0)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {
                CFrame = CFrame.new(targetPos, nearestMob.HumanoidRootPart.Position)
            })
            tween:Play()
            
            for i = 1, 10 do
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                wait(0.01)
            end
        end
        wait()
    end
end

-- Fast Attack
local function fastAttack()
    while Settings.FastAttack do
        game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
        wait(0.01)
    end
end

-- Auto Skill
local function autoSkill()
    while Settings.AutoSkill do
        local skills = {"Z", "X", "C", "V"}
        for _, skill in pairs(skills) do
            VirtualUser:TypeKey(skill)
            wait(0.1)
        end
        wait(1)
    end
end

-- No Clip
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Criação dos Botões
local autoFarmButton = createButton("Auto Farm", UDim2.new(0.05, 0, 0.05, 0))
local fastAttackButton = createButton("Fast Attack", UDim2.new(0.05, 0, 0.2, 0))
local autoSkillButton = createButton("Auto Skill", UDim2.new(0.05, 0, 0.35, 0))
local noClipButton = createButton("No Clip", UDim2.new(0.05, 0, 0.5, 0))

-- Eventos dos Botões
autoFarmButton.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    autoFarmButton.BackgroundColor3 = Settings.AutoFarm and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40)
    if Settings.AutoFarm then
        coroutine.wrap(autoFarm)()
    end
end)

fastAttackButton.MouseButton1Click:Connect(function()
    Settings.FastAttack = not Settings.FastAttack
    fastAttackButton.BackgroundColor3 = Settings.FastAttack and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40)
    if Settings.FastAttack then
        coroutine.wrap(fastAttack)()
    end
end)

autoSkillButton.MouseButton1Click:Connect(function()
    Settings.AutoSkill = not Settings.AutoSkill
    autoSkillButton.BackgroundColor3 = Settings.AutoSkill and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40)
    if Settings.AutoSkill then
        coroutine.wrap(autoSkill)()
    end
end)

noClipButton.MouseButton1Click:Connect(function()
    Settings.NoClip = not Settings.NoClip
    noClipButton.BackgroundColor3 = Settings.NoClip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40)
end)

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Interface simplificada para mobile
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
keyFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = ScreenGui

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0.3, 0)
keyInput.Position = UDim2.new(0.1, 0, 0.2, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextSize = 18
keyInput.PlaceholderText = "Enter Key..."
keyInput.Parent = keyFrame

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.8, 0, 0.3, 0)
submitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 18
submitButton.Text = "Submit"
submitButton.Parent = keyFrame

submitButton.MouseButton1Click:Connect(function()
    if keyInput.Text == _G.Key then
        keyFrame:Destroy()
        MainFrame.Visible = true
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "Invalid Key!"
        wait(1)
        keyInput.PlaceholderText = "Enter Key..."
    end
end)

MainFrame.Visible = false