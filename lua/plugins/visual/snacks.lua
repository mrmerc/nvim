return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header", padding = 5 },
				-- @type snacks.dashboard.Gen
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
			"<leader>gl",
			function()
				require("snacks").lazygit.log()
			end,
			desc = "Lazygit (log)",
		},
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "Notification history",
		},
	},
}
