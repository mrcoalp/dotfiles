return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<c-space>", desc = "Increment selection" },
            { "<bs>", desc = "Shrink selection", mode = "x" },
        },
        opts = {
            highlight = { enable = false },
            indent = { enable = false },
            context_commentstring = { enable = true, enable_autocmd = false },
            ensure_installed = "all",
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
                    d = { "%f[%d]%d+" }, -- digits
                    e = { -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    i = function(ai_type)
                        local spaces = (" "):rep(vim.o.tabstop)
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        local indents = {} ---@type {line: number, indent: number, text: string}[]

                        for l, line in ipairs(lines) do
                            if not line:find("^%s*$") then
                                indents[#indents + 1] =
                                    { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
                            end
                        end

                        local ret = {} ---@type (Mini.ai.region | {indent: number})[]

                        for i = 1, #indents do
                            if i == 1 or indents[i - 1].indent < indents[i].indent then
                                local from, to = i, i
                                for j = i + 1, #indents do
                                    if indents[j].indent < indents[i].indent then
                                        break
                                    end
                                    to = j
                                end
                                from = ai_type == "a" and from > 1 and from - 1 or from
                                to = ai_type == "a" and to < #indents and to + 1 or to
                                ret[#ret + 1] = {
                                    indent = indents[i].indent,
                                    from = {
                                        line = indents[from].line,
                                        col = ai_type == "a" and 1 or indents[from].indent + 1,
                                    },
                                    to = { line = indents[to].line, col = #indents[to].text },
                                }
                            end
                        end

                        return ret
                    end, -- indent
                    g = function(ai_type)
                        local start_line, end_line = 1, vim.fn.line("$")
                        if ai_type == "i" then
                            -- Skip first and last blank lines for `i` textobject
                            local first_nonblank, last_nonblank =
                                vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
                            -- Do nothing for buffer with all blanks
                            if first_nonblank == 0 or last_nonblank == 0 then
                                return { from = { line = start_line, col = 1 } }
                            end
                            start_line, end_line = first_nonblank, last_nonblank
                        end

                        local to_col = math.max(vim.fn.getline(end_line):len(), 1)
                        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
                    end, -- buffer
                    u = ai.gen_spec.function_call(), -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
        end,
    },
}
