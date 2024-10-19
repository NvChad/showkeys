local M = {
  xpad = 1,
  keys = {},
  w = 1,
  extmark_id = nil,

  winopts = {
    focusable = false,
    relative = "editor",
    style = "minimal",
    border = "single",
    height = 1,
    row = 0,
    col = 0,
  },

  config = {
    timeout = 3, -- in secs
    maxkeys = 3,
    show_count = false,
    position = "bottom-right",

    keyformat = {
      ["<BS>"] = "󰁮 ",
      ["<CR>"] = "󰘌",
      ["<Space>"] = "󱁐",
      ["<Up>"] = "󰁝",
      ["<Down>"] = "󰁅",
      ["<Left>"] = "󰁍",
      ["<Right>"] = "󰁔",
      ["<PageUp>"] = "Page 󰁝",
      ["<PageDown>"] = "Page 󰁅",
      ["<M>"] = "Alt",
      ["<C>"] = "Ctrl",
    },
  },
}

return M
