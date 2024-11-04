local M = {}
local api = vim.api

local state = require "showkeys.state"
local utils = require "showkeys.utils"

state.ns = api.nvim_create_namespace "Showkeys"

M.setup = function(opts)
  state.config = vim.tbl_deep_extend("force", state.config, opts or {})
end

M.open = function()
  state.visible = true
  state.buf = api.nvim_create_buf(false, true)
  utils.gen_winconfig()
  vim.bo[state.buf].ft = "Showkeys"

  state.timer = vim.loop.new_timer()
  state.on_key = vim.on_key(function(_, char)
    if not state.win then
      state.win = api.nvim_open_win(state.buf, false, state.config.winopts)
      vim.wo[state.win].winhl = "FloatBorder:Comment,Normalfloat:Normal"
    end

    utils.parse_key(char)

    state.timer:stop()
    state.timer:start(
      state.config.timeout * 1000,
      0,
      vim.schedule_wrap(function()
        state.keys = {}
        local tmp = state.win
        state.win = nil
        api.nvim_win_close(tmp, true)
      end)
    )
  end)

  api.nvim_set_hl(0, "SkInactive", { default = true, link = "Visual" })
  api.nvim_set_hl(0, "SkActive", { default = true, link = "pmenusel" })

  local augroup = api.nvim_create_augroup("ShowkeysAu", { clear = true })
  api.nvim_create_autocmd("VimResized", { group = augroup, callback = utils.redraw })

  api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = function()
      if state.win then
        M.close()
      end
    end,
    buffer = state.buf,
  })
end

M.close = function()
  api.nvim_del_augroup_by_name "ShowkeysAu"
  state.timer:stop()
  state.keys = {}
  state.w = 1
  state.extmark_id = nil
  vim.cmd("bd" .. state.buf)
  vim.on_key(nil, state.on_key)
  state.visible = false
  state.win = nil
end

M.toggle = function()
  M[state.visible and "close" or "open"]()
end

return M
