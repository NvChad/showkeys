# Showkeys

Eye-candy keys screencaster for Neovim

https://github.com/user-attachments/assets/a85d6546-b457-49b6-aca6-c9b0410d3512
  
## Install

```lua
{ "nvchad/showkeys", cmd = "ShowkeysToggle" }
```

## Usage

`ShowkeysToggle`

## Config

Check the [config table here](https://github.com/NvChad/showkeys/blob/main/lua/showkeys/state.lua#L7)

```lua
{
  "nvchad/showkeys",
  cmd = "ShowkeysToggle",
  opts = {
    timeout = 1,
    maxkeys = 5,
    -- more opts
  }
}
```
