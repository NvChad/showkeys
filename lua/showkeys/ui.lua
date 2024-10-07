local M = {}
local state = require "showkeys.state"

M.keys = function()
  local list = state.keys
  local list_len = #list

  local virt_txts = {}

  for i, val in ipairs(list) do
    local hl = i == list_len and "PmenuSel" or "ExBlack3Bg"
    table.insert(virt_txts, { " " .. val.txt .. " ", hl })
    table.insert(virt_txts, { " " })
  end

  return {
    virt_txts,
  }
end

return M
