return {
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.highlight, desc = "Highlight surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            return vim.list_extend(mappings, keys, 1, #keys)
        end,
        opts = {
            mappings = {
                add = "gza", -- Add surrounding in Normal and Visual modes
                delete = "gzd", -- Delete surrounding
                find = "gzf", -- Find surrounding (to the right)
                find_left = "gzF", -- Find surrounding (to the left)
                highlight = "gzh", -- Highlight surrounding
                replace = "gzr", -- Replace surrounding
                update_n_lines = "gzn", -- Update `n_lines`
            },
        },
        config = function(_, opts)
            -- use gz mappings instead of s to prevent conflict with leap
            require("mini.surround").setup(opts)
        end,
    },

    {
        "mistricky/codesnap.nvim",
        build = "make",
        cmd = { "CodeSnap", "CodeSnapSave" },
        keys = {
            {
                "<leader>cc",
                mode = { "x" },
                "<cmd>CodeSnap<cr>",
                desc = "Save selected code snapshot into clipboard",
            },
            {
                "<leader>cs",
                mode = { "x" },
                "<cmd>CodeSnapSave<cr>",
                desc = "Save selected code snapshot in ~/Pictures",
            },
        },
        opts = {
            title = "",
            watermark = "",
            has_breadcrumbs = true,
            has_line_number = true,
            bg_theme = "bamboo",
        },
    },
}
