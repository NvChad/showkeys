local M = {}
local api = vim.api

local state = require "showkeys.state"
local layout = require "showkeys.layout"
local extmarks = require "volt"
local utils = require "showkeys.utils"

state.ns = api.nvim_create_namespace "Showkeys"

M.open = function()
  vim.g.showkeys_shown = true
  state.buf = api.nvim_create_buf(false, true)

  extmarks.gen_data {
    { buf = state.buf, layout = layout, xpad = state.xpad, ns = state.ns },
  }

  state.win = api.nvim_open_win(state.buf, false, utils.gen_winconfig())
  api.nvim_win_set_hl_ns(state.win, state.ns)
  vim.wo[state.win].winhighlight = "FloatBorder:Comment"

  extmarks.run(state.buf, { h = state.h, w = state.w })
  vim.bo[state.buf].ft = "Showkeys"

  local timer = vim.loop.new_timer()

  state.on_key = vim.on_key(function(_, char)
    utils.parse_key(char)

    if timer:is_active() then
      timer:stop()
    end

    timer:start(
      3000,
      0,
      vim.schedule_wrap(function()
        state.keys = {}
        utils.redraw()
      end)
    )
  end)
end

M.close = function()
  vim.cmd("bd" .. state.buf)
  require("volt.state")[state.buf] = nil
  vim.on_key(nil, state.on_key)
  vim.g.showkeys_shown = false
end

M.toggle = function()
  if state.visible then
    M.close()
  else
    M.open()
  end

  state.visible = not state.visible
end

return M
