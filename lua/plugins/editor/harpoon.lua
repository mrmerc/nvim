return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon.setup({
			default = {
				display = function(item)
					local file = item.value
					local icon = Snacks.util.icon(vim.fn.fnamemodify(file, ":e"), "file")
					local name = vim.fn.fnamemodify(file, ":t")
					local path =
						Snacks.picker.util.truncpath(vim.fn.fnamemodify(file, ":h"), 40, { cwd = vim.loop.cwd() })

					return "  " .. icon .. " " .. name .. " " .. path
				end,
			},
		})
	end,
	keys = function()
		local harpoon = require("harpoon")

		return {
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				desc = "Add file to harpoon",
			},
			{
				"<leader>hc",
				function()
					harpoon:list():clear()
				end,
				desc = "Clear harpoon list",
			},
			{
				"<leader>hh",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon menu",
			},
		}
	end,
}
