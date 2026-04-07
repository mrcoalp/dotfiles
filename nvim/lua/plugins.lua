-- tokyonight ------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
})

require("tokyonight").setup()

-- mason -----------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup()

-- lspconfig -------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

-- illuminate ------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/RRethy/vim-illuminate" },
})

-- mini ------------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },
})

require("mini.icons").setup()
require("mini.pairs").setup()

-- fzf -------------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

local fzf_actions = require("fzf-lua.actions")

require("fzf-lua").setup({
	winopts = { backdrop = 85 },
	keymap = {
		builtin = {
			["<C-f>"] = "preview-page-down",
			["<C-b>"] = "preview-page-up",
			["<C-p>"] = "toggle-preview",
		},
		fzf = {
			["ctrl-a"] = "toggle-all",
			["ctrl-t"] = "first",
			["ctrl-g"] = "last",
			["ctrl-d"] = "half-page-down",
			["ctrl-u"] = "half-page-up",
		},
	},
	actions = {
		files = {
			["ctrl-q"] = fzf_actions.file_sel_to_qf,
			["ctrl-n"] = fzf_actions.toggle_ignore,
			["ctrl-h"] = fzf_actions.toggle_hidden,
			["enter"] = fzf_actions.file_edit_or_qf,
		},
	},
})

require("fzf-lua").register_ui_select()

-- oil -------------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup()

-- tmux-navigator --------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
})

-- blink-cmp -------------------------------------------------------------------

vim.pack.add({
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	cmdline = {
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
})

-- lazygit ---------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
})

-- fidget ----------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})

-- dap -------------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup() -- should be enough to setup all things

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "OpenDebugAD7",
}

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

local dap_icons = {
	DapStopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
	DapBreakpoint = { " ", "DiagnosticInfo", nil },
	DapBreakpointCondition = { " ", "DiagnosticInfo", nil },
	DapBreakpointRejected = { " ", "DiagnosticError", nil },
	DapLogPoint = { ".>", "DiagnosticInfo", nil },
}

for name, sign in pairs(dap_icons) do
	vim.fn.sign_define(name, {
		text = sign[1],
		texthl = sign[2],
		linehl = sign[3],
		numhl = sign[3],
	})
end

-- conform ---------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		cmake = { "cmake_format" },
		css = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
		python = { "black" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		sh = { "shfmt" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		yaml = { "prettierd" },
	},
})

-- gitsigns --------------------------------------------------------------------

vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
	current_line_blame = true,
})
