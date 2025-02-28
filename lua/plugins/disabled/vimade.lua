return {
	"tadaa/vimade",
	enabled = false,
	event = "VimEnter",
	config = function()
		require("vimade").setup({
			-- ncmode = "windows",
			-- groupscrollbind = true,
			basebg = require("utils.colors").colors.bg,
			fadelevel = 0.4,
		})
	end,
}
