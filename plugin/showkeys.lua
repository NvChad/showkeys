vim.api.nvim_create_user_command("ShowkeysToggle", function()
	require("showkeys").toggle()
end, { desc = "Toggle showkeys" })
