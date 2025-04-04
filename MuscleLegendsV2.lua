local success, result = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/MuscleLegendsV2.lua"))()
end)

if not success then
    warn("Erro ao carregar script: " .. tostring(result))
    -- Tentativa de backup
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/backup.lua"))()
end