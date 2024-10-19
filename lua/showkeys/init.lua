local M = {}
local api = vim.api

local state = require "showkeys.state"
local layout = require "showkeys.layout"
local volt = require "volt"
local utils = require "showkeys.utils"

state.ns = api.nvim_create_namespace "Showkeys"

M.setup = function(opts)
  state.config = vim.tbl_deep_extend("force", state.config, opts or {})
end

M.open = function()
  state.buf = api.nvim_create_buf(false, true)

  volt.gen_data {
    { buf = state.buf, layout = layout, xpad = state.xpad, ns = state.ns },
  }

  state.win = api.nvim_open_win(state.buf, false, utils.gen_winconfig())
  api.nvim_win_set_hl_ns(state.win, state.ns)
  vim.wo[state.win].winhighlight = "FloatBorder:Comment,Normalfloat:Normal"

  volt.run(state.buf, { h = state.h, w = state.w })
  vim.bo[state.buf].ft = "Showkeys"

  state.timer = vim.loop.new_timer()

  state.on_key = vim.on_key(function(_, char)
    utils.parse_key(char)

    if state.timer:is_active() then
      state.timer:stop()
    end

    state.timer:start(
      state.config.timeout * 1000,
      0,
      vim.schedule_wrap(function()
        state.keys = {}
        utils.redraw()
      end)
    )
  end)
end

M.close = function()
  state.timer:stop()
  state.keys = {}
  vim.cmd("bd" .. state.buf)
  require("volt.state")[state.buf] = nil
  vim.on_key(nil, state.on_key)
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
