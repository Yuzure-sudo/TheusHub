if game.PlaceId == 2753915549 then
    repeat wait() until game:IsLoaded()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/TheusHub/main/TheusHub.lua"))()
else
    game.Players.LocalPlayer:Kick("Este script só funciona no Blox Fruits!")
end