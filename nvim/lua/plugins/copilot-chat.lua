local function toggle()
    require("CopilotChat").toggle()
end

local function reset()
    require("CopilotChat").reset()
end

local function ask()
    vim.ui.input({
        prompt = "Quick Chat: ",
    }, function(input)
        if input ~= "" then
            require("CopilotChat").ask(input)
        end
    end)
end

local function prompt()
    require("CopilotChat").select_prompt()
end

return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "MeanderingProgrammer/render-markdown.nvim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        cmd = "CopilotChat",
        opts = {
            auto_insert_mode = true,
            question_header = string.format(" %s ", vim.env.USER or "user"),
            answer_header = "𐓙 copilot ",
            window = { width = 0.4 },
            model = "claude-3.7-sonnet",
            highlight_headers = false, -- using render-markdown.nvim
        },
        keys = {
            { "<leader>o", "", desc = "Copilot Chat", mode = { "n", "v" } },
            { "<leader>oa", toggle, desc = "Toggle (CopilotChat)", mode = { "n", "v" } },
            { "<leader>ox", reset, desc = "Clear (CopilotChat)", mode = { "n", "v" } },
            { "<leader>oq", ask, desc = "Quick Chat (CopilotChat)", mode = { "n", "v" } },
            { "<leader>op", prompt, desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
        },
    },
}
