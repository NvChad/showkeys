local M = {}
local api = vim.api
local state = require "showkeys.state"
local extmarks = require "volt"

local is_mouse = function(x)
  return x:match "Mouse" or x:match "Scroll" or x:match "Drag" or x:match "Release"
end

local function format_mapping(str)
  local keyformat = state.config.keyformat

  local str1 = string.match(str, "<(.-)>")
  if not str1 then
    return str
  end

  local before, after = string.match(str1, "([^%-]+)%-(.+)")

  if before then
    before = "<" .. before .. ">"
    before = keyformat[before] or before
    str1 = before .. " + " .. string.lower(after)
  end

  local str2 = string.match(str, ">(.+)")

  -- if not before then
  --   str1 = "<" .. str1 .. ">"
  --   str1 = keystrs[str1] or str1
  -- end

  return str1 .. (str2 and (" " .. str2) or "")
end

M.gen_winconfig = function()
  return {
    focusable = false,
    row = vim.o.lines - 3 - (state.h + 2),
    col = vim.o.columns - state.w - 3,
    width = state.w,
    height = state.h,
    relative = "editor",
    style = "minimal",
    border = "single",
  }
end

local update_win_w = function()
  local keyslen = #state.keys
  state.w = keyslen + state.xpad + (2 * keyslen) -- 2 spaces around each key

  for _, v in ipairs(state.keys) do
    state.w = state.w + vim.fn.strwidth(v.txt)
  end

  api.nvim_win_set_config(state.win, M.gen_winconfig())
end

M.redraw = function()
  update_win_w()
  extmarks.redraw(state.buf, "keys")
end

M.parse_key = function(char)
  local keyformat = state.config.keyformat
  local opts = state.config
  local key = vim.fn.keytrans(char)

  if is_mouse(key) or key == "" then
    return
  end

  key = keyformat[key] or key
  key = format_mapping(key)

  local arrlen = #state.keys
  local last_key = state.keys[arrlen]

  if opts.show_count and last_key and key == last_key.key then
    local count = (last_key.count or 1) + 1

    state.keys[arrlen] = {
      key = key,
      txt = count .. " " .. key,
      count = count,
    }
  else
    if arrlen == opts.maxkeys then
      table.remove(state.keys, 1)
    end

    table.insert(state.keys, { key = key, txt = key })
  end

  M.redraw()
end

return M
