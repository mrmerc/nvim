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
			-- "JoosepAlviste/nvim-ts-context-commentstring",
		},
		opts = {
			hooks = {
				-- pre = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			},
		},
	},
}
