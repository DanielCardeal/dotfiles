-- Variaveis globais ("let g:blabla")
local let = {
    mapleader = ' ',
}
for k, v in pairs(let) do
    vim.g[k] = v
end

-- Opções globais ("set blabla")
local set = {
    -- Colorscheme
    background = 'dark',
    -- Remove backups
    undofile = true,
    swapfile = false,
    backup = false,
    -- Busca
    ignorecase = true,
    smartcase = true,
    incsearch = true,
    -- Navegação
    scrolloff = 5,
    -- Copia e cola consistente
    clipboard = { 'unnamed', 'unnamedplus' },
    -- Edição
    smartindent = true,
    textwidth = 0,
    wrap = true,
    linebreak = true,
    -- Caracteres invisíveis
    list = true,
    listchars = { tab = '» ', trail = '·', eol = '¬' },
    showbreak = '↳',
    -- Tempo de espera entre comandos
    timeoutlen = 500,
    -- Statusline global
    laststatus = 3,
    -- Tab
    tabstop = 4,
    shiftwidth = 0,
    expandtab = true,
    -- Visuais
    number = true,
    cursorline = true,
    termguicolors = true,
    fillchars = { diff = '╱', eob = " " },
    -- Corretor de palavras
    spelllang = { 'pt_br', 'en' },
    -- Abrindo novas janelas
    splitright = true,
    splitbelow = true,
    -- Tempo de espera para o cursorhold
    updatetime = 300,
    -- Concealing
    conceallevel = 2,
    concealcursor = "nc",
}
for k, v in pairs(set) do
    vim.opt[k] = v
end
