local function create_augroup(name)
	return vim.api.nvim_create_augroup("NotEmacs" .. name, {
		clear = true,
	})
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 170 })
	end,
	group = create_augroup("EditorConfigs"),
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "tabdo wincmd =",
	group = create_augroup("LayoutHandling"),
})

-- Disable LSP syntax highlight
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		client.server_capabilities.semanticTokensProvider = nil
	end,
	group = create_augroup("LspSettings"),
})
