require('nani.utils.ftype_setup').bufEnter("*.lua", function(utils)
    utils.wk.register({
        m = {
            name = "lua",
            s = { "<cmd>luafile %<cr>", "source file" },
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
