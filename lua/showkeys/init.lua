local M = {}
local api = vim.api

local state = require "showkeys.state"
local utils = require "showkeys.utils"

state.ns = api.nvim_create_namespace "Showkeys"

M.setup = function(opts)
  state.config = vim.tbl_deep_extend("force", state.config, opts or {})
end

M.open = function()
  state.buf = api.nvim_create_buf(false, true)
  utils.gen_winconfig()
  state.win = api.nvim_open_win(state.buf, false, state.winopts)
  api.nvim_win_set_hl_ns(state.win, state.ns)
  vim.wo[state.win].winhighlight = "FloatBorder:Comment,Normalfloat:Normal"
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

  api.nvim_set_hl(0, "SkInactive", { default = true, link = "Visual" })
  api.nvim_set_hl(0, "SkActive", { default = true, link = "pmenusel" })

  local augroup = api.nvim_create_augroup("ShowkeysAu", { clear = true })
  api.nvim_create_autocmd("VimResized", { group = augroup, callback = utils.redraw })
end

M.close = function()
  state.timer:stop()
  state.keys = {}
  vim.cmd("bd" .. state.buf)
  vim.on_key(nil, state.on_key)
  api.nvim_del_augroup_by_name "ShowkeysAu"
end

M.toggle = function()
  M[state.visible and "close" or "open"]()
  state.visible = not state.visible
end

return M
