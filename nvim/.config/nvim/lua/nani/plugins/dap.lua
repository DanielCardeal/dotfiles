local M = {}

function M.config()
    local dap, dapui = require('dap'), require("dapui")
    -- DAP UI
    require('dapui').setup {
        mappings = {
            expand = { "<cr>", "<tab>" },
        },
        layout = {
            {
                -- NOTE: elementos na parte de baixo da tela
                elements = {
                    "watches",
                    "repl",
                    "console",
                    size = 0.25,
                    position = "bottom",
                }

            }
        }
    }
    -- Configura inicialização auotmática do dapui
    -- dap.listeners.after.event_initialized["dapui_config"] = function()
    --     dapui.open()
    -- end
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --     dapui.close()
    -- end
    -- Estéticos
    vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    -- Linguagens
    require('dap-python').setup("python")
end

return M
