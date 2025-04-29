return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "BufEnter",
	opts = {
		quiet = true,
		enable_cmp_source = false,
		virtual_text = {
			enabled = true,
			manual = false,
			key_bindings = {
				accept = "<M-Tab>",
			},
		},
	},
	config = function(_, options)
		require("codeium").setup(options)
	end,
	keys = {
		{
			"<M-c>",
			function()
				require("codeium.virtual_text").complete()
			end,
			mode = "i",
		},
	},
}
