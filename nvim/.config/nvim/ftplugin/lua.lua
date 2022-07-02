require('nani.utils.ftype_setup').bufEnter("*.lua", function(utils)
    utils.wk.register({
        m = {
            name = "lua",
            s = { "<cmd>luafile %<cr>", "source file" },
            t = { "<cmd>bot 10sp term://lua<cr>", "open interpreter" }
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
