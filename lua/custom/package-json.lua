local M = {}

local has_been_initialized = false

---@param bufnr number
M.init = function(bufnr)
	if has_been_initialized then
		return
	end

	local parser, error = vim.treesitter.get_parser(bufnr, "json")

	if not parser then
		vim.notify(error or "Unexpected error: parser is nil", vim.log.levels.ERROR)
		return
	end

	local tree = parser:parse()

	if not tree then
		vim.notify("Unexpected error: tree is nil", vim.log.levels.ERROR)
		return
	end

	local dependencies_query_text = [[
    (pair
      key: (string
        (string_content) @key (#any-of? @key "dependencies" "devDependencies")
      )
      value: (object
          (pair
            key: (string
              (string_content) @dep_key
            )
            value: (string
              (string_content) @dep_value
            )
          )
      )
    )
  ]]
	local query = vim.treesitter.query.parse("json", dependencies_query_text)

	-- TODO:
	-- make table of deps (name, {version, position, shouldUpdate})

	---@type table<string, string>
	local dependencies = {}

	for _, match in query:iter_matches(tree[1]:root(), bufnr) do
		local key_node = match[2][1]
		local value_node = match[3][1]

		local key = vim.treesitter.get_node_text(key_node, bufnr)
		local value = vim.treesitter.get_node_text(value_node, bufnr)

		dependencies[key] = value
	end

	vim.notify(vim.inspect(dependencies))

	has_been_initialized = true
end

return M
