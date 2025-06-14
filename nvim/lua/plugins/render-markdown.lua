return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
            checkbox = {
                enabled = false,
            },
            file_types = { "markdown", "Avante", "copilot-chat" },
        },
        ft = { "markdown", "Avante", "copilot-chat" },
    },
}
