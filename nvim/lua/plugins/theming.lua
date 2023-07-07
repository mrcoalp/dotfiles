return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            term_colors = true,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.15,
            },
            integrations = {
                cmp = true,
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                neotree = true,
                noice = true,
                telescope = true,
                notify = true,
                treesitter = true,
                treesitter_context = true,
                mason = true,
                navic = {
                    enabled = false,
                    custom_bg = "NONE",
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                lsp_trouble = true,
            },
        },
    },

    {
        "sainnhe/everforest",
        opts = {},
    },

    {
        "navarasu/onedark.nvim",
        opts = {},
    },

    {
        "EdenEast/nightfox.nvim",
        opts = {},
    },

    {
        "rebelot/kanagawa.nvim",
        opts = {},
    },

    {
        "folke/tokyonight.nvim",
        opts = {},
    },
}
