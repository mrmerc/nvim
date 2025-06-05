return {
	"vuki656/package-info.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "BufEnter package.json",
	opts = function()
		local opts = {
			-- autostart = false,
			-- hide_up_to_date = true,
			colors = {
				up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
				outdated = "#d19a66", -- Text color for outdated dependency virtual text
				invalid = "#ee4b2b", -- Text color for invalid dependency virtual text
			},
			package_manager = "npm",
		}

		require("package-info").setup(opts)

		vim.cmd([[highlight PackageInfoUpToDateVersion guifg=]] .. opts.colors.up_to_date)
		vim.cmd([[highlight PackageInfoOutdatedVersion guifg=]] .. opts.colors.outdated)
		vim.cmd([[highlight PackageInfoInvalidVersion guifg=]] .. opts.colors.outdated)
	end,
	keys = {
		{
			"<leader>cd",
			function()
				require("package-info").show({ force = true })
			end,
			desc = "Show package info",
		},
	},
}
