-- [[ Install `lazy.nvim` ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugin Spec ]]
local plugins = {
	require('shl.plugins.catppuccin'),
	require('shl.plugins.lsp'),
	require('shl.plugins.completion'),
	require('shl.plugins.lint'),
	require('shl.plugins.neogit'),
	require('shl.plugins.neorg'),
	require('shl.plugins.telescope'),
	require('shl.plugins.mini'),


	-- Nvim Coding
	{
		'folke/neoconf.nvim',
		event = 'VeryLazy',
	},
	{
		'folke/neodev.nvim',
		event = 'VeryLazy',
	},

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('shl.plugins.treesitter')
		end,
	},

	-- TodoComments
  { 
		'folke/todo-comments.nvim',
		event = 'VimEnter',
		dependencies = { 
			'nvim-lua/plenary.nvim'
		},
		opts = {
			signs = false 
		},
	},

	-- Conform
  { -- Autoformat
		'stevearc/conform.nvim',
		config = function()
		end,
  },

	-- Which-Key
	{
		'folke/which-key.nvim',
		event = 'VimEnter',
		config = function()
			require('shl.plugins.whichkey')
		end,
	},

	-- Heirline
	{
		'rebelot/heirline.nvim',
		lazy = false,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'neovim/nvim-lspconfig',
			'mfussenegger/nvim-lint',
		},
		config = function()
			require('shl.plugins.heirline')
		end,
	},

	-- Dashboard
	{
		'goolord/alpha-nvim',
		lazy = false,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('shl.plugins.alpha')
		end,
	},
}

require("lazy").setup(plugins)
