-- Roblox Joystick Fly Script
-- Mobile-compatible flying script with customizable controls

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local config = {
    flySpeed = 50,
    maxSpeed = 100,
    minSpeed = 20,
    turnSensitivity = 2.5,
    mobileSupport = true,
    keyboardSupport = true,
    flyAnimation = true
}

-- Variables
local flying = false
local moveDirection = Vector3.new(0, 0, 0)
local joystickInput = Vector2.new(0, 0)
local flyVelocity = Vector3.new(0, 0, 0)
local flyGyro = nil
local flyPos = nil
local lastUpdate = tick()

-- Create UI
local function createFlyUI()
    local flyGui = Instance.new("ScreenGui")
    flyGui.Name = "FlyControlsGui"
    flyGui.ResetOnSpawn = false
    
    -- Fly Toggle Button
    local flyButton = Instance.new("ImageButton")
    flyButton.Name = "FlyButton"
    flyButton.Size = UDim2.new(0, 70, 0, 70)
    flyButton.Position = UDim2.new(0.85, 0, 0.6, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
    flyButton.BackgroundTransparency = 0.3
    flyButton.Image = "rbxassetid://7733658504" -- Fly icon
    flyButton.ImageTransparency = 0.2
    flyButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.BorderSizePixel = 0
    flyButton.Parent = flyGui
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = flyButton
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.7
    uiStroke.Parent = flyButton
    
    -- Speed Control
    local speedFrame = Instance.new("Frame")
    speedFrame.Name = "SpeedControl"
    speedFrame.Size = UDim2.new(0, 200, 0, 40)
    speedFrame.Position = UDim2.new(0.5, -100, 0.05, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    speedFrame.BackgroundTransparency = 0.3
    speedFrame.BorderSizePixel = 0
    speedFrame.Visible = false
    speedFrame.Parent = flyGui
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 10)
    speedCorner.Parent = speedFrame
    
    local speedSlider = Instance.new("TextButton")
    speedSlider.Name = "SpeedSlider"
    speedSlider.Size = UDim2.new(0.7, 0, 0.6, 0)
    speedSlider.Position = UDim2.new(0.05, 0, 0.2, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedSlider.BorderSizePixel = 0
    speedSlider.Text = ""
    speedSlider.Parent = speedFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = speedSlider
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = speedSlider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = sliderFill
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0.2, 0, 0.6, 0)
    speedLabel.Position = UDim2.new(0.78, 0, 0.2, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Text = config.flySpeed
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.Parent = speedFrame
    
    -- Mobile Joystick (only visible on mobile)
    if UserInputService.TouchEnabled then
        local joystickFrame = Instance.new("Frame")
        joystickFrame.Name = "JoystickFrame"
        joystickFrame.Size = UDim2.new(0, 150, 0, 150)
        joystickFrame.Position = UDim2.new(0.15, 0, 0.6, 0)
        joystickFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        joystickFrame.BackgroundTransparency = 0.7
        joystickFrame.BorderSizePixel = 0
        joystickFrame.Visible = false
        joystickFrame.Parent = flyGui
        
        local joystickCorner = Instance.new("UICorner")
        joystickCorner.CornerRadius = UDim.new(1, 0)
        joystickCorner.Parent = joystickFrame
        
        local joystickStick = Instance.new("Frame")
        joystickStick.Name = "Stick"
        joystickStick.Size = UDim2.new(0, 60, 0, 60)
        joystickStick.Position = UDim2.new(0.5, -30, 0.5, -30)
        joystickStick.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        joystickStick.BorderSizePixel = 0
        joystickStick.Parent = joystickFrame
        
        local stickCorner = Instance.new("UICorner")
        stickCorner.CornerRadius = UDim.new(1, 0)
        stickCorner.Parent = joystickStick
        
        -- Joystick functionality
        local joystickActive = false
        local joystickOrigin = nil
        local maxDistance = joystickFrame.Size.X.Offset / 2
        
        joystickFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                joystickActive = true
                joystickOrigin = input.Position
            end
        end)
        
        joystickFrame.InputChanged:Connect(function(input)
            if joystickActive and input.UserInputType == Enum.UserInputType.Touch then
                local delta = Vector2.new(
                    input.Position.X - joystickOrigin.X,
                    input.Position.Y - joystickOrigin.Y
                )
                
                local magnitude = delta.Magnitude
                if magnitude > maxDistance then
                    delta = delta.Unit * maxDistance
                end
                
                joystickStick.Position = UDim2.new(
                    0.5, delta.X,
                    0.5, delta.Y
                )
                
                -- Normalize input for flight control
                joystickInput = Vector2.new(
                    delta.X / maxDistance,
                    -delta.Y / maxDistance
                )
            end
        end)
        
        joystickFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                joystickActive = false
                joystickStick.Position = UDim2.new(0.5, -30, 0.5, -30)
                joystickInput = Vector2.new(0, 0)
            end
        end)
        
        -- Toggle joystick visibility with fly button
        flyButton.MouseButton1Click:Connect(function()
            flying = not flying
            flyButton.BackgroundColor3 = flying and 
                Color3.fromRGB(255, 64, 64) or 
                Color3.fromRGB(30, 136, 229)
            
            joystickFrame.Visible = flying
            speedFrame.Visible = flying
            
            if flying then
                startFlying()
            else
                stopFlying()
            end
        end)
    else
        -- For non-mobile devices
        flyButton.MouseButton1Click:Connect(function()
            flying = not flying
            flyButton.BackgroundColor3 = flying and 
                Color3.fromRGB(255, 64, 64) or 
                Color3.fromRGB(30, 136, 229)
            
            speedFrame.Visible = flying
            
            if flying then
                startFlying()
            else
                stopFlying()
            end
        end)
    end
    
    -- Speed slider functionality
    local isDragging = false
    
    speedSlider.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local sliderPosition = math.clamp(
                (input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X,
                0, 1
            )
            
            sliderFill.Size = UDim2.new(sliderPosition, 0, 1, 0)
            
            -- Update fly speed
            config.flySpeed = math.floor(config.minSpeed + sliderPosition * (config.maxSpeed - config.minSpeed))
            speedLabel.Text = tostring(config.flySpeed)
        end
    end)
    
    return flyGui
