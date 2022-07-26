local M = {}

function M.config()
    -- require('mini.indentscope').setup({
    --     draw = {
    --         delay = 100,
    --         animation = require('mini.indentscope').gen_animation('none'),
    --     },
    --     options = {
    --         try_as_border = true,
    --     },
    --     symbol = '│',
    -- })
    require('mini.comment').setup()
    require('mini.bufremove').setup()
end

return M
