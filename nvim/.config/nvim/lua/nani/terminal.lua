-- Corrige caractere emitido por <C-,>, <C-[>, ... no kitty. Para mais
-- informações:
-- https://github.com/neovim/neovim/issues/17867#issuecomment-1079934289
if vim.env.TERM == 'xterm-kitty' then
    vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
    vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

-- Usa neovim-remote como editor padrão (importante porque faz o git abrir
-- direto no neovim):
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

-- Usa <c-,> como esc do modo terminal
vim.keymap.set('t', [[<C-,>]], [[<C-\><C-n>]])
