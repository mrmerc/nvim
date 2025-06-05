return {
	"tadaa/vimade",
	lazy = false,
	opts = {
		recipe = { "default", { animate = true } },
		fadelevel = 0.4,
		blocklist = {
			default = {
				win_vars = { name = { "Diffview" } },
				buf_opts = { filetype = { "snacks_input" } },
			},
		},
	},
}
