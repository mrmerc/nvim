return {
	"akinsho/git-conflict.nvim",
	version = "*",
	opts = {
		default_mappings = false,
	},
	config = function(_, opts)
		local git_conflict = require("git-conflict")

		git_conflict.setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictDetected",
			callback = function()
				vim.keymap.set("n", "<leader>gcc", function()
					git_conflict.choose("ours")
				end, { desc = "Choose [Current] change (ours)" })

				vim.keymap.set("n", "<leader>gci", function()
					git_conflict.choose("theirs")
				end, { desc = "Choose [Incoming] change (theirs)" })

				vim.keymap.set("n", "<leader>gcb", function()
					git_conflict.choose("both")
				end, { desc = "Choose [Both] changes" })

				vim.keymap.set("n", "[x", function()
					git_conflict.find_prev("ours")
				end, { desc = "Previous conflict" })

				vim.keymap.set("n", "]x", function()
					git_conflict.find_next("ours")
				end, { desc = "Next conflict" })
			end,
		})
	end,
}
