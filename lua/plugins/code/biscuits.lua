return {
	"code-biscuits/nvim-biscuits",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	init = function()
		vim.api.nvim_set_hl(0, "BiscuitColor", { link = "NonText" })
	end,
	opts = {
		show_on_start = true,
		cursor_line_only = true,
		max_file_size = "80kb",
		prefix_string = " 📎 ",
	},
}
