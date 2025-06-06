local function oldfiles()
    local builtin = require("telescope.builtin")
    return builtin.oldfiles()
end

local function buffers()
    local builtin = require("telescope.builtin")
    return builtin.buffers({ sort_mru = true, sort_lastused = true })
end

local function smart_files()
    local builtin = require("telescope.builtin")
    if vim.uv.fs_stat(vim.uv.cwd() .. "/.git") then
        return builtin.git_files({ show_untracked = true })
    end
    return builtin.find_files()
end

local function help_tags()
    local builtin = require("telescope.builtin")
    return builtin.help_tags()
end

local function grep_string()
    local builtin = require("telescope.builtin")
    return builtin.grep_string()
end

local function live_grep()
    local builtin = require("telescope.builtin")
    return builtin.live_grep()
end

local function diagnostics()
    local builtin = require("telescope.builtin")
    return builtin.diagnostics({ bufnr = 0 })
end

local function lsp_document_symbols()
    local builtin = require("telescope.builtin")
    return builtin.lsp_document_symbols()
end

local function keymaps()
    local builtin = require("telescope.builtin")
    return builtin.keymaps()
end

local function git_commits()
    local builtin = require("telescope.builtin")
    return builtin.git_commits()
end

local function git_bcommits()
    local builtin = require("telescope.builtin")
    return builtin.git_bcommits()
end

local function git_status()
    local builtin = require("telescope.builtin")
    return builtin.git_status()
end

local function colorscheme()
    local builtin = require("telescope.builtin")
    return builtin.colorscheme({ enable_preview = true })
end

local function current_buffer_fuzzy_find()
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end

local function ff_no_ignore()
    local builtin = require("telescope.builtin")
    return builtin.find_files({ no_ignore = true })
end

local function ff_hidden()
    local builtin = require("telescope.builtin")
    return builtin.find_files({ hidden = true })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-tree/nvim-web-devicons" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                cond = vim.fn.executable("cmake") == 1,
            },
        },
        keys = {
            { "<leader>?", oldfiles, desc = "[?] Find recently opened files" },
            { "<leader><space>", buffers, desc = "[ ] Find existing buffers" },
            { "<leader>sf", smart_files, desc = "[S]earch [F]iles" },
            { "<leader>sh", help_tags, desc = "[S]earch [H]elp" },
            { "<leader>sw", grep_string, desc = "[S]earch current [W]ord" },
            { "<leader>sg", live_grep, desc = "[S]earch by [G]rep" },
            { "<leader>sd", diagnostics, desc = "[S]earch [D]iagnostics" },
            { "<leader>sy", lsp_document_symbols, desc = "[S]earch Document S[y]mbols" },
            { "<leader>sk", keymaps, desc = "[S]earch [K]eymaps" },
            { "<leader>sc", git_commits, desc = "[S]earch [C]ommits" },
            { "<leader>sb", git_bcommits, desc = "[S]earch [B]uffer Commits" },
            { "<leader>ss", git_status, desc = "[S]earch Git [S]tatus" },
            { "<leader>sC", colorscheme, desc = "[S]earch Color[s]cheme" },
            { "<leader>/", current_buffer_fuzzy_find, desc = "[/] Fuzzily search in current buffer]" },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        ["<a-i>"] = ff_no_ignore,
                        ["<a-h>"] = ff_hidden,
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
}
