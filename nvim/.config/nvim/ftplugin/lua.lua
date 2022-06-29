local function onBufEnter()
    local wk = require('which-key')
    local bufnr = vim.fn.bufnr()
    -- Mappings locais
    wk.register({
        m = {
            name = "lua",
            S = { "<cmd>luafile %<cr>", "source file" },
        }
    }, { prefix = '<leader>', buffer = bufnr })
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.lua",
    callback = onBufEnter,
})
