vim.lsp.enable({
	"bashls",
	"clangd",
	"cmake",
	"jsonls",
	"lua_ls",
	"pyright",
	"ts_ls",
	"yamls",
})

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = true,
	severity_sort = true,
})
