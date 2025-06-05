return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		local cursor_hide_group = vim.api.nvim_create_augroup("cursor_hide_group", { clear = true })

		local show_cursor = function()
			vim.defer_fn(function()
				vim.opt.guicursor:remove("n:Cursor")
				vim.cmd("hi Cursor blend=0")
			end, 250)
		end

		local hide_cursor = function()
			vim.opt.guicursor:append("n:Cursor")
			vim.cmd("hi Cursor blend=100")
		end

		-- Dashboard Cursor
		vim.api.nvim_create_autocmd("User", {
			group = cursor_hide_group,
			pattern = "SnacksDashboardOpened",
			callback = function()
				hide_cursor()
			end,
		})

		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*",
			group = cursor_hide_group,
			callback = function()
				if vim.bo.filetype ~= "snacks_dashboard" then
					return
				end

				show_cursor()
			end,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			group = cursor_hide_group,
			callback = function()
				if vim.bo.filetype ~= "snacks_dashboard" then
					return
				end

				hide_cursor()
			end,
		})
	end,
	---@type snacks.Config
	opts = {
		---@type snacks.picker.Config
		picker = {
			prompt = "  ",
			layout = {
				preset = "vertical",
			},
			hidden = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			sources = {
				explorer = {
					hidden = false,
					auto_close = true,
					win = {
						list = {
							keys = {
								["R"] = "copy_relative_name",
								["A"] = "copy_file_path",
							},
						},
					},
					actions = {
						copy_relative_name = function(_, item)
							if not item then
								return
							end

							local filename = vim.fs.basename(item.file)

							vim.fn.setreg(vim.v.register or "+", filename, "c")
							vim.notify("Copied item name", vim.log.levels.INFO)
						end,
						copy_file_path = function(_, item)
							if not item then
								return
							end

							vim.fn.setreg(vim.v.register or "+", item.file, "c")
							vim.notify("Copied item path", vim.log.levels.INFO)
						end,
					},
					layout = {
						layout = {
							width = 0.5,
							height = 0.9,
							position = "float",
						},
					},
				},
				recent = {
					filter = {
						cwd = true,
					},
					layout = {
						preset = "vscode",
						layout = {
							row = 3,
						},
					},
				},
				grep = {
					layout = {
						layout = {
							width = 0.8,
						},
					},
				},
				notifications = {
					layout = {
						preset = "ivy",
					},
				},
			},
		},
		dashboard = {
			sections = {
				{ section = "header", padding = 5 },
				---@type snacks.dashboard.Gen
				function()
					local stats = require("lazy.stats").stats()

					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

					return {
						align = "center",
						text = {
							{ stats.loaded .. "/" .. stats.count, hl = "Keyword" },
							{ " plugins loaded in ", hl = "Comment" },
							{ ms .. "ms", hl = "Keyword" },
						},
					}
				end,
			},
			formats = {
				header = { "%s", hl = "Type" },
			},
			preset = {
				header = table.concat({
					"            ...                               ..            ",
					"        -*%@@@@@#*-.                    .-+#%@@@@%*=        ",
					"      -%@@@@@@@@@@@@*:                -*@@@@@@@@@@@@@=      ",
					"     -@@@@@@@@@@@@@@@@%-            =%@@@@@@@@@@@@@@@@-     ",
					"     %@@@@@@@@@@@@@@@@@@%=        +@@@@@@@@@@@@@@@@@@@%     ",
					"     %@@@@@@@@@@@@@@@@@@#-        -#@@@@@@@@@@@@@@@@@@#     ",
					"     :@@@@@@@@@@@@@@@@*:            :*@@@@@@@@@@@@@@@@.     ",
					"      :%@@@@@@@@@@@%+.      =%%=      .+%@@@@@@@@@@@*.      ",
					"        :+#%%%%#*=.      .+%@@@@%+.      :=*#%%%#*=.        ",
					"                       -#@@@@@@@@@@*-                       ",
					"     .:            :=#@@@@@@@@@@@@@@@@#=:           .:.     ",
					"      :*##+++++*#%@@@@@@@@@@@@@@@@@@@@@@@@%#*+++++##*:      ",
					"        -#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#:        ",
					"          :#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*:          ",
					"            :#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#:            ",
					"              :#@@@@@@@@@@@@@@@@@@@@@@@@@@@@#:              ",
					"                :#@@@@@@@@@@@@@@@@@@@@@@@@#:                ",
					"                  :#@@@@@@@@@@@@@@@@@@@@#:                  ",
					"                    :#@@@@@@@@@@@@@@@@#:                    ",
					"                      :#@@@@@@@@@@@@#:                      ",
					"                        :#@@@@@@@@#:                        ",
					"                          :#@@@@#:                          ",
					"                            :##:                            ",
				}, "\n"),
			},
		},
		notifier = {
			icons = {
				error = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR],
				warn = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN],
				info = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO],
				debug = " ",
				trace = " ",
			},
			top_down = false,
			style = "compact",
		},
		scroll = {},
		input = {},
		explorer = {},
		styles = {
			input = {
				relative = "cursor",
				row = 1,
				col = 0,
				b = {
					completion = true, -- enable blink completions in input
				},
			},
		},
	},
	keys = {
		{
			"gg",
			function()
				local snacks = require("snacks")
				vim.defer_fn(function()
					snacks.scroll.enable()
				end, 50)
				snacks.scroll.disable()
				vim.cmd("1")
			end,
			desc = "Go to first line (no animation)",
		},
		{
			"G",
			function()
				local snacks = require("snacks")
				vim.defer_fn(function()
					snacks.scroll.enable()
				end, 50)
				snacks.scroll.disable()
				vim.cmd("%")
			end,
			desc = "Go to last line (no animation)",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer",
		},
		-- Pickers
		{
			"<leader>fn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notifications",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Files",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
	},
}
