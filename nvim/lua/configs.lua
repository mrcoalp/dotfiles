vim.opt.signcolumn = "yes:1" -- Always show sign column
vim.opt.termguicolors = true -- Enable true colors
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.swapfile = false -- Disable swap files
vim.opt.autoindent = true -- Enable auto indentation
vim.opt.tabstop = 4 -- Number of spaces for a tab
vim.opt.shiftwidth = 4 -- Number of spaces for autoindent
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
vim.opt.listchars:append("tab: ") -- tab character
vim.opt.listchars:append("space:⋅") -- space character
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.list = true -- Show whitespace characters
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.wrap = false -- Disable line wrapping
vim.opt.cursorline = true -- Highlight the current line
vim.opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
vim.opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Directory for undo files
vim.opt.undofile = true -- Enable persistent undo
vim.opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
vim.opt.winborder = "rounded" -- Use rounded borders for windows
vim.opt.spell = true -- Enable spell checking
vim.opt.spelllang = { "en" } -- English as spelling language
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation
vim.cmd.colorscheme("tokyonight-storm") -- Set tokyonight as theme
