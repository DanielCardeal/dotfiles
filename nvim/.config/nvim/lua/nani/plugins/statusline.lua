local M = {}
function M.config()
    local ll = require('lualine')
    local custom_components = {
        filename = {
            'filename',
            path = 1,
            symbols = { modified = ' ⏺', readonly = ' 🔒',
            }
        },
        diff = {
            'diff',
            symbols = { added = ' ', modified = '柳', removed = ' ' }
        },
        diagnostics = {
            'diagnostics',
            symbols = { error = ' ', warn = ' ', info = ' ' },
        }
    }

    ll.setup {
        options = {
            theme = "auto",
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', custom_components.diff },
            lualine_c = { custom_components.filename },
            lualine_x = { custom_components.diagnostics },
            lualine_y = { 'filetype' },
            lualine_z = { 'location', 'progress' }
        },
        tabline = {
            lualine_a = { 'tabs' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'buffers' },
        }
    }
end

return M
