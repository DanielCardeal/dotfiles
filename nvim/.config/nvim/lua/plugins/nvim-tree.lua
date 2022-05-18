local M = {}

function M.setup()
    local g = vim.g
    g.nvim_tree_group_empty = 1
end

function M.config()
    require('nvim-tree').setup {}
end

return M
