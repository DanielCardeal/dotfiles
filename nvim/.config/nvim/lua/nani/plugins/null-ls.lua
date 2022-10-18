local M = {}

function M.config()
    local null_ls = require('null-ls')
    null_ls.setup {
        debug = true,
        sources = {
            -- C
            null_ls.builtins.formatting.clang_format,
            -- Python
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
            -- Fish
            null_ls.builtins.diagnostics.fish,
            null_ls.builtins.formatting.fish_indent,
            -- Bash
            null_ls.builtins.formatting.shfmt,
            -- Docker
            null_ls.builtins.diagnostics.hadolint,
            -- YAML
            null_ls.builtins.formatting.yamlfmt,
            null_ls.builtins.diagnostics.yamllint,
        }
    }
end

return M
