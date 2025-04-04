local repo = 'Yuzure-sudo/TheusHub'
local branch = 'main'

local function githubRequest(file)
    return loadstring(game:HttpGet(('https://raw.githubusercontent.com/%s/%s/%s'):format(repo, branch, file)))()
end

local status, result = pcall(function()
    return githubRequest('loader.lua')
end)

if status then
    print('Script carregado com sucesso!')
else
    warn('Erro ao carregar o script:', result)
end