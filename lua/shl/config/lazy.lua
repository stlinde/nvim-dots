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
	-- UI
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('shl.plugins.tokyonight')
			vim.cmd('colorscheme tokyonight')
		end,
	},

	require('shl.plugins.lsp'),
	require('shl.plugins.completion'),
	require('shl.plugins.lint'),
	require('shl.plugins.statusline'),
	require('shl.plugins.neogit'),

	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-ui-select.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make', -- run make when plugin is installed/updated
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
		config = function()
			require('shl.plugins.telescope')
		end,
	},

	-- Nvim Coding
	{
		'folke/neoconf.nvim',
		event = 'VeryLazy',
	},
	{
		'folke/neodev.nvim',
		event = 'VeryLazy',
	},

	-- Mini
	{
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			require('shl.plugins.mini')
		end,
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
	-- {
	-- 	'rebelot/heirline.nvim',
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		'nvim-tree/nvim-web-devicons',
	-- 		'neovim/nvim-lspconfig',
	-- 		'mfussenegger/nvim-lint',
	-- 	},
	-- 	config = function()
	-- 		require('shl.plugins.heirline')
	-- 	end,
	-- },

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
