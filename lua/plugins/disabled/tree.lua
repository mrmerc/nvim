local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
	"nvim-tree/nvim-tree.lua",
	enabled = false,
	dependencies = "nvim-tree/nvim-web-devicons",
	init = function()
		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	opts = {
		update_focused_file = {
			enable = true,
		},
		view = {
			relativenumber = false,
			float = {
				enable = true,
				open_win_config = function()
					local screen_w = vim.opt.columns:get()
					local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					local window_w = screen_w * WIDTH_RATIO
					local window_h = screen_h * HEIGHT_RATIO
					local window_w_int = math.floor(window_w)
					local window_h_int = math.floor(window_h)
					local center_x = (screen_w - window_w) / 2
					local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
					return {
						border = "rounded",
						relative = "editor",
						row = center_y,
						col = center_x,
						width = window_w_int,
						height = window_h_int,
					}
				end,
			},
			width = function()
				return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
			end,
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = false, -- Turn into false from true by default
		},
		renderer = {
			highlight_git = "all",
			icons = {
				glyphs = {
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "",
						-- untracked = "★",
						deleted = "",
						-- ignored = "◌",
						-- ignored = "",
						ignored = "",
					},
				},
			},
		},
		actions = {
			change_dir = {
				enable = false,
			},
			open_file = {
				quit_on_open = true,
				window_picker = {
					enable = false,
				},
			},
		},
		filters = {
			git_ignored = false,
			custom = { ".DS_Store", "^.git$" },
		},
	},
	keys = {
		{ "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "Toggle file explorer on current file" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
	},
}
