
# Showkeys (WIP)

Eye-candy keys screencaster for Neovim

https://github.com/user-attachments/assets/b789fa38-670c-452d-bd6f-431340f9e7f0

## Install

```lua
{ "nvchad/volt", lazy = true }
{ "nvchad/showkeys", cmd = "ShowkeysToggle" }
```

## Usage

```lua
  require("showkeys").toggle()
```

## Config

Check the [config table here](https://github.com/NvChad/showkeys/blob/main/lua/showkeys/state.lua#L7)

```lua
{
  "nvchad/showkeys",
  opts = {
    timeout = 1,
    maxkeys = 5,
    -- more opts
  }
}
```
