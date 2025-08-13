return {
	"tadaa/vimade",
	lazy = false,
	enabled = false,
	opts = {
		recipe = { "default", { animate = true } },
		fadelevel = 0.4,
		blocklist = {
			default = {
				win_vars = { name = { "Diffview" } },
			},
		},
	},
}
