return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- add any opts here
        -- mode = 'legacy',
        -- this file can contain specific instructions for your project
        behavior = {
            auto_approve_tool_permissions = false,
        },
        instructions_file = "avante.md",
        input = {
            provider = "native", -- Uses vim.ui.input
            provider_opts = {},
        },
        -- auto_suggestions_provider = 'copilot',
        -- for example
        provider = "codex",
        acp_providers = {
            ["claude-code"] = {
                command = "npx",
                args = { "@zed-industries/claude-code-acp" },
                env = {
                    NODE_NO_WARNINGS = "1",
                    ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
                },
            },
            ["codex"] = {
                command = "npx",
                args = { "@zed-industries/codex-acp", "-c", "model='gpt-5.3-codex'" },
                env = {
                    NODE_NO_WARNINGS = "1",
                    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
                },
            },
        },
        providers = {
            copilot = {
                model = "gpt-4o",
            },
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude--4-5-20251001",
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 512,
                },
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "stevearc/dressing.nvim",        -- for input provider dressing
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
