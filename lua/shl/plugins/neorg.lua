-- [[ Install ]]
local M = { 'nvim-neorg/neorg' }
-- M.event = 'VimEnter'
M.lazy = false
M.build = ':Neorg sync-parsers'
M.dependencies = {
	'nvim-lua/plenary.nvim',
	'nvim-neorg/neorg-telescope',
	'hrsh7th/nvim-cmp',
	'nvim-treesitter/nvim-treesitter',
}

local nmap_leader_neorg = function(lhs, rhs, desc)
	vim.keymap.set('n', '<leader>n' .. lhs, rhs, { desc = desc })
end

-- [[ Configuration ]]
function M.config()

	nmap_leader_neorg('i', '<cmd>cd ~/notes/<cr><cmd>Neorg index<cr>', '[N]eorg [I]ndex')
	nmap_leader_neorg('J', '<cmd>Neorg journal<cr>', '[N]eorg [J]ournal')

	require("neorg").setup({
		load = {
			["core.defaults"] = {}, -- Loads default behaviour
			["core.concealer"] = {}, -- Adds pretty icons to your documents
			["core.keybinds"] = {}, -- Adds default keybindings
			["core.summary"] = {}, -- Adds index generation support
			["core.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			}, -- Enables support for completion plugins
			["core.journal"] = {}, -- Enables support for the journal module
			["core.esupports.metagen"] = {
				config = {
					type = "auto",
				},
			},
			["core.dirman"] = { -- Manages Neorg workspaces
				config = {
					workspaces = {
						notes = "~/norg",
					},
					default_workspace = "notes",
				},
			},
		},
	})
end


return M
