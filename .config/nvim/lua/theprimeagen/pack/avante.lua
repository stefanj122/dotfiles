require("avante").setup({
    behavior = {
        auto_approve_tool_permissions = false,
    },
    instructions_file = "avante.md",
    input = {
        provider = "native",
        provider_opts = {},
    },
    provider = "codex",
    acp_providers = {
        ["claude-code"] = {
            command = "npx",
            args = { "@zed-industries/claude-code-acp" },
            env = {
                NODE_NO_WARNINGS = "1",
                ANTHROPIC_API_KEY = vim.env.ANTHROPIC_API_KEY,
            },
        },
        ["codex"] = {
            command = "npx",
            args = { "@zed-industries/codex-acp", "-c", "model='gpt-5.5'" },
            env = {
                NODE_NO_WARNINGS = "1",
                OPENAI_API_KEY = vim.env.OPENAI_API_KEY,
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
            timeout = 30000,
            extra_request_body = {
                temperature = 0.75,
                max_tokens = 512,
            },
        },
    },
})
