return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	enabled = false,
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
	opts = {
		flavour = "mocha",
		transparent_background = true, -- disables setting the background color.
		term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
		dim_inactive = {
			enabled = false, -- dims the background color of inactive window
			shade = "dark",
			percentage = 0.5, -- percentage of the shade to apply to the inactive window
		},
		no_italic = false, -- Force no italic
		no_underline = false, -- Force no underline
		color_overrides = {},
		custom_highlights = {},
		default_integrations = true,
		integrations = {
			blink_cmp = true,
			mason = true,
			snacks = {
				enabled = true,
			},
		},
	},
}
