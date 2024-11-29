return {
	"MysticalDevil/inlay-hints.nvim",
	event = "LspAttach",
	dependencies = { "neovim/nvim-lspconfig" },
	keys = {
		{ "<leader>th", "<cmd>InlayHintsToggle<CR>", desc = "Toggle inlay hints" },
	},
	opts = {
		autocmd = { enable = false },
	},
}
