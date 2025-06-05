return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", mode = "n", desc = "Open Diffview" },
	},
	opts = {
		enhanced_diff_hl = false,
		view = {
			merge_tool = {
				layout = "diff1_plain",
			},
		},
		hooks = {
			diff_buf_read = function()
				vim.opt_local.wrap = false
			end,
			diff_buf_win_enter = function(bufnr, winid, ctx)
				-- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
				-- the right.
				print(vim.inspect(ctx.layout_name))
				if ctx.layout_name:match("^diff2") then
					if ctx.symbol == "a" then
						print(vim.inspect(ctx))
						vim.opt_local.winhl = table.concat({
							"DiffAdd:DiffviewDiffAddAsDelete",
							"DiffDelete:DiffviewDiffDeleteDim",
							"DiffChange:DiffviewDiffChange",
							"DiffText:DiffviewDiffText",
						}, ",")
					elseif ctx.symbol == "b" then
						vim.opt_local.winhl = table.concat({
							"DiffDelete:DiffviewDiffDeleteDim",
							"DiffAdd:DiffviewDiffAdd",
							"DiffChange:DiffviewDiffChange",
							"DiffText:DiffviewDiffText",
						}, ",")
					end
				end
			end,
		},
		keymaps = {
			view = {
				{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
			},
			file_panel = {
				{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
			},
		},
	},
}
