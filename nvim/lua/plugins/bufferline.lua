return {
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        opts = {
            options = {
                -- separator_style = "slant",
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                diagnostics_indicator = function(_, _, diag)
                    local icons = require("user.icons").diagnostics
                    local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                        .. (diag.warning and icons.Warn .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
                groups = {
                    options = {
                        toggle_hidden_on_enter = true,
                    },
                    items = {
                        {
                            name = "Tests",
                            icon = "",
                            auto_close = true,
                            matcher = function(buf)
                                return buf.name:match("%_test")
                                    or buf.name:match("%_spec")
                                    or buf.name:match("%.test")
                                    or buf.name:match("%.spec")
                            end,
                        },
                        {
                            name = "Docs",
                            icon = "",
                            auto_close = true,
                            matcher = function(buf)
                                return buf.name:match("%.md")
                            end,
                        },
                    },
                },
            },
        },
    },
}
