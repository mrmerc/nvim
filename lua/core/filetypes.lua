vim.filetype.add({
	pattern = {
		[".env.*"] = "sh",
		-- Mark huge files to disable features later.
		[".*"] = function(path, bufnr)
			return vim.bo[bufnr]
					and vim.bo[bufnr].filetype ~= "bigfile"
					and path
					and vim.fn.getfsize(path) > (1024 * 1024) -- 1 MB
					and "bigfile"
				or nil
		end,
	},
})
