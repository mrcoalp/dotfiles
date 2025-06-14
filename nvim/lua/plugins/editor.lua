return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            direction = "float",
            float_opts = {
                border = "curved",
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            function _G.set_terminal_keymaps()
                local opts_ = { buffer = 0 }
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts_)
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts_)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts_)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts_)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts_)
            end

            vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
        end,
        cmd = {
            "ToggleTerm",
            "ToggleTermToggleAll",
            "TermExec",
            "TermSelect",
            "ToggleTermSetName",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
            "ToggleTermSendCurrentLine",
        },
        keys = {
            { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle [T]erminal" },
        },
    },

    {
        "echasnovski/mini.indentscope",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
            require("mini.indentscope").setup(opts)
        end,
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },

    {
        "jeffkreeftmeijer/vim-numbertoggle",
        event = { "BufReadPre", "BufNewFile" },
    },

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
    },

    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = { delay = 200 },
        config = function(_, opts)
            require("illuminate").configure(opts)
        end,
        keys = {
            {
                "<A-n>",
                function()
                    require("illuminate").goto_next_reference(false)
                end,
                desc = "[N]ext Reference",
            },
            {
                "<A-p>",
                function()
                    require("illuminate").goto_prev_reference(false)
                end,
                desc = "[P]rev Reference",
            },
        },
    },

    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    {
        "luukvbaal/statuscol.nvim",
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                relculright = true,
                segments = {
                    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                },
            })
        end,
    },

    {
        "kevinhwang91/nvim-ufo",
        event = { "BufReadPost" },
        dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
        init = function()
            vim.opt.foldcolumn = "1"
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            vim.opt.foldenable = true
            vim.opt.fillchars = {
                diff = "/",
                eob = " ",
                fold = " ",
                foldopen = "",
                foldclose = "",
                foldsep = " ",
            }
        end,
        opts = {
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
        },
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close all folds",
            },
        },
    },

    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {},
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]odo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "[S]earch [T]odo/Fix/Fixme" },
        },
    },
}
