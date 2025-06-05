local get_window_width = function()
	local window_id = vim.api.nvim_get_current_win()
	local window_info = vim.fn.getwininfo(window_id)[1]

	return window_info.width
end

local encoding = function()
	return vim.opt.fileencoding:get()
end

local lsp_status = function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local result = ""
	local lsp_names = {}

	for _, value in ipairs(clients) do
		table.insert(lsp_names, value.name)
	end

	if #lsp_names == 0 then
		return result .. "None"
	end

	return result .. table.concat(lsp_names, ", ")
end

local codeium_status = function()
	local status = require("codeium.virtual_text").status()

	if status.state == "idle" then
		-- Output was cleared, for example when leaving insert mode
		return " "
	end

	if status.state == "waiting" then
		-- Waiting for response
		return "Waiting..."
	end

	if status.state == "completions" and status.total > 0 then
		return string.format("%d / %d", status.current, status.total)
	end

	return " 0 "
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "j-hui/fidget.nvim" },
	lazy = false,
	enabled = false,
	opts = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local custom_filename = require("custom.lualine.custom-filename")

		local colors = {
			-- normal = "#65D1FF",
			-- insert = "#3EFFDC",
			-- visual = "#FF61EF",
			-- command = "#FFDA7B",
			-- replace = "#FF4A4A",
			fg = "#c3ccdc",
			fg_dimmed = "#32374d",
			bg = "#010f1a",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = {
					bg = colors.bg,
					fg = colors.fg --[[ , gui = "bold" ]],
				},
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				-- z = { bg = colors.bg, fg = colors.fg_dimmed },
			},
			insert = {
				a = {
					bg = colors.bg,
					fg = colors.fg --[[ , gui = "bold" ]],
				},
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				-- z = { bg = colors.bg, fg = colors.fg_dimmed },
			},
			visual = {
				a = {
					bg = colors.bg,
					fg = colors.fg --[[ , gui = "bold" ]],
				},
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				-- z = { bg = colors.bg, fg = colors.fg_dimmed },
			},
			command = {
				a = {
					bg = colors.bg,
					fg = colors.fg --[[ , gui = "bold" ]],
				},
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				-- z = { bg = colors.bg, fg = colors.fg_dimmed },
			},
			replace = {
				a = {
					bg = colors.bg,
					fg = colors.fg --[[ , gui = "bold" ]],
				},
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				-- z = { bg = colors.bg, fg = colors.fg_dimmed },
			},
			inactive = {
				a = {
					bg = colors.inactive_bg,
					fg = colors.semilightgray --[[ , gui = "bold" ]],
				},
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
				-- z = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- FIXME:
		-- local mode_max_length = "▋ NORMAL" -- max 9 chars mode

		-- local LENGTH_WITH_ICON = 2
		--
		-- local get_mode_length = function()
		--   local mode = require("lualine.utils.mode")
		--
		--   return string.len(mode.get_mode()) + LENGTH_WITH_ICON
		-- end

		-- local get_custom_filename_length = function()
		--   -- vim.notify(custom_filename.get_status())
		--   return string.len(custom_filename.get_status())
		-- end

		-- local get_center_padding_left = function(filename_length)
		--   return math.floor(get_window_width() / 2) - get_mode_length() -
		--       math.floor((filename_length + LENGTH_WITH_ICON) / 2)
		-- end

		-- local function newCenterPadding()
		--   local center_padding = {
		--     left = 0,
		--     right = 0,
		--   };
		--
		--   local function getLeft()
		--     return center_padding.left
		--   end
		--   local function getRight()
		--     return center_padding.right
		--   end
		--   local function setLeft(value)
		--     center_padding.left = value
		--   end
		--   local function setRight(value)
		--     center_padding.right = value
		--   end
		--
		--   return {
		--     getLeft, getRight, setLeft, setRight
		--   }
		-- end

		-- local padding = newCenterPadding()

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_show_tabline = false,
				always_divide_middle = true,
				disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
			},
			sections = {
				-- lualine_a = {
				--   {
				--     "mode",
				--     -- icon = { "▍" },
				--   },
				-- },
				lualine_a = {
					{
						custom_filename,
						padding = { left = 63, right = 1 },
						-- filename_only = false
					},
					{ "diagnostics" },
				},
				lualine_b = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ codeium_status },
					{ "require'package-info'.get_status()" },
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_z = { { "tabs", mode = 2 } },
			},
		})
	end,
	keys = {
		{
			"<leader>bi",
			function()
				local group = "buffer_info"

				local git_current_branch_name = vim.system(
					{ "git", "branch", "--show-current" },
					{ text = true, cwd = vim.fn.getcwd() }
				):wait()

				local data = {
					{ "", encoding() },
					{ "󰒋", lsp_status() },
					{ "", git_current_branch_name.stdout or "" },
					{ "", vim.fn.expand("%:~:.:h") },
				}

				for _, item in ipairs(data) do
					vim.notify(item[2], vim.log.levels.INFO, { annote = item[1], group = group, ttl = 8 })
				end
			end,
			desc = "Show buffer info",
		},
	},
}
