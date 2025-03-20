return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function()
		require("which-key").add({
			{ "<leader>c", group = "Command" },
			{ "<leader>f", group = "Find" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>q", group = "Quit" },
			{ "<leader>r", group = "Replace" },
			{ "<leader>p", group = "Yanky History" },
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
