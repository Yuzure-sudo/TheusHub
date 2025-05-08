local player = game.Players.LocalPlayer
local flying = false
local speed = 50

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.85, 0)
button.Text = "Fly"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")

local bodyGyro, bodyVelocity

local function startFlying()
	local character = player.Character
	local hrp = character:WaitForChild("HumanoidRootPart")

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.velocity = Vector3.new(0,0,0)
	bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = hrp

	flying = true

	RunService.RenderStepped:Connect(function()
		if flying then
			local cam = workspace.CurrentCamera
			bodyVelocity.velocity = cam.CFrame.LookVector * speed
			bodyGyro.CFrame = cam.CFrame
		end
	end)
end

local function stopFlying()
	flying = false if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

button.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
		button.Text = "Fly"
	else
		startFlying()
		button.Text = "Stop"
	end
end)