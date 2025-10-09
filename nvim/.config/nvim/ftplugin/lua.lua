-- Keymaps
local wk = require("which-key")
wk.add({
    {
        buffer = true,
        {
            { "<leader>m", group = "lua" },
            {
                "<leader>mr",
                "<cmd>source<cr>",
                desc = "run",
            },
            {
                "<leader>mc",
                function()
                    require("luasnip").cleanup()
                    vim.cmd([[so]])
                end,
                desc = "clean snips and source file",
            },
        },
    },
})
