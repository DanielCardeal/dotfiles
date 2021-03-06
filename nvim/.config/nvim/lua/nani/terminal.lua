-- Corrige caractere emitido por <C-,>, <C-[>, ... no kitty. Para mais
-- informações:
-- https://github.com/neovim/neovim/issues/17867#issuecomment-1079934289
if vim.env.TERM == 'xterm-kitty' then
    vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
    vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

-- Usa neovim-remote como editor padrão (importante porque faz o git abrir
-- direto no neovim):
if vim.fn.executable('nvr') == 1 then
    vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end

-- Deleta buffers abertos pelo git automaticamente ao fechar a janela (baseado
-- nas instruções do github do neovim-remote)
local augroup = vim.api.nvim_create_augroup("NaniTerminal", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit,gitrebase,gitconfig",
    callback = function()
        vim.opt.bufhidden = "delete"
    end,
    group = augroup,
})

-- Entra no insert mode automaticamente ao entrar em um terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert",
    group = augroup,
})

-- Usa <c-,> como esc do modo terminal
vim.keymap.set('t', [[<C-,>]], [[<C-\><C-n>]])
