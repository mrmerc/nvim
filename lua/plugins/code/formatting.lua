return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "eslint_d", "prettierd" },
				typescript = { "eslint_d", "prettierd" },
				vue = { "eslint_d", "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				gotmpl = { "prettierd" },
				sql = { "sqlfluff" },
			},
			formatters = {
				sqlfluff = {
					stdin = false,
					args = { "fix", "--stdin-filename", "$FILENAME" },
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1000,
			},
		})
	end,
}
