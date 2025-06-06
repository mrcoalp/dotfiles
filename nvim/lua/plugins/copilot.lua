return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "BufReadPost",
        opts = {
            -- Disable suggestion and panel modules as they can interfere with
            -- completions properly appearing in blink-cmp-copilot
            suggestion = {
                enabled = false,
                auto_trigger = false,
            },
            panel = {
                enabled = false,
            },
            copilot_model = "gpt-4o-copilot",
        },
    },
}
