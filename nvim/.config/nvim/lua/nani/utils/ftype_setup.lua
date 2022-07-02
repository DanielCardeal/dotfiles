local M = {}

---Configura callback para BufEnter dado um determinado filetype. A função de
---callback recebe como argumentos uma tabela com alguns valores úteis para
---evitar a repetição de código.
---@param ft string | table O filetype que deve ser configurado
---@param callback function A função de callback. Recebe como parâmetro uma tabela `utils` contendo: wk (which-key), bufnr (número do buffer)
function M.bufEnter(ft, callback)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = ft,
        callback = function()
            local wk = require('which-key')
            local bufnr = vim.fn.bufnr()
            callback { wk = wk, bufnr = bufnr }
        end
    })
end

return M
