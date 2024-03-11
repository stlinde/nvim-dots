-- [[ Install `lazy.nvim` ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugin Spec ]]
local plugins = {
	require("shl.plugins.catppuccin"),
	require("shl.plugins.lsp"),
	require("shl.plugins.completion"),
	require("shl.plugins.lint"),
	require("shl.plugins.neogit"),
	require("shl.plugins.neorg"),
	require("shl.plugins.telescope"),
	require("shl.plugins.mini"),
	require("shl.plugins.alpha"),
	require("shl.plugins.treesitter"),
	require("shl.plugins.conform"),
	require("shl.plugins.whichkey"),

	-- Nvim Coding
	{
		"folke/neoconf.nvim",
		event = "VeryLazy",
	},
	{
		"folke/neodev.nvim",
		event = "VeryLazy",
	},

	-- TodoComments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			signs = false,
		},
	},

	-- Heirline
	{
		"rebelot/heirline.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-lint",
		},
		config = function()
			require("shl.plugins.heirline")
		end,
	},

	-- Dashboard
}

require("lazy").setup(plugins)
