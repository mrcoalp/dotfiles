return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "Kaiser-Yang/blink-cmp-avante",
            "giuxtaposition/blink-cmp-copilot",
        },
        version = "*",
        event = "InsertEnter",
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
            sources = {
                default = { "lsp", "path", "buffer", "avante", "copilot" },
                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {
                            -- options for blink-cmp-avante
                        },
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
}
