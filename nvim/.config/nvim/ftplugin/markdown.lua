require('nani.utils.ftype_setup').bufEnter("*.md", function(utils)
    utils.wk.register({
        m = {
            name = 'markdown',
            p = { "<cmd>MarkdownPreview<cr>", "start preview" },
            P = { "<cmd>MarkdownPreviewStop<cr>", "stop preview" },
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
