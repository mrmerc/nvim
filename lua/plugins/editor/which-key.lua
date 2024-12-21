return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function()
		require("which-key").add({
			{ "<leader>f", group = "Telescope" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Hunk" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>q", group = "Quit" },
			{ "<leader>r", group = "Replace" },
			{ "<leader>s", group = "Session" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>o", group = "Options" },
			{ "<leader>w", group = "Window" },
			{ "<leader>z", group = "Zen" },
			{ "<leader><tab>", group = "Tab" },
		})

		return {
			preset = "helix",
			icons = {
				group = "",
			},
		}
	end,
}
