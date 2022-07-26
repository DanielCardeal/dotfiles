local M = {}

function M.config()
    local options = {
        defaults = {
            prompt_prefix = "  ",
            mappings = {
                i = {
                    ["<C-q>"] = require('telescope.actions').smart_send_to_qflist,
                }
            }
        },
        extensions = {
            -- Extensão para fuzzy search com padrões inteligentes
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
            },
            -- Usa o telescope no lugar de vim.ui.select
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {}
            },
        },
        pickers = {
            find_files = {
                -- Mostra arquivos ocultos em <leader>ff
                hidden = true,
                file_ignore_patterns = { '.git' },
            },
            live_grep = {
                -- Busca em arquivos oculto em <leader>sp
                additional_args = function(_)
                    return { '--hidden' }
                end,
                file_ignore_patterns = { '.git' },
            }
        }
    }

    -- Temas
    local themes = {
        ivy = {},
        dropdown = { 'find_files', 'old_files', 'git_files', 'buffers', 'oldfiles' },
        cursor = {},
    }
    for theme, pickers in pairs(themes) do
        for _, picker in ipairs(pickers) do
            options.pickers[picker] = options.pickers[picker] or {}
            options.pickers[picker].theme = theme
        end
    end

    -- Inicialização e extensões
    local t = require('telescope')
    t.setup(options)
    t.load_extension('fzf')
    t.load_extension('ui-select')

    if vim.fn.executable('zoxide') then
        require('telescope._extensions.zoxide.config').setup {
            mappings = {
                default = {
                    action = function(selection)
                        vim.cmd('tcd ' .. selection.path)
                    end,
                    after_action = function(selection)
                        vim.notify('Changed tab cwd to ' .. selection.path)
                    end
                },
            }
        }
        t.load_extension('zoxide')
    end
end

return M
