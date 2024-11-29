local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- NOTE: ensure the telescope is loaded
-- before registering the extension
local has_telescope, _ = pcall(require, "telescope")
if not has_telescope then
	vim.notify(
		"This extension requires telescope.nvim " .. "(https://github.com/nvim-telescope/telescope.nvim)",
		vim.log.levels.ERROR
	)
end

local package_scripts_picker = function(opts)
	opts = opts or {}

	opts.cwd = opts.cwd or vim.fn.getcwd()
	opts.package_manager = opts.package_manager or "npm"

	local path_to_package_json = vim.fn.findfile("package.json", opts.cwd)

	if path_to_package_json == "" then
		vim.notify("Unable to find package.json", vim.log.levels.ERROR)
		return
	end

	local command = { "jq", ".scripts | keys", path_to_package_json }

	local system_cmd_result = vim.system(command, { text = true, cwd = opts.cwd }):wait()
	local scripts_json_string = system_cmd_result.stdout or ""

	local scripts_table = vim.json.decode(scripts_json_string)

	pickers
		.new(opts, {
			prompt_title = "Scripts",
			finder = finders.new_table({
				results = scripts_table,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)

					local script_name = action_state.get_selected_entry()[1]

					command = {
						"wezterm",
						"cli",
						"split-pane",
						"--right",
						"--",
						"zsh",
						"-ilc",
						string.format("%s run %s && exec /bin/zsh", opts.package_manager, script_name),
					}

					vim.system(command, {}, function() end)
				end)

				return true
			end,
		})
		:find()
end

return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
	end,
	exports = {
		package_scripts = package_scripts_picker,
	},
})
