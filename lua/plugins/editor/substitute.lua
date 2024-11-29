return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = function()
		local substitute = require("substitute")

		substitute.setup()

		local map = vim.keymap.set

		map("n", "s", substitute.operator, { noremap = true })
		map("n", "ss", substitute.line, { noremap = true })
		map("n", "S", substitute.eol, { noremap = true })
		map("x", "s", substitute.visual, { noremap = true })

		map("n", "sx", require("substitute.exchange").operator, { noremap = true })
		map("n", "sxx", require("substitute.exchange").line, { noremap = true })
		map("x", "X", require("substitute.exchange").visual, { noremap = true })
	end,
}
