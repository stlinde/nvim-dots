-- [[ Files ]]
vim.api.nvim_create_autocmd("User", {
	group = minifiles_augroup,
	pattern = "MiniFilesWindowOpen",
	callback = function(args)
		vim.api.nvim_win_set_config(args.data.win_id, { border = "solid" })
	end,
})
