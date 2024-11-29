return {
	-- Text objects
	{
		"echasnovski/mini.ai",
		version = "*",
		opts = {},
	},
	-- Sessions
	{
		"echasnovski/mini.sessions",
		version = "*",
		opts = {
			file = "",
			hooks = {
				post = {
					read = function()
						require("fidget").notify("Session restore", vim.log.levels.INFO, { annote = "Mini Sessions" })
					end,
				},
			},
		},
		keys = {
			{
				"<leader>ss",
				function()
					local path = string.gsub(vim.fn.getcwd() .. ".session.vim", "/", "%%2F")
					require("mini.sessions").write(path)
				end,
				desc = "Save local session",
			},
			{
				"<leader>sr",
				function()
					require("mini.sessions").read()
				end,
				desc = "Restore local session",
			},
		},
	},
}
