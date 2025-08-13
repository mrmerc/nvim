return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "BufEnter",
	init = function()
		vim.api.nvim_set_hl(0, "CodeiumSuggestion", { link = "NonText" })
	end,
	opts = {
		quiet = true,
		enable_cmp_source = false,
		virtual_text = {
			enabled = true,
			key_bindings = {
				accept = "<M-Tab>",
				accept_word = "<M-w>",
				accept_line = "<M-l>",
				clear = "<M-c>",
			},
		},
	},
	config = function(_, options)
		require("codeium").setup(options)
	end,
}
