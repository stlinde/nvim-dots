-- [[ Install ]]
local M = { 'nvim-treesitter/nvim-treesitter' }
M.event = 'VeryLazy'
M.build = ':TSUpdate'

-- [[ Config ]]
function M.config()
	require('nvim-treesitter.configs').setup {
		ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'python' },
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	}
end

return M
