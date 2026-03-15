vim.g.mapleader = " "

vim.keymap.set("n", "<space>", "<Nop>")
vim.keymap.set("n", "<leader>ps", "<cmd>lua vim.pack.update()<cr>")

-- Move down, but use 'gj' if no count is given
vim.keymap.set("n", "j", function()
	return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "j" or "gj"
end, { expr = true, silent = true })
-- Move up, but use 'gk' if no count is given
vim.keymap.set("n", "k", function()
	return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "k" or "gk"
end, { expr = true, silent = true })

-- Scroll down and center the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- Scroll up and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- LSP related keybinds
vim.keymap.set("n", "<leader>fo", ":lua vim.lsp.buf.format()<cr>", { silent = true })
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", { silent = true })
vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", { silent = true })

-- Paste without overwriting the default register
vim.keymap.set("v", "<leader>p", '"_dP')
-- Yank to the system clipboard in visual mode
vim.keymap.set("x", "y", [["+y]], { silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==")
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==")
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi")
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv")

-- fzf-lua keymaps
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua lgrep_curbuf<cr>")
vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>")
vim.keymap.set("n", "<leader>sd", "<cmd>FzfLua lsp_document_diagnostics<cr>")
vim.keymap.set("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>")
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>")
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_blame<cr>")
vim.keymap.set("n", "<leader>gd", "<cmd>FzfLua git_diff<cr>")
vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_bcommits<cr>")
vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { noremap = true, silent = true })

-- oil keymaps
vim.keymap.set("n", "-", "<cmd>Oil<cr>")

-- lazygit keymaps
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>")

-- dap
vim.keymap.set("n", "<leader>b", "<cmd>DapToggleBreakpoint<cr>")
vim.keymap.set("n", "<F5>", "<cmd>DapContinue<cr>")

-- conform
vim.keymap.set("n", "<leader>f", function()
	local conform = require("conform")
	conform.format({ async = true, lsp_fallback = true })
end, { silent = true })
