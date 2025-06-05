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
		picker = {},
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
		---@diagnostic disable-next-line: missing-fields
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
		-- {
		-- 	"<leader>n",
		-- 	function()
		-- 		require("snacks").notifier.show_history()
		-- 	end,
		-- 	desc = "Notification history",
		-- },
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
			desc = "File Explorer",
		},
		-- Pickers
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
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
		{
			"<leader>f<space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
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
