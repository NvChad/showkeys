vim.api.nvim_create_user_command("ShowKeysToggle", function()
	require("showkeys").toggle()
end, { desc = "Toggle showkeys" })
