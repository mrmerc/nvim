return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function()
		require("which-key").add({
			{ "<leader>c", group = "Command" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Harpoon" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>o", group = "Options" },
			{ "<leader>p", group = "Yanky History" },
			{ "<leader>q", group = "Quit" },
			{ "<leader>r", group = "Replace" },
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
