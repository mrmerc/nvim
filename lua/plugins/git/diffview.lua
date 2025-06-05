return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", mode = "n", desc = "Open Diffview" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
	},
}
