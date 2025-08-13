return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	opts = {},
}

-- add: ys{motion}{char}
-- delete: ds{char}
-- change: cs{target}{replacement}

-- Examples:
-- dst - remove tag around
-- cst{newTag}<CR> - replace tag with newTag
-- dsf - remove function arround argument fn(arg) -> arg
-- csf{newFunction} - replace function arround argument fn(arg) -> newFunction(arg)
-- ysiwf{newFunction} - wrap function arround argument arg -> newFunction(arg)
