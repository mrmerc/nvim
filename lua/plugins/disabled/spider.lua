return {
	"chrisgrieser/nvim-spider",
	enabled = false,
	lazy = true,
	opts = {},
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-W",
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-B",
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-E",
		},
		{
			"ge",
			"<cmd>lua require('spider').motion('ge')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-GE",
		},
	},
}
