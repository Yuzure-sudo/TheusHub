-- TheusHub.lua - Script principal para integração com o bot de keys
-- Carregar a UI library
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Variáveis globais
local KeyAuthorized = false
local KeyExpired = false
local UserKey = ""
local KeyData = nil

-- Função para validar a key
local function ValidateKey(key)
    -- Simulação de validação - no futuro, isso fará uma requisição HTTP para seu servidor
    -- que verificará a key contra o users.json do bot Discord
    local success, result
    
    success, result = pcall(function()
        -- Aqui você implementaria a verificação real com seu servidor
        -- Por enquanto, vamos simular algumas keys válidas
        local validKeys = {
            ["WIRTZ-1234-5678-9012"] = {
                user_id = "123456789",
                plan = "weekly",
                expiry = os.time() + 604800, -- 7 dias
                hwid = nil
            },
            -- Adicione mais keys para testes
        }
        
        if validKeys[key] then
            if validKeys[key].expiry and validKeys[key].expiry < os.time() then
                return false, "expired"
            end
            return true, validKeys[key]
        end
        return false, "invalid"
    end)
    
    if not success then
        return false, "error"
    end
    
    return result
end

-- Criar a janela de autenticação
local AuthWindow = redzlib:MakeWindow({
    Title = "Wirtz Scripts Premium",
    SubTitle = "Autenticação",
    SaveFolder = "WirtzScripts"
})

-- Ícone de minimizar com imagem ajustada
AuthWindow:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://18751483361",
        BackgroundTransparency = 0
    },
    Corner = {
        CornerRadius = UDim.new(35, 1)
    },
})

-- Criar aba de autenticação
local AuthTab = AuthWindow:AddTab("Login")
local AuthSection = AuthTab:AddSection("Insira sua Key")

-- Campo para inserir a key
AuthSection:AddTextBox({
    Name = "Key",
    Flag = "KeyInput",
    Value = "",
    Callback = function(Value)
        UserKey = Value
    end
})

-- Botão para verificar a key
AuthSection:AddButton({
    Name = "Verificar Key",
    Callback = function()
        if UserKey == "" then
            AuthSection:AddParagraph("Erro", "Por favor, insira uma key válida!")
            return
        end
        
        AuthSection:AddParagraph("Verificando...", "Aguarde enquanto verificamos sua key.")
        
        -- Simular um pequeno delay para parecer que está verificando
        task.wait(1.5)
        
        local isValid, data = ValidateKey(UserKey)
        
        if isValid == true then
            KeyAuthorized = true
            KeyData = data
            AuthSection:AddParagraph("Sucesso! ✅", "Key validada com sucesso!")
            
            -- Verificar se a key está próxima de expirar
            if KeyData.expiry then
                local daysLeft = math.floor((KeyData.expiry - os.time()) / 86400)
                if daysLeft < 3 then
                    AuthSection:AddParagraph("⚠️ Aviso", "Sua key expira em " .. daysLeft .. " dias! Renove agora!")
                end
            end
            
            task.wait(2)
            AuthWindow:Destroy()
            LoadMainScript()
        elseif data == "expired" then
            KeyExpired = true
            AuthSection:AddParagraph("❌ Key Expirada", "Sua key expirou! Por favor, renove no Discord.")
        else
            AuthSection:AddParagraph("❌ Key Inválida", "A key inserida não é válida. Verifique e tente novamente.")
        end
    end
})

-- Informações sobre como obter uma key
local InfoSection = AuthTab:AddSection("Informações")

InfoSection:AddParagraph("Como obter uma key?", "Entre no nosso Discord e use o comando !menu para adquirir sua key.")

InfoSection:AddButton({
    Name = "Copiar Link do Discord",
    Callback = function()
        setclipboard("https://discord.gg/wirtzscripts")
        InfoSection:AddParagraph("Link Copiado!", "O link do Discord foi copiado para sua área de transferência.")
    end
})

