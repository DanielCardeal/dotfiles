local M = {}

function M.setup()
    local wk = require('which-key')
    wk.register({
        z = { '<cmd>Goyo<cr>', 'toggle zen' },
    }, { prefix = '<leader>' })
end

return M
