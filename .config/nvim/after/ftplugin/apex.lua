vim.opt_local.shiftwidth = 2
local commnetFt = require("Comment.ft")
commnetFt.apex = {
	"// %s",
}
-- require('lspconfig').apex_ls.setup {
--     -- cmd = { "java", "-jar", os.getenv("HOME") .. "/.local/share/nvim/mason/share/apex-language-server/apex-jorje-lsp.jar" },
--     -- filetypes = { "apex" },
--     -- root_dir = require('lspconfig').util.root_pattern("sfdx-project.json"),
--     -- settings = {
--     --     jorje = {
--     --         workspace = {
--     --             type = "sfdx",
--     --             apex = {
--     --                 enabled = true,
--     --                 classpath = "force-app/main/default/classes",
--     --                 testClasspath = "force-app/main/default/classes",
--     --                 testCodeCoverage = true,
--     --                 testCodeCoverageFail = 75,
--     --                 testCodeCoverageWarn = 85,
--     --                 testLevel = "RunLocalTests",
--     --                 testMethodPrefix = "test",
--     --                 testMethodRegex = "^(test|@isTest)"
--     --             }
--     --         }
--     --     }
--     -- }
--     apex_jar_path = os.getenv("HOME") .. "/.local/share/nvim/mason/share/apex-language-server/apex-jorje-lsp.jar",
--     apex_enable_sematic_errors = true,
--     apex_enable_completion_statistics = true,
--     root_dir = require('lspconfig').util.root_pattern("sfdx-project.json"),
-- }
