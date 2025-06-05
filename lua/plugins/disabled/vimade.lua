return {
	"tadaa/vimade",
	enabled = false,
	event = "VimEnter",
	config = function()
		require("vimade").setup({
			basebg = require("utils.colors").colors.bg,
			fadelevel = 0.4,
			blocklist = {
				default = {
					buf_opts = {
						filetype = { "DiffviewFiles" },
					},
					win_opts = {
						diff = true,
					},
				},
			},
		})
	end,
}
