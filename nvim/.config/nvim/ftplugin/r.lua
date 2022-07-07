require('nani.utils.ftype_setup').bufEnter("*.r", function(utils)
    -- Mappings em NORMAL
    vim.keymap.set('n', 'K', '<Plug>RHelp', { buffer = utils.bufnr })
    utils.wk.register({
        m = {
            name = "R",
            r = { "<Plug>RStart", "start R" },
            R = { "<Plug>RClose", "stop R" },
            h = { "<Plug>RHelp", "help" },
            p = { "<Plug>RPlot", "plot" },
            c = { "<Plug>RClearConsole", 'clear console' },
            o = {
                name = 'object browser',
                o = { '<cmd>call RObjBrowser()<cr>', 'open' },
                l = { "<Plug>ROpenLists", "open lists" },
                L = { "<Plug>RCloseLists", "close lists" },
            },
            s = {
                name = 'send',
                l = { "<Plug>RSendLine", "line" },
                b = { "<Plug>RSendFile", "buffer" },
                f = { "<Plug>RSendFunction", "function" },
            }
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
    -- Mappings em VISUAL
    utils.wk.register({
        m = {
            name = "R",
            s = {
                name = 'send',
                s = { "<Plug>RSendSelection", "selection" },
            }
        }
    }, { prefix = '<leader>', buffer = utils.bufnr, mode = 'v' })
end)
