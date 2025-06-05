return {
	"tadaa/vimade",
	enabled = false,
	version = "v2.1.2",
	event = "VeryLazy",
	config = function()
		-- local Fade = require("vimade.style.fade").Fade
		-- local ease = require("vimade.style.value.ease")
		-- local animate = require("vimade.style.value.animate")

		require("vimade").setup({
			ncmode = "windows",
			groupscrollbind = true,
			basebg = require("utils.colors").colors.bg,
			fadelevel = 0.3, -- no animation
			-- style = {
			-- 	Fade({
			-- 		value = animate.Number({
			-- 			start = 1,
			-- 			to = 0.3,
			-- 			ease = ease.LINEAR,
			-- 			duration = 150,
			-- 		}),
			-- 	}),
			-- },
			-- blocklist = {
			-- 	default = {
			-- 		buf_opts = { buftype = { "prompt", "terminal", "popup" } },
			-- 		win_config = { relative = true },
			-- 	},
			-- },
		})
	end,
}
