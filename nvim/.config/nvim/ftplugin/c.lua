local function onBufEnter()
    local wk = require('which-key')
    local bufnr = vim.fn.bufnr()
    -- Mappings locais
    wk.register({
        m = {
            name = "c",
            s = { "<cmd>Telescope tags<cr>", "search tags" },
            d = { "<C-]>", "goto definition" }
        }
    }, { prefix = '<leader>', buffer = bufnr })
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.c", "*.h" },
    callback = onBufEnter,
})
