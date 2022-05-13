local M = {}

function M.config()
    local on_attach = function(bufnr)
        local wk = require('which-key')
        local gs = package.loaded.gitsigns
        wk.register({
            g = {
                name = "git",
                s = { '<cmd>Gitsigns stage_hunk<cr>', 'stage hunk' },
                u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'undo hunk' },
                d = { gs.diffthis, 'diff file' },
                p = { gs.preview_hunk, 'preview hunk' }
            },
        }, { buffer = bufnr, prefix = '<leader>' })
        wk.register({
            ["["] = { h = { gs.prev_hunk, 'prev hunk' } },
            ["]"] = { h = { gs.next_hunk, 'next hunk' } },
        }, { buffer = bufnr })
    end

    require('gitsigns').setup { on_attach = on_attach }
end

return M
