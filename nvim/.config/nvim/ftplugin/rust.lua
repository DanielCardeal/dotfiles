-- Função chamada quando entramos em um buffer rust
local function onBufEnter()
    local wk = require("which-key")
    local bufnr = vim.call('bufnr')
    wk.register({
        m = {
            name = 'rust',
            c = { "<cmd>RustOpenCargo<cr>", 'open cargo' },
            m = { "<cmd>RustExpandMacro<cr>", 'expand macro' },
            r = { "<cmd>RustRunnables<cr>", 'run' },
            R = { "<cmd>RustReloadWorkspace<cr>", 'reload workspace' },
        }
    }, { prefix = '<leader>', buffer = bufnr })
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rs",
    callback = onBufEnter,
})
