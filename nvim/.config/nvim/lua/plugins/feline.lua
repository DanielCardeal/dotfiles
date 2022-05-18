local M = {}

function M.config()
    local fl = require('feline')
    fl.setup {
        components = require('catppuccin.core.integrations.feline'),
    }
end

return M
