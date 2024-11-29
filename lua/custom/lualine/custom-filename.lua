local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({
  highlight = "lualine.highlight",
  utils = "lualine.utils.utils",
})
local M = lualine_require.require("lualine.component"):extend()

local __status = ""

local default_options = {
  symbols = {
    modified = "", -- Text to show when the file is modified.
    readonly = "󰮕", -- Text to show when the file is non-modifiable or readonly.
    unnamed = "󰘥", -- Text to show for unnamed buffers.
  },
  filename_only = true,
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
  self.icon_hl_cache = {}
end

function M.update_status(self)
  -- local path_separator = package.config:sub(1, 1)
  local data

  if self.options.filename_only then
    data = vim.fn.expand("%:t")
  else
    data = vim.fn.expand("%:~:.")
  end

  if data == "" then
    data = self.options.symbols.unnamed
  end

  data = modules.utils.stl_escape(data)

  local symbols = {}

  if vim.bo.modified then
    table.insert(symbols, self.options.symbols.modified)
  end

  if vim.bo.modifiable == false or vim.bo.readonly == true then
    table.insert(symbols, self.options.symbols.readonly)
  end

  return data .. (#symbols > 0 and " " .. table.concat(symbols, "") or "")
end

function M:apply_icon()
  local icon, icon_highlight_group
  local ok, devicons = pcall(require, "nvim-web-devicons")

  if ok then
    icon, icon_highlight_group = devicons.get_icon(vim.fn.expand("%:t"))
    if icon == nil then
      icon, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
    end

    if icon == nil and icon_highlight_group == nil then
      icon = ""
      icon_highlight_group = "DevIconDefault"
    end

    if icon then
      icon = icon .. " "
    end

    local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, "fg")

    if highlight_color then
      local default_highlight = self:get_default_hl()
      local icon_highlight = self.icon_hl_cache[highlight_color]
      if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. "_normal") then
        icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
        self.icon_hl_cache[highlight_color] = icon_highlight
      end

      icon = self:format_hl(icon_highlight) .. icon .. default_highlight
    end
  else
    local exists = vim.fn.exists("*WebDevIconsGetFileTypeSymbol")
    if exists ~= 0 then
      icon = vim.fn.WebDevIconsGetFileTypeSymbol()
      if icon then
        icon = icon .. " "
      end
    end
  end

  if not icon then
    return
  end

  self.status = icon .. self.status

  __status = self.status
end

function M.get_status()
  return __status
end

return M
