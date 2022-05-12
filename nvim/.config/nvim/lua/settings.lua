-- Variaveis globais
local g = vim.g
g.mapleader = ' '

-- Opções globais
local o = vim.o
o.swapfile = false
o.backup = false
-- Busca
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
-- Navegação
o.scrolloff = 5
-- Copia e cola consistente
o.clipboard = 'unnamed,unnamedplus'
-- Edição
o.smartindent = true
-- Caracteres invisíveis
o.list = true
-- Tempo de espera entre comandos
o.timeoutlen = 500

-- Opções de janela
local wo = vim.wo
-- Estética
wo.number = true
wo.cursorline = true
-- Folds
wo.foldminlines = 5

-- Opções gerais
local opt = vim.opt
opt.tabstop = 4
opt.shiftwidth = 0
opt.expandtab = true
opt.undofile = true -- undo persistente
