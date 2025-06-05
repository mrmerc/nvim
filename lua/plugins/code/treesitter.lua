return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	-- NOTE: do not change to opts, configuration done via nvim-treesitter.configs
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		---@diagnostic disable-next-line: missing-fields
		treesitter.setup({
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1024 * 1024 -- 1 MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = { enable = true },
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
				"svelte",
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