-- Função para carregar o script principal após autenticação
function LoadMainScript()
    -- Criar a janela principal
    local Window = redzlib:MakeWindow({
        Title = "Wirtz Scripts Premium",
        SubTitle = "by Wirtz Team",
        SaveFolder = "WirtzScripts"
    })
    
    -- Ícone de minimizar com imagem ajustada
    Window:AddMinimizeButton({
        Button = {
            Image = "rbxassetid://18751483361",
            BackgroundTransparency = 0
        },
        Corner = {
            CornerRadius = UDim.new(35, 1)
        },
    })
    
    -- Informações da key
    local InfoTab = Window:AddTab("Informações")
    local KeyInfoSection = InfoTab:AddSection("Informações da Key")
    
    -- Mostrar informações da key
    local planName = KeyData.plan:gsub("^%l", string.upper) -- Primeira letra maiúscula
    KeyInfoSection:AddParagraph("Key", UserKey)
    KeyInfoSection:AddParagraph("Plano", planName)
    
    if KeyData.expiry then
        local expiryDate = os.date("%d/%m/%Y %H:%M", KeyData.expiry)
        KeyInfoSection:AddParagraph("Expira em", expiryDate)
        
        -- Mostrar dias restantes
        local daysLeft = math.floor((KeyData.expiry - os.time()) / 86400)
        KeyInfoSection:AddParagraph("Dias Restantes", daysLeft .. " dias")
    else
        KeyInfoSection:AddParagraph("Expira em", "Nunca (Vitalício)")
    end
    
    -- Tabs principais do script
    local MainTab = Window:AddTab("Principal")
    local FarmingSection = MainTab:AddSection("Auto Farm")
    
    FarmingSection:AddToggle({
        Name = "Auto Farm",
        Flag = "AutoFarm",
        Value = false,
        Callback = function(Value)
            -- Código para auto farm
            if Value then
                FarmingSection:AddParagraph("Auto Farm", "Auto Farm ativado!")
            else
                FarmingSection:AddParagraph("Auto Farm", "Auto Farm desativado!")
            end
        end
    })
    
    FarmingSection:AddDropdown({
        Name = "Selecione o Mob",
        Flag = "SelectedMob",
        List = {"Bandit", "Monkey", "Gorilla", "Marine"},
        Value = "Bandit",
        Callback = function(Value)
            FarmingSection:AddParagraph("Mob Selecionado", "Você selecionou: " .. Value)
        end
    })
    
    -- Seção de combate
    local CombatSection = MainTab:AddSection("Combate")
    
    CombatSection:AddToggle({
        Name = "Kill Aura",
        Flag = "KillAura",
        Value = false,
        Callback = function(Value)
            -- Código para kill aura
        end
    })
    
    CombatSection:AddToggle({
        Name = "Auto Skills",
        Flag = "AutoSkills",
        Value = false,
        Callback = function(Value)
            -- Código para auto skills
        end
    })
    
    CombatSection:AddToggle({
        Name = "Perfect Block",
        Flag = "PerfectBlock",
        Value = false,
        Callback = function(Value)
            -- Código para perfect block
        end
    })
    
    -- Tab de teleportes
    local TeleportTab = Window:AddTab("Teleporte")
    local TeleportSection = TeleportTab:AddSection("Locais")
    
    local locations = {
        "Starter Island",
        "Marine Island",
        "Desert Island",
        "Frozen Island",
        "Colosseum"
    }
    
    for _, location in ipairs(locations) do
        TeleportSection:AddButton({
            Name = location,
            Callback = function()
                TeleportSection:AddParagraph("Teleporte", "Teleportando para " .. location .. "...")
                -- Código de teleporte aqui
            end
        })
    end
    
    -- Tab de frutas
    local FruitTab = Window:AddTab("Frutas")
    local FruitSection = FruitTab:AddSection("Frutas")
    
    FruitSection:AddToggle({
        Name = "ESP Frutas",
        Flag = "FruitESP",
        Value = false,
        Callback = function(Value)
            -- Código para ESP de frutas
        end
    })
    
    FruitSection:AddToggle({
        Name = "Auto Coletar Frutas",
        Flag = "AutoCollectFruit",
        Value = false,
        Callback = function(Value)
            -- Código para auto coletar frutas
        end
    })
    
    FruitSection:AddToggle({
        Name = "Notificar Frutas",
        Flag = "NotifyFruit",
        Value = true,
        Callback = function(Value)
            -- Código para notificar quando uma fruta spawnar
        end
    })
    
    -- Tab de configurações
    local SettingsTab = Window:AddTab("Configurações")
    local UISection = SettingsTab:AddSection("Interface")
    
    UISection:AddColorPicker({
        Name = "Cor do Tema",
        Flag = "UIColor",
        Value = Color3.fromRGB(255, 0, 0),
        Callback = function(Value)
            -- Código para mudar cor do tema
        end
    })
    
    UISection:AddSlider({
        Name = "Transparência da UI",
        Flag = "UITransparency",
        Value = 0,
        Min = 0,
        Max = 100,
        Callback = function(Value)
            -- Código para ajustar transparência
        end
    })
    
    local MiscSection = SettingsTab:AddSection("Diversos")
    
    MiscSection:AddButton({
        Name = "Copiar Discord",
        Callback = function()
            setclipboard("https://discord.gg/wirtzscripts")
            MiscSection:AddParagraph("Link Copiado!", "O link do Discord foi copiado para sua área de transferência.")
        end
    })
    
    MiscSection:AddButton({
        Name = "Sair do Script",
        Callback = function()
            Window:Destroy()
        end
    })
    
    -- Verificação anti-kick (para evitar detecção)
    spawn(function()
        while wait(10) do
            if not KeyAuthorized then
                Window:Destroy()
                game.Players.LocalPlayer:Kick("Autenticação inválida. Por favor, reinicie o script.")
                break
            end
        end
    end)
    
    -- Verificação periódica da key (a cada 5 minutos)
    spawn(function()
        while wait(300) do
            local isStillValid, _ = ValidateKey(UserKey)
            if not isStillValid then
                Window:Destroy()
                game.Players.LocalPlayer:Kick("Sua key expirou ou foi revogada. Por favor, renove no Discord.")
                break
            end
        end
    end)
end

-- Mensagem de boas-vindas
game.StarterGui:SetCore("SendNotification", {
    Title = "Wirtz Scripts Premium",
    Text = "Bem-vindo! Por favor, insira sua key para continuar.",
    Duration = 5
})

-- Verificar se o jogo é suportado
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    -- Blox Fruits
    print("Wirtz Scripts Premium - Blox Fruits detectado!")
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Jogo não suportado",
        Text = "Este jogo não é suportado pelo Wirtz Scripts Premium.",
        Duration = 5
    })
    return
end
