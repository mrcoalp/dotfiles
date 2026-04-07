vim.lsp.enable({
	"bashls",
	"clangd",
	"neocmake",
	"jsonls",
	"lua_ls",
	"pyright",
	"ts_ls",
	"yamls",
})

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
})
