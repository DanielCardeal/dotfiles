local M = {}

function M.config()
    local wk = require('which-key')
    wk.register({
        f = { "<cmd>HopChar1<cr>" },
        s = { "<cmd>HopChar2<cr>" },
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
    })

    -- Inicializa hop com opções padrão
    require('hop').setup()
end

return M
