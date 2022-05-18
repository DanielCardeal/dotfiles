local M = {}

function M.config()
    local wk = require('which-key')
    wk.register {
        g = {
            s = {
                name = "hop",
                w = { "<cmd>HopWord<cr>", "word" },
                l = { "<cmd>HopLine<cr>", "line" },
                k = { "<cmd>HopLineBC<cr>", "line up" },
                j = { "<cmd>HopLineAC<cr>", "line down" },
                ["/"] = { "<cmd>HopPattern<cr>", "pattern" },
            },
        },
    }
    vim.api.nvim_set_keymap('n', 'f', "<cmd>HopChar1<cr>", {})
    vim.api.nvim_set_keymap('n', 's', "<cmd>HopChar2<cr>", {})

    -- Inicializa hop com opções padrão
    require('hop').setup()
end

return M