end

-- Flying mechanics
local function startFlying()
    if character and humanoid and rootPart then
        -- Disable default character controls
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        -- Create gyro and position for flight control
        flyGyro = Instance.new("BodyGyro")
        flyGyro.P = 9e4
        flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyGyro.CFrame = rootPart.CFrame
        flyGyro.Parent = rootPart
        
        flyPos = Instance.new("BodyPosition")
        flyPos.P = 9e4
        flyPos.maxForce = Vector3.new(9e9, 9e9, 9e9)
        flyPos.position = rootPart.Position
        flyPos.Parent = rootPart
        
        -- Connect update loop
        RunService:BindToRenderStep("FlyScript", Enum.RenderPriority.Character.Value, updateFlight)
        
        -- Play animation if enabled
        if config.flyAnimation then
            humanoid:LoadAnimation(flyAnim):Play()
        end
    end
end

local function stopFlying()
    if character and humanoid then
        -- Re-enable default character controls
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        
        -- Clean up flight controls
        if flyGyro then flyGyro:Destroy() end
        if flyPos then flyPos:Destroy() end
        
        flyGyro = nil
        flyPos = nil
        
        -- Disconnect update loop
        RunService:UnbindFromRenderStep("FlyScript")
    end
end

-- Flight physics update
local function updateFlight()
    if not flying or not character or not humanoid or not rootPart then return end
    
    local dt = tick() - lastUpdate
    lastUpdate = tick()
    
    -- Get camera direction for flight orientation
    local camera = workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    -- Calculate movement direction
    moveDirection = Vector3.new(0, 0, 0)
    
    -- Handle keyboard input
    if config.keyboardSupport then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + lookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - lookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - rightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + rightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
    end
    
    -- Handle mobile joystick input
    if config.mobileSupport and UserInputService.TouchEnabled then
        moveDirection = moveDirection + (lookVector * joystickInput.Y)
        moveDirection = moveDirection + (rightVector * joystickInput.X)
    end
    
    -- Normalize and apply speed
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * config.flySpeed
    end
    
    -- Update flight physics
    if flyGyro and flyPos then
        flyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
        flyPos.position = rootPart.Position + moveDirection * dt
    end
end

-- Create fly animation
local flyAnim = Instance.new("Animation")
flyAnim.AnimationId = "rbxassetid://3541044388" -- Superman fly animation

-- Set up character respawn handling
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- If was flying before, stop flying
    if flying then
        flying = false
        if flyGyro then flyGyro:Destroy() end
        if flyPos then flyPos:Destroy() end
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize UI
local flyUI = createFlyUI()
flyUI.Parent = player.PlayerGui

-- Cleanup on script end
local function cleanup()
    if flying then
        stopFlying()
    end
    
    if flyUI then
        flyUI:Destroy()
    end
end

-- Handle script termination
script.Destroying:Connect(cleanup)