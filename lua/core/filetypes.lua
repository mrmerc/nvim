vim.filetype.add({
	pattern = {
		[".env.*"] = "sh",
	},
	extension = {
		gotmpl = "gotmpl",
	},
})
