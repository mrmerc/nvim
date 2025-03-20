return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		log_level = vim.log.levels.DEBUG,
		notify_on_error = false,
		formatters_by_ft = {
			javascript = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d", "injected" },
			vue = { "prettierd", "eslint_d", "stylelint" },
			css = { "stylelint", "prettierd" },
			scss = { "stylelint", "prettierd" },
			html = { "prettierd" },
			json = { "fixjson", "prettierd" },
			yaml = { --[["yq",]]
				"prettierd",
			},
			markdown = { "prettierd" },
			lua = { "stylua" },
			go = { "goimports", "gofumpt" },
			gotmpl = { "prettierd" },
			sql = { "sqlfluff" },
		},
		formatters = {
			injected = { options = { ignore_errors = true } },
			prettierd = {
				require_cwd = true,
				env = {
					PRETTIERD_LOCAL_PRETTIER_ONLY = "1",
					PRETTIERD_DEFAULT_CONFIG = string.format(
						"%s/.config/prettier/prettier.config.mjs",
						os.getenv("HOME")
					),
				},
			},
			sqlfluff = {
				stdin = false,
				args = { "fix", "--stdin-filename", "$FILENAME" },
			},
		},
		default_format_opts = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 3000,
		},
	},
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
}
