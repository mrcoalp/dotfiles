local function search_replace()
    local grug = require("grug-far")

    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    local opts = {
        transient = true,
        prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
    }

    grug.open(opts)
end

return {
    {
        "MagicDuck/grug-far.nvim",
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            { "<leader>sr", search_replace, mode = { "n", "v" }, desc = "[S]earch and [R]eplace" },
        },
    },
}
