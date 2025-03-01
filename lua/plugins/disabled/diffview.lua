return {
	"sindrets/diffview.nvim",
	enabled = false,
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
				-- layout = "diff1_plain",
			},
		},
		hooks = {
			view_opened = function()
				vim.api.nvim_tabpage_set_var(0, "name", "Diffview")
			end,
			diff_buf_read = function()
				vim.opt_local.wrap = false
			end,
			diff_buf_win_enter = function(bufnr, winid, ctx)
				if not ctx.layout_name:match("^diff2") then
					return
				end

				local winHl = {
					a = {
						"DiffAdd:DiffviewDiffAddAsDelete",
						"DiffDelete:DiffviewDiffDeleteDim",
						"DiffChange:DiffviewDiffChange",
						"DiffText:DiffviewDiffText",
					},
					b = {
						"DiffDelete:DiffviewDiffDeleteDim",
						"DiffAdd:DiffviewDiffAdd",
						"DiffChange:DiffviewDiffChange",
						"DiffText:DiffviewDiffText",
					},
				}

				vim.opt_local.winhl = table.concat(winHl[ctx.symbol], ",")
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
