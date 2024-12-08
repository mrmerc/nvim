return {
	"tadaa/vimade",
	event = "VeryLazy",
	config = function()
		local Fade = require("vimade.style.fade").Fade
		local ease = require("vimade.style.value.ease")
		local animate = require("vimade.style.value.animate")

		require("vimade").setup({
			ncmode = "windows",
			groupscrollbind = true,
			basebg = require("utils.colors").colors.bg,
			style = {
				Fade({
					value = animate.Number({
						start = 1,
						to = 0.3,
						ease = ease.LINEAR,
						duration = 140,
					}),
				}),
			},
			blocklist = {
				default = {
					buf_opts = { buftype = { "prompt", "terminal" } },
					win_config = { relative = true },
					buf_name = { "DiffviewFilePanel" },
					-- buf_vars = { variable = {'match1', 'match2'} },
					-- win_opts = { option = {'match1', 'match2' } },
					-- win_vars = { variable = {'match1', 'match2'} },
				},
			},
		})
	end,
}
