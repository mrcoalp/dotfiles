-- Custom searches ---------------------------------------------------------------------------------
vim.api.nvim_create_user_command("SearchFiles", function(opts)
    require("telescope.builtin").find_files({
        cwd = opts.args,
        prompt_title = "[" .. opts.args .. "] Search Files",
    })
end, { nargs = "?", bang = true })

vim.api.nvim_create_user_command("SearchGrep", function(opts)
    require("telescope.builtin").live_grep({
        cwd = opts.args,
        prompt_title = "[" .. opts.args .. "] Search Grep",
    })
end, { nargs = "?", bang = true })
