return {
    {
        "norcalli/nvim-colorizer.lua",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            "css",
            "javascript",
        },
    },
}
