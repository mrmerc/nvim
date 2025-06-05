return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
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

		---@diagnostic disable-next-line: missing-fields
		mason_lspconfig.setup({
			ensure_installed = {
				"html",
				"cssls",
				"volar", -- Vue
				"vtsls", -- TS
				"lua_ls",
				"emmet_ls",
				"gopls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"stylua",
				"goimports",
				"gofumpt",
				"eslint_d",
				"prettierd",
				"sqlfluff",
				"stylelint", -- CSS
				"jq", -- JSON
				"fixjson", -- JSON
				"yq", -- YAML
			},
		})
	end,
}
