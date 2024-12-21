return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "BufEnter",
	opts = {
		enable_cmp_source = false,
		virtual_text = {
			enabled = true,
			manual = false,
			key_bindings = {
				accept = "<M-Tab>",
			},
		},
	},
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
