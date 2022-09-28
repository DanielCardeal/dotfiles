local INSPECT_OPTS = { newline = " ", indent = "" }
local AUTORUN_AUGROUP = 'ClingoAutoRun'
local AUTORUN_OUTPUT_BUFNR = nil
local DEFAULT_CLINGO_OPTS = {
    num_models = 0,
    const_vals = nil, -- or key-value pairs
}

--- Gera o comando para executar o clingo com as opções passadas
local function generate_clingo_command_from_opts(clingo_opts, file)
    local base_command = 'python -m clingo '
    local num_models = clingo_opts.num_models .. " "
    local const_string = ""
    if clingo_opts.const_vals then
        const_string = '--const '
        for k, v in pairs(clingo_opts.const_vals) do
            const_string = string.format(const_string .. "%s=%s ", k, v)
        end
    end
    return base_command .. num_models .. const_string .. file
end

--- Conecta uma sessão de compilação automática com clingo ao arquivo atual
---@param clingo_opts table | nil
local function attach_clingo(clingo_opts)
    clingo_opts = clingo_opts or DEFAULT_CLINGO_OPTS

    -- Cria janela/buffer para output
    local orig_window = vim.api.nvim_get_current_win()

    vim.cmd("vsplit")
    local output_bufnr = vim.api.nvim_create_buf(true, true)
    local output_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(output_win, output_bufnr)
    vim.api.nvim_buf_set_name(output_bufnr, "CLINGO_OUTPUT")
    vim.api.nvim_buf_set_option(output_bufnr, 'readonly', true)

    -- Recupera a posição anterior do cursor
    vim.api.nvim_set_current_win(orig_window)

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup(AUTORUN_AUGROUP, { clear = true }),
        pattern = "*.lp",
        callback = function()
            local append_data = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end
            -- NOTE: escreve o cabeçalho no buffer de saída
            local full_filename = vim.api.nvim_buf_get_name(0)
            local filename = vim.fn.expand("%:t")
            vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, {
                "Running file " .. filename,
                "Num models: " .. clingo_opts.num_models,
                "Constant values:",
                -- TODO: melhorar isso
                (function()
                    if clingo_opts.const_vals then
                        local s = vim.inspect(clingo_opts.const_vals, INSPECT_OPTS)
                        return string.gsub(s, "\n", " ")
                    end
                    return "{}"
                end)(),
                string.rep('-', vim.api.nvim_win_get_width(output_win) - 5)
            })

            local command = generate_clingo_command_from_opts(clingo_opts, full_filename)
            vim.fn.jobstart(command, {
                stdout_buffered = false,
                on_stdout = append_data,
                on_stderr = append_data,
            })

        end,
    })

    -- Atualiza o estado global
    AUTORUN_OUTPUT_BUFNR = output_bufnr
end

-- AUTOCOMMANDS
vim.api.nvim_create_user_command("ClingoStartDefault", function() attach_clingo(nil) end, {})
vim.api.nvim_create_user_command("ClingoStart", function()
    local clingo_opts = {}
    local input = vim.fn.input 'Opções para o clingo: '
    clingo_opts.num_models = string.match(input, "%d+") or 0
    if string.match(input, "%w+=%w+") then
        clingo_opts.const_vals = {}
        for k, v in string.gmatch(input, "(%w+)=(%w+)") do
            clingo_opts.const_vals[k] = v
        end
    end

    attach_clingo(clingo_opts)
end, {})

vim.api.nvim_create_user_command("ClingoStop", function()
    vim.api.nvim_create_augroup(AUTORUN_AUGROUP, { clear = true })
    if AUTORUN_OUTPUT_BUFNR then
        vim.api.nvim_buf_delete(AUTORUN_OUTPUT_BUFNR, {})
        AUTORUN_OUTPUT_BUFNR = nil
    end
end, {})

-- Keymaps
require('nani.utils.ftype_setup').bufEnter("*.lp", function(utils)
    utils.wk.register({
        m = {
            name = 'gringo',
            r = { function() vim.cmd 'ClingoStartDefault' end, "run default clingo" },
            R = { function() vim.cmd 'ClingoStart' end, "run custom clingo" },
            s = { function() vim.cmd 'ClingoStop' end, "stop clingo" },
        }
    }, { prefix = '<leader>', buffer = utils.bufnr })
end)
