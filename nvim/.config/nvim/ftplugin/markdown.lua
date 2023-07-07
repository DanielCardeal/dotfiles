-- Compilação automática usando pandoc
local function setup_autocompile(_)
    if not vim.fn.executable('pandoc') then
        error("Impossível começar compilação automática: compilador `pandoc` não encontrado.")
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = '*.md',
        group = vim.api.nvim_create_augroup("MarkdownAutocompile", { clear = true }),
        callback = function()
            local basename = vim.fn.expand("<afile>:p:r")
            local cur_file = basename .. '.md'
            local out_file = basename .. '.pdf'
            vim.fn.jobstart({
                "pandoc",
                "-f", "markdown-implicit_figures",
                "-V", "colorlinks=true",
                "--listings",
                "-o", out_file,
                cur_file,
            })
        end
    })
end

local function stop_autocompile(_)
    vim.api.nvim_del_augroup_by_name("MarkdownAutocompile")
end

lead_nmap("mc", setup_autocompile, "start autocompile", 'markdown')
lead_nmap("mC", stop_autocompile, "stop autocompile", 'markdown')
