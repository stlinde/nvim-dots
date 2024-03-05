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
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('shl.plugins.tokyonight')
			vim.cmd('colorscheme tokyonight')
		end,
	},
	{
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			require('shl.plugins.mini')
		end,
	},
}

require("lazy").setup(plugins)
