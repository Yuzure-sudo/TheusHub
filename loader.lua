-- loader.lua
local link = "https://raw.githubusercontent.com/TheusHub/BloxFruits/main/source.lua"

local function loadScript()
    local success, script = pcall(function()
        return game:HttpGet(link)
    end)
    
    if success then
        -- Remove a GUI antiga se existir
        local oldGui = game.CoreGui:FindFirstChild("TheusLoader")
        if oldGui then oldGui:Destroy() end
        
        -- Executa o script
        loadstring(script)()
        
        -- Inicializa o script
        local TheusHub = require(script)
        TheusHub.Initialize()
    else
        warn("Erro ao carregar o script")
    end
end

-- Executa diretamente sem criar botão
loadScript()