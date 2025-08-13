local HEIGHT_RATIO = 0.9
local WIDTH_RATIO = 0.5

local close_floating_windows = function()
	if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "NvimTree" then
		return
	end

	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			vim.api.nvim_win_close(win, false)
		end
	end
end

-- LSP rename
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
	pattern = "NvimTreeSetup",
	callback = function()
		local events = require("nvim-tree.api").events
		events.subscribe(events.Event.NodeRenamed, function(data)
			if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
				data = data
				Snacks.rename.on_rename_file(data.old_name, data.new_name)
			end
		end)
	end,
})

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		vim.api.nvim_set_hl(0, "NvimTreeGitNewIcon", { link = "DiagnosticHint" })
		vim.api.nvim_set_hl(0, "NvimTreeGitDirtyIcon", { link = "DiagnosticInfo" })
		vim.api.nvim_set_hl(0, "NvimTreeGitDeletedIcon", { link = "DiagnosticError" })
		vim.api.nvim_set_hl(0, "NvimTreeGitStagedIcon", { link = "DiagnosticWarn" })
	end,
	opts = {
		update_focused_file = { enable = true },
		filters = {
			git_ignored = false,
			custom = { "^.git$" },
		},
		renderer = {
			root_folder_label = function(path)
				return " 󰝰 " .. vim.fn.fnamemodify(path, ":t")
			end,
			highlight_git = "all",
			highlight_diagnostics = "icon",
			icons = {
				bookmarks_placement = "after",
				show = {
					folder_arrow = true,
					git = false,
				},
				glyphs = {
					default = "󰈔",
					folder = {
						arrow_closed = " ",
						arrow_open = " ",
						default = "󰉋",
						open = "󰝰",
						empty = "󰉖",
						empty_open = "󰷏",
						symlink = "󰴋",
						symlink_open = "󰴋",
					},
				},
			},
		},
		diagnostics = {
			enable = true,
			icons = {
				hint = vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT],
				info = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO],
				warning = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN],
				error = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR],
			},
		},
		filesystem_watchers = {
			ignore_dirs = {
				"/.ccls-cache",
				"/build",
				"/node_modules",
				"/target",
				"/dist",
			},
		},
		actions = {
			open_file = {
				quit_on_open = true,
				window_picker = {
					enable = false,
				},
			},
		},
		view = {
			float = {
				enable = true,
				quit_on_focus_loss = false,
				open_win_config = function()
					local screen_w = vim.opt.columns:get()
					local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					local window_w = screen_w * WIDTH_RATIO
					local window_h = screen_h * HEIGHT_RATIO
					local window_w_int = math.floor(window_w)
					local window_h_int = math.floor(window_h)
					local center_x = (screen_w - window_w) / 2
					-- local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
					return {
						border = "rounded",
						relative = "editor",
						row = 1,
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
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set("n", "<ESC>", api.tree.close, opts("Close (Esc)"))
		end,
	},
	keys = {
		{
			"<leader>e",
			function()
				close_floating_windows()
				vim.cmd("NvimTreeToggle")
			end,
			desc = "Explorer",
		},
	},
}
