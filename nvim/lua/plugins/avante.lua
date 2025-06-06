return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false,
        opts = {
            file_selector = {
                provider = "telescope",
                provider_opts = {},
            },
            providers = {
                copilot_claude = {
                    __inherited_from = "copilot",
                    model = "claude-3.7-sonnet",
                },
                copilot_claude_thought = {
                    __inherited_from = "copilot",
                    model = "claude-3.7-sonnet-thought",
                    extra_request_body = {
                        temperature = 1,
                        max_tokens = 20000,
                    },
                },
                copilot_openai = {
                    __inherited_from = "copilot",
                    model = "gpt-4o",
                },
                copilot_gemini = {
                    __inherited_from = "copilot",
                    model = "gemini-2.0-flash-001",
                },
            },
            provider = "copilot_claude",
            auto_suggestions_provider = "copilot_claude",
            behaviour = {
                auto_suggestions = false,
            },
        },
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "saghen/blink.cmp", -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            "MeanderingProgrammer/render-markdown.nvim", -- for rendering markdown

            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
        keys = {
            {
                "<leader>ap",
                "<cmd>AvanteChat<cr>",
                desc = "avante: chat",
            },
        },
    },
}
