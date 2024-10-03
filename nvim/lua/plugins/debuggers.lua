return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope.nvim",
            "nvim-telescope/telescope-dap.nvim",
        },
        event = "VeryLazy",
        keys = {
            {
                "<leader>sl",
                function()
                    require("telescope").extensions.dap.configurations({})
                end,
                desc = "[S]earch Debug [L]aunchers",
            },
            {
                "<F5>",
                function()
                    require("dap").continue({})
                end,
                silent = true,
                desc = "Continue debugger",
            },
            {
                "<F10>",
                function()
                    require("dap").step_over()
                end,
                silent = true,
                desc = "Step over instruction",
            },
            {
                "<F11>",
                function()
                    require("dap").step_into()
                end,
                silent = true,
                desc = "Step into instruction",
            },
            {
                "<F12>",
                function()
                    require("dap").step_out()
                end,
                silent = true,
                desc = "Step out instruction",
            },
            {
                "<leader>b",
                function()
                    require("dap").toggle_breakpoint()
                end,
                silent = true,
                desc = "Toggle debugger breakpoint",
            },
            {
                "<leader>B",
                function()
                    require("dap").set_breakpoint(vim.fn.input({ prompt = "Breakpoint condition" }))
                end,
                silent = true,
                desc = "Set debugger conditional breakpoint",
            },
            {
                "<leader>lp",
                function()
                    require("dap").set_breakpoint(nil, nil, vim.fn.input({ prompt = "Log point message" }))
                end,
                silent = true,
                desc = "Set debugger log point message",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                silent = true,
                desc = "Open a REPL debug console",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                silent = true,
                desc = "Re-run last debugger",
            },
            {
                "<leader>dk",
                function()
                    require("dap").up()
                end,
                silent = true,
                desc = "Go up in current stacktrace without stepping.",
            },
            {
                "<leader>dj",
                function()
                    require("dap").down()
                end,
                silent = true,
                desc = "Go down in current stacktrace without stepping.",
            },
        },
        config = function()
            -- Setup icons
            local icons = require("user.icons")

            for name, sign in pairs(icons.dap) do
                local definition = {
                    text = sign[1],
                    texthl = sign[2],
                    linehl = sign[3],
                    numhl = sign[3],
                }

                vim.fn.sign_define(name, definition)
            end

            -- Setup virtual text
            require("nvim-dap-virtual-text").setup({})

            -- Add telescope extension
            require("telescope").load_extension("dap")

            -- Define adapters and configurations
            local dap = require("dap")

            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = "OpenDebugAD7",
            }

            dap.adapters.delve = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }

            dap.adapters.python = {
                type = "executable",
                command = "debugpy-adapter",
            }

            -- Load possible vscode configurations defined in .vscode/launch.json
            require("dap.ext.vscode").load_launchjs()

            local dapui = require("dapui")

            dapui.setup()

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
        end,
    },
}
