local M = {}

function M.config()
    require('diffview').setup {
        file_panel = {
            win_config = {
                position = 'bottom',
                height = 10,
            }
        }
    }
end

return M
