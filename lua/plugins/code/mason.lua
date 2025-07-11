return {
	"mason-org/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- LSP
				"html-lsp",
				"css-lsp",
				"vue-language-server",
				"vtsls",
				"svelte-language-server",
				"lua-language-server",
				"emmet-ls",
				"json-lsp",

				-- TOOLS
				"stylua",
				"eslint_d",
				"prettierd",
				"sqlfluff",
				"jq", -- JSON
				"fixjson", -- JSON
				"yq", -- YAML
			},
		})
	end,
}
