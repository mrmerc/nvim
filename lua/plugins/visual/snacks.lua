return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		local cursor_hide_group = vim.api.nvim_create_augroup("cursor_hide_group", { clear = true })

		local show_cursor = function()
			vim.opt.guicursor:remove("n:Cursor")
			vim.cmd("hi Cursor blend=0")
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
	---@diagnostic disable-next-line: missing-fields
	opts = {
		dashboard = {
			enabled = true,
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
		lazygit = {
			enabled = true,
			config = {
				gui = {
					authorColors = {
						["'Vasiliy Andreev'"] = "blue",
						["'*'"] = "white",
					},
				},
			},
		},
		notifier = {
			enabled = true,
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
		scroll = { enabled = true },
		---@diagnostic disable-next-line: missing-fields
		dim = { enabled = true },
		styles = {
			---@diagnostic disable-next-line: missing-fields
			["notification_history"] = {
				---@diagnostic disable-next-line: missing-fields
				wo = {
					number = false,
					relativenumber = false,
				},
			},
		},
	},
	keys = {
		{
			"<leader>gg",
			function()
				require("snacks").lazygit.open()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "Notification history",
		},
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
	},
}
