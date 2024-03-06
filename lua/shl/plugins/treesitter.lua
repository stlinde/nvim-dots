local treesitter_status, treesitter = pcall(require, 'treesitter')

require('nvim-treesitter.configs').setup {
	ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'python' },
	-- Autoinstall languages that are not installed
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
}
