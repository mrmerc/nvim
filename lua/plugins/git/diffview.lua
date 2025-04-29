return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", mode = "n", desc = "Open Diffview" },
		{ "<leader>gF", "<cmd>DiffviewFileHistory<CR>", mode = "n", desc = "Open Diffview History" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", mode = "n", desc = "Open Diffview History (file)" },
	},
	config = function()
		require("diffview").setup({
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

					for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
						vim.api.nvim_win_set_var(winid, "name", "Diffview")
					end
				end,
				diff_buf_read = function()
					vim.opt_local.wrap = false
				end,
			},
			keymaps = {
				view = {
					{
						"n",
						"<leader>cc",
						require("diffview.actions").conflict_choose("ours"),
						{ desc = "Choose the Current change" },
					},
					{
						"n",
						"<leader>ci",
						require("diffview.actions").conflict_choose("theirs"),
						{ desc = "Choose the Incoming change" },
					},
					{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
				},
				file_panel = {
					{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
				},
			},
		})
	end,
}
