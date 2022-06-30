local M = {}

function M.config()
    require('diffview').setup {
        enhanced_diff_hl = true,
        file_panel = {
            win_config = {
                position = 'bottom',
                height = 10,
            }
        }
    }
end

return M
