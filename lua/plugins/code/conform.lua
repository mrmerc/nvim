---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		vim.api.nvim_create_user_command("AutoFormatDisable", function(args)
			if args.bang then
				-- AutoFormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("AutoFormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
	config = function()
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,
			notify_on_error = true, -- changed (10.08.25)
			formatters_by_ft = {
				javascript = { "eslint_d", "prettierd", "biome", "biome-organize-imports" },
				typescript = { "eslint_d", "prettierd", "biome", "biome-organize-imports", "injected" },
				typescriptreact = { "eslint_d", "prettierd", "biome", "biome-organize-imports", "injected" },
				vue = { "eslint_d", "prettierd", "stylelint" },
				svelte = { "eslint_d", "prettierd", "stylelint" },
				css = { "stylelint", "prettierd", "biome" },
				scss = { "stylelint", "prettierd", "biome" },
				html = { "prettierd" },
				json = function(bufnr)
					return { "fixjson", first(bufnr, "prettierd", "biome") }
				end,
				jsonc = { "prettierd", "biome" },
				yaml = function(bufnr)
					return { first(bufnr, "yq", "prettierd") }
				end,
				markdown = { "prettierd" },
				lua = { "stylua", lsp_format = "fallback" },
				sql = { "sqlfluff" },
			},
			formatters = {
				injected = { options = { ignore_errors = false } },
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
				sqlfluff = { -- must!
					stdin = false,
					args = { "fix", "--stdin-filename", "$FILENAME" },
				},
			},
			---@type conform.DefaultFormatOpts
			default_format_opts = {
				timeout_ms = 3000,
				lsp_format = "first",
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				---@type conform.FormatOpts
				return {}
			end,
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
