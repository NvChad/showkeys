local M = {}
local api = vim.api
local state = require "showkeys.state"

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
  return str1 .. (str2 and (" " .. str2) or "")
end

M.gen_winconfig = function()
  local lines = vim.o.lines
  local cols = vim.o.columns
  state.winopts.width = state.w

  local pos = state.config.position

  if string.find(pos, "bottom") then
    state.winopts.row = lines - 5
  end

  if pos == "top-right" then
    state.winopts.col = cols - state.w - 3
  elseif pos == "top-center" or pos == "bottom-center" then
    state.winopts.col = math.floor(cols / 2) - math.floor(state.w / 2)
  elseif pos == "bottom-right" then
    state.winopts.col = cols - state.w - 3
  end
end

local update_win_w = function()
  local keyslen = #state.keys
  state.w = keyslen + state.xpad + (2 * keyslen) -- 2 spaces around each key

  for _, v in ipairs(state.keys) do
    state.w = state.w + vim.fn.strwidth(v.txt)
  end

  M.gen_winconfig()
  api.nvim_win_set_config(state.win, state.winopts)
end

M.draw = function()
  local virt_txts = require "showkeys.ui"()

  if not state.extmark_id then
    api.nvim_buf_set_lines(state.buf, 0, -1, false, { string.rep(" ", state.w) })
  end

  local opts = { virt_text = virt_txts, virt_text_pos = "overlay", id = state.extmark_id }
  local id = api.nvim_buf_set_extmark(state.buf, state.ns, 0, 1, opts)

  if not state.extmark_id then
    state.extmark_id = id
  end
end

M.redraw = function()
  update_win_w()
  M.draw()
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
