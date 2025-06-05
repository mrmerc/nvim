return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"natecraddock/telescope-zf-native.nvim",
		"telescope/_extensions",
	},
	opts = function()
		local telescope = require("telescope")
		local config = require("telescope.config")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		local get_default_status_text = config.values.get_status_text

		telescope.setup({
			defaults = {
				get_status_text = function(picker, opts)
					local status_text = get_default_status_text(picker, opts) .. " "

					return status_text
				end,
				prompt_prefix = " > ",
				selection_caret = " > ",
				entry_prefix = "   ",
				path_display = {
					filename_first = {
						reverse_directories = true,
					},
				},
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = { prompt_position = "top", height = 24, width = 72, preview_cutoff = 160 },
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					-- find_command = { "fd", "-tf", "-td", "-H", "--no-follow", "--color=never" },
				},
				oldfiles = {
					cwd_only = true,
				},
				live_grep = {
					layout_config = {
						horizontal = { preview_cutoff = 0, width = 0.8 },
					},
				},
				grep_string = {},
			},
		})

		telescope.load_extension("zf-native")
		telescope.load_extension("package_scripts")

		-- set keymaps
		local map = vim.keymap.set

		map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files (cwd)" })
		map("n", "<leader>f.", function()
			builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
		end, { desc = "Find siblings" })
		map("n", "<leader>f<CR>", "<cmd>Telescope resume<CR>", { desc = "Resume previous search" })
		map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Find recent files" })
		map("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string (cwd)" })
		map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find string under cursor (cwd)" })
		map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
		map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
		map("n", "<leader>fa", "<cmd>Telescope package_scripts<CR>", { desc = "Find actions" })
	end,
}
