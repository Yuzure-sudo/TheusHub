local function LoadTheusHub()
    local success, script = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/source.lua")
    end)
    
    if success then
        loadstring(script)()
    else
        warn("Erro ao carregar o script")
    end
end

-- Interface minimalista de carregamento
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LoadButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui

MainFrame.Name = "LoaderFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.Size = UDim2.new(0, 200, 0, 100)

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

LoadButton.Parent = MainFrame
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LoadButton.Position = UDim2.new(0.1, 0, 0.2, 0)
LoadButton.Size = UDim2.new(0.8, 0, 0.6, 0)
LoadButton.Font = Enum.Font.GothamBold
LoadButton.Text = "Carregar Theus Hub"
LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadButton.TextSize = 16
LoadButton.MouseButton1Click:Connect(LoadTheusHub)

local ButtonUICorner = Instance.new("UICorner")
ButtonUICorner.Parent = LoadButton
ButtonUICorner.CornerRadius = UDim.new(0, 8)