return {
	-- Text objects
	{
		"echasnovski/mini.ai",
		version = "*",
		config = function()
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				custom_textobjects = {
					A = spec_treesitter({ a = "@attribute.outer", i = "@attribute.inner" }),
				},
			})
		end,
	},
	{
		"echasnovski/mini.comment",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local commentstring = require("ts_context_commentstring")

			commentstring.setup({
				enable_autocmd = false,
			})

			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return commentstring.calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
		end,
	},
}
