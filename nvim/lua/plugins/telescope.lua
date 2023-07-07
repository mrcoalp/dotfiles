local function caller(builtin, opts)
    return function()
        opts = opts or {}
        if builtin == "smart_files" then
            if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
                opts.show_untracked = true
                return require("telescope.builtin")["git_files"](opts)
            end
            return require("telescope.builtin")["find_files"](opts)
        end
        return require("telescope.builtin")[builtin](opts)
    end
end

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
            { "<leader>?", caller("oldfiles"), desc = "[?] Find recently opened files" },
            { "<leader><space>", caller("buffers"), desc = "[ ] Find existing buffers" },
            { "<leader>sf", caller("smart_files"), desc = "[S]earch [F]iles" },
            { "<leader>sh", caller("help_tags"), desc = "[S]earch [H]elp" },
            { "<leader>sw", caller("grep_string"), desc = "[S]earch current [W]ord" },
            { "<leader>sg", caller("live_grep"), desc = "[S]earch by [G]rep" },
            { "<leader>sd", caller("diagnostics"), desc = "[S]earch [D]iagnostics" },
            { "<leader>sy", caller("lsp_document_symbols"), desc = "[S]earch Document S[y]mbols" },
            { "<leader>sk", caller("keymaps"), desc = "[S]earch [K]eymaps" },
            { "<leader>sc", caller("git_commits"), desc = "[S]earch [C]ommits" },
            { "<leader>sb", caller("git_bcommits"), desc = "[S]earch [B]uffer Commits" },
            {
                "<leader>ss",
                caller("colorscheme", { enable_preview = true }),
                desc = "[S]earch Color[s]cheme",
            },
            {
                "<leader>/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end,
                desc = "[/] Fuzzily search in current buffer]",
            },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        ["<a-i>"] = caller("find_files", { no_ignore = true }),
                        ["<a-h>"] = caller("find_files", { hidden = true }),
                        ["<C-Down>"] = "cycle_history_next",
                        ["<C-Up>"] = "cycle_history_prev",
                        ["<C-k>"] = "move_selection_previous",
                        ["<C-j>"] = "move_selection_next",
                        ["<C-h>"] = "which_key",
                        ["<esc>"] = "close",
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--no-fixed-strings",
                    "--trim",
                },
            },
            extensions = {
                media_files = {
                    find_cmd = "rg",
                },
            },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("fzf")
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = vim.fn.executable("cmake") == 1,
    },
}
