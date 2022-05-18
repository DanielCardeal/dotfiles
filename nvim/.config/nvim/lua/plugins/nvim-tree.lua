local M = {}

function M.setup()
    local g = vim.g
    g.nvim_tree_group_empty = 1
end

function M.config()
    require('nvim-tree').setup { }
    -- Mappings
    local wk = require('which-key')
    wk.register({
        ['<tab>'] = { '<cmd>NvimTreeToggle<cr>', 'toggle tree' },
    }, { prefix = '<leader>' })
end

return M
