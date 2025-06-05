return {
	"folke/zen-mode.nvim",
	opts = {
		window = {
			backdrop = 0.5, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			-- a percentage of the width / height of the editors
			width = 0.65, -- width of the Zen window
			height = 1, -- height of the Zen window
		},
		plugins = {
			wezterm = {
				enabled = false,
				-- can be either an absolute font size or the number of incremental steps
				font = "+1", -- (10% increase per step)
			},
		},
	},
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
}
