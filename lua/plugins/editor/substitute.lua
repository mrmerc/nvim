return {
	"gbprod/substitute.nvim",
	dependencies = { "gbprod/yanky.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("substitute").setup({
			preserve_cursor_position = true,
			on_substitute = require("yanky.integration").substitute(),
		})
	end,
	keys = {
		{
			"s",
			function()
				require("substitute").operator()
			end,
		},
		{
			"ss",
			function()
				require("substitute").line()
			end,
		},
		{
			"S",
			function()
				require("substitute").eol()
			end,
		},
		{
			"s",
			function()
				require("substitute").visual()
			end,
			mode = "x",
		},
	},
}
