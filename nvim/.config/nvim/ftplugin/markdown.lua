---Função chamada quando o entramos em um buffer de markdown
local function onBufEnter()
    local wk = require("which-key")
    local bufnr = vim.call('bufnr')
    wk.register({
        m = {
            name = 'markdown',
            p = { "<cmd>MarkdownPreview<cr>", "start preview" },
            P = { "<cmd>MarkdownPreviewStop<cr>", "stop preview" },
        }
    }, { prefix = '<leader>', buffer = bufnr })
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = onBufEnter,
})
