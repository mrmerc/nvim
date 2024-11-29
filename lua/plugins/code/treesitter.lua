return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
		pcall(require, "nvim-treesitter.query_predicates")
	end,
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"jsdoc",
				"yaml",
				"toml",
				"html",
				"css",
				"scss",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"gitignore",
				"query",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"sql",
				"vue",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
