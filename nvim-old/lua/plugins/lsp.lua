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

    local tele = require("telescope.builtin")
    nmap("gd", tele.lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", tele.lsp_references, "[G]oto [R]eferences")
    nmap("gI", tele.lsp_implementations, "[G]oto [I]mplementation")
    nmap("gt", tele.lsp_type_definitions, "[G]oto [T]ype Definition")
    nmap("<leader>ds", tele.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", tele.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        local folders = vim.lsp.buf.list_workspace_folders()
        print(vim.inspect(folders))
    end, "[W]orkspace [L]ist Folders")
end

local format = function()
    require("conform").format({ async = true, lsp_fallback = true })
end

return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    { "Bilal2453/luvit-meta", lazy = true },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
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
                ts_ls = {},
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
            vim.diagnostic.config(opts.diagnostics)

            local icons = require("user.icons")

            for name, icon in pairs(icons.diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end

            local blink = require("blink.cmp")

            local capabilities = blink.get_lsp_capabilities({
                offsetEncoding = {
                    "utf-16",
                },
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
                semanticTokensProvider = nil,
            })

            -- Ensure the servers above are installed
            local mlsp = require("mason-lspconfig")
            local install = vim.tbl_keys(opts.servers)

            mlsp.setup({
                ensure_installed = install,
                automatic_enable = true,
            })

            local installed = mlsp.get_installed_servers()

            for _, server in ipairs(installed) do
                vim.lsp.config(server, {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = opts.servers[server],
                })
            end
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

            local registry = require("mason-registry")

            for _, tool in ipairs(opts.ensure_installed) do
                local pkg = registry.get_package(tool)

                if not pkg:is_installed() then
                    pkg:install()
                end
            end
        end,
    },
}
