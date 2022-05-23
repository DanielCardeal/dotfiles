-- Variaveis globais ("let g:blabla")
let = {
    mapleader = ' ',
    nani_theme = 'catppuccin',
}
for k, v in pairs(let) do
    vim.g[k] = v
end

-- Opções globais ("set blabla")
local set = {
    undofile = true,
    swapfile = false,
    backup = false,
    -- Busca
    ignorecase = true,
    smartcase = true,
    hlsearch = true,
    incsearch = true,
    -- Navegação
    scrolloff = 5,
    -- Copia e cola consistente
    clipboard = 'unnamed,unnamedplus',
    -- Edição
    smartindent = true,
    textwidth = 80,
    -- Caracteres invisíveis
    list = true,
    -- Tempo de espera entre comandos
    timeoutlen = 500,
    -- Statusline global
    laststatus = 3,
    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,
    -- Visuais
    number = true,
    cursorline = true,
}
for k, v in pairs(set) do
    vim.o[k] = v
end
