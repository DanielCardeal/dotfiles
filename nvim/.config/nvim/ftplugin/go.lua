-- Use tabs instead of whitespaces for go
vim.opt.expandtab = false

require("which-key").add({
    {
        buffer = true,
        {
            { "<leader>m", group = "go" },
            {
                "<leader>mt",
                "<cmd>GoTest<cr>",
                desc = "test",
            },
            {
                "<leader>mT",
                "<cmd>GoTest ./...<cr>",
                desc = "test all",
            },
        },
    },
})
