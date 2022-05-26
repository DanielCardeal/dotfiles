local M = {}

-- Função auxiliar para abrir/fechar a NvimTree de maneira inteligente de acordo
-- com o contexto
function M.nani_toggle_nvimtree()
    if vim.bo.filetype == "NvimTree" then
        vim.cmd [[NvimTreeClose]]
    else
        vim.cmd [[NvimTreeFocus]]
    end
end

function M.setup()
    local g = vim.g
    g.nvim_tree_group_empty = 1
end

function M.config()
    require('nvim-tree').setup {}
end

return M
