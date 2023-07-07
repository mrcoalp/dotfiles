local on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil

    local map = function(mode, keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end
    local nmap = function(...)
        return map("n", ...)
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", "<cmd>Telescope lsp_definitions<cr>", "[G]oto [D]efinition")
    nmap("gr", "<cmd>Telescope lsp_references<cr>", "[G]oto [R]eferences")
    nmap("gI", "<cmd>Telescope lsp_implementations<cr>", "[G]oto [I]mplementation")
    nmap("gt", "<cmd>Telescope lsp_type_definitions<cr>", "[G]oto [T]ype Definition")
    nmap("<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", "[D]ocument [S]ymbols")
    nmap("<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
end

local format = function()
    require("conform").format({ async = true, lsp_fallback = true })
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            },
            servers = {
                bashls = {},
                pyright = {},
                yamlls = {},
                eslint = {},
                tsserver = {},
                jsonls = {},
                cmake = {},
                clangd = {},
                dockerls = {},
                gopls = {},
                rust_analyzer = {},
                lua_ls = {
                    Lua = {
                        diagnostics = { disable = { "lowercase-global" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
                marksman = {},
            },
        },
        config = function(_, opts)
            for name, icon in pairs(require("user.icons").diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            -- Setup neovim lua configuration
            require("neodev").setup()
            --
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            capabilities.offsetEncoding = {
                "utf-16",
            }

            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

            -- Setup mason so it can manage external tooling
            require("mason").setup()

            -- Ensure the servers above are installed
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(opts.servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = opts.servers[server_name],
                    })
                end,
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                css = { "prettierd" },
                html = { "prettierd" },
                json = { "prettierd" },
                lua = { "stylua" },
                markdown = { "prettierd" },
                python = { "isort", "autopep8" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                sh = { "shfmt" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                yaml = { "prettierd" },
            },
        },
        keys = {
            { "<leader>f", format, desc = "[F]ormat Buffer" },
        },
    },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = {
                -- Formatter
                "autopep8",
                "cmakelang",
                "isort",
                "prettierd",
                "shfmt",
                "stylua",
                -- Linter
                "shellcheck",
                -- DAP
                "cpptools",
                "debugpy",
                "delve",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
}
