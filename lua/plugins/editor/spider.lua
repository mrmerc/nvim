return {
	"chrisgrieser/nvim-spider",
	opts = {
		consistentOperatorPending = true,
	},
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-W",
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-E",
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-B",
		},
		{
			"<C-f>",
			"<Esc>l<cmd>lua require('spider').motion('w')<CR>i",
			mode = "i",
			desc = "Spider-W (Insert)",
		},
		{
			"<C-b>",
			"<Esc><cmd>lua require('spider').motion('b')<CR>i",
			mode = "i",
			desc = "Spider-B (Insert)",
		},
	},
}
