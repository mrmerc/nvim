return {
	"tanvirtin/vgit.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
	-- Lazy loading on 'VimEnter' event is necessary.
	event = "VimEnter",
	enabled = false,
	opts = {
		keymaps = {
			["n ]h"] = "hunk_down",
			["n [h"] = "hunk_up",
			["n <leader>ghr"] = "buffer_hunk_reset",
			["n <leader>ghp"] = "buffer_hunk_preview",
			["n <leader>gph"] = "buffer_history_preview",
			["n <leader>gd"] = "project_diff_preview",
			["n <leader>gl"] = "project_logs_preview",
			["n <leader>gx"] = "toggle_diff_preference",
		},
		settings = {
			live_blame = {
				enabled = false,
			},
			live_gutter = {
				enabled = true,
				edge_navigation = false, -- This allows users to navigate within a hunk
			},
			signs = {
				priority = 1,
				definitions = {
					GitSignsAdd = {
						text = "▎",
					},
					GitSignsChange = {
						text = "▎",
					},
					GitSignsDelete = {
						text = "▎",
					},
				},
			},
		},
	},
}
