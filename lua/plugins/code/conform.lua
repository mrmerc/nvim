return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,
			notify_on_error = false,
			formatters_by_ft = {
				javascript = { "eslint_d", "prettierd", "biome", "biome-organize-imports" },
				typescript = { "eslint_d", "prettierd", "biome", "biome-organize-imports", "injected" },
				vue = { "eslint_d", "prettierd", "stylelint" },
				svelte = { "eslint_d", "prettierd", "stylelint" },
				css = { "stylelint", "prettierd", "biome" },
				scss = { "stylelint", "prettierd", "biome" },
				html = { "prettierd" },
				json = { "fixjson", "prettierd", "biome" },
				jsonc = { "prettierd", "biome" },
				yaml = { --[["yq",]]
					"prettierd",
				},
				markdown = { "prettierd" },
				lua = { "stylua", lsp_format = "fallback" },
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
				eslint_d = {
					require_cwd = true,
					cwd = require("conform.util").root_file({ "eslint.config.js" }),
				},
				stylelint = {
					require_cwd = true,
				},
				biome = {
					require_cwd = true,
				},
				["biome-organize-imports"] = {
					require_cwd = true,
				},
				sqlfluff = {
					stdin = false,
					args = { "fix", "--stdin-filename", "$FILENAME" },
				},
			},
			---@type conform.DefaultFormatOpts
			default_format_opts = {
				timeout_ms = 3000,
				lsp_format = "first",
			},
			---@type conform.FormatOpts
			format_on_save = {}, -- enables format on save
		})
	end,
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" } })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
}
