local function blame()
    local gitsigns = require("gitsigns")
    gitsigns.blame()
end

local function blame_line()
    local gitsigns = require("gitsigns")
    gitsigns.blame_line({ full = true })
end

local function diffthis()
    local gitsigns = require("gitsigns")
    gitsigns.diffthis()
end

local function diffthis_tilde()
    local gitsigns = require("gitsigns")
    gitsigns.diffthis("~")
end

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            current_line_blame = true,
        },
        keys = {
            { "<leader>gb", blame, desc = "[G]it [B]lame" },
            { "<leader>gl", blame_line, desc = "[G]it [L]ine Blame" },
            { "<leader>gd", diffthis, desc = "[G]it [D]iff" },
            { "<leader>gD", diffthis_tilde, desc = "[G]it [D]iff This" },
        },
    },
}
