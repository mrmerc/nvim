return {
	"nvim-telescope/telescope.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"natecraddock/telescope-zf-native.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local config = require("telescope.config")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		local get_default_status_text = config.values.get_status_text

		local search_string_layout = {
			layout_strategy = "vertical",
			layout_config = {
				vertical = {
					prompt_position = "top",
					mirror = true,
					height = 0.8,
					width = { 0.8, max = 120 },
					preview_height = 0.5,
					preview_cutoff = 0,
				},
			},
			preview = true,
		}

		telescope.setup({
			defaults = {
				get_status_text = function(picker, opts)
					local status_text = get_default_status_text(picker, opts) .. " "

					return status_text
				end,
				prompt_prefix = " > ",
				selection_caret = " > ",
				entry_prefix = "   ",
				dynamic_preview_title = true,
				results_title = false,
				path_display = {
					filename_first = {
						reverse_directories = false,
					},
				},
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						height = { 0.64, max = 28 },
						width = { 0.5, max = 80 },
					},
				},
				preview = false,
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<ESC>"] = actions.close,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = {
						"rg",
						"--files",
						"-S",
						"--no-follow",
						"--hidden",
						"--glob",
						"!.git/*",
						"--type-add",
						"env:.env*",
						"--color=never",
					},
				},
				oldfiles = {
					cwd_only = true,
					layout_config = {
						horizontal = {
							height = { 0.32, max = 12 },
						},
					},
				},
				live_grep = search_string_layout,
				grep_string = search_string_layout,
			},
		})

		telescope.load_extension("zf-native")

		local map = vim.keymap.set

		map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files (cwd)" })
		map("n", "<leader>f.", function()
			builtin.find_files({ cwd = vim.fn.expand("%:p:h"), prompt_title = vim.fn.expand("%:~:.") })
		end, { desc = "Find siblings" })
		map("n", "<leader>f<CR>", "<cmd>Telescope resume<CR>", { desc = "Resume previous search" })
		map("n", "<leader>fr", function()
			builtin.oldfiles({ prompt_title = "Recent" })
		end, { desc = "Find recent files" })
		map("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string (cwd)" })
		map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find string under cursor (cwd)" })
		map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
		map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
		map("n", "<leader>fa", "<cmd>Telescope package_scripts<CR>", { desc = "Find actions" })
	end,
}
