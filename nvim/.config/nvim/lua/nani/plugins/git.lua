local M = {}

function M.config()
    require('gitsigns').setup {
        numhl = true,
        current_line_blame = true,
        keymaps = {}, -- Desabilita keymaps padrão
    }
end

return M
