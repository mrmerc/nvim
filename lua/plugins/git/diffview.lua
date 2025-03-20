return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", mode = "n", desc = "Open Diffview" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", mode = "n", desc = "Open Diffview History" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff1_plain",
			},
		},
		file_panel = {
			win_config = {
				position = "bottom",
				heigth = 20,
			},
		},
		hooks = {
			view_opened = function()
				vim.api.nvim_tabpage_set_var(0, "name", "Diffview")
			end,
			diff_buf_read = function()
				vim.opt_local.wrap = false
			end,
		},
		keymaps = {
			-- disable_defaults = false,
			view = {
				-- {
				-- 	"n",
				-- 	"<leader>b",
				-- 	require("diffview.actions").focus_files,
				-- 	{ desc = "Bring focus to the file panel" },
				-- },
				-- {
				-- 	"n",
				-- 	"<leader>e",
				-- 	require("diffview.actions").toggle_files,
				-- 	{ desc = "Toggle the file panel." },
				-- },
				{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
			},
			file_panel = {
				{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
			},
		},
	},
}
