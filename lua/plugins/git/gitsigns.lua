return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			sign_priority = 30, -- override diagnostics priority
			signs = {
				add = { text = "▎" }, -- ┃
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "▌" },
				change = { text = "▌" },
				delete = { text = "▌" },
				topdelete = { text = "▌" },
				changedelete = { text = "▌" },
				untracked = { text = "┆" },
			},
			preview_config = {
				border = "rounded",
			},
			on_attach = function(bufnr)
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })

				map("v", "<leader>ghs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("v", "<leader>ghr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk" })

				map("n", "<leader>ghp", gitsigns.preview_hunk_inline, { desc = "Preview hunk" })
			end,
		})
	end,
}
