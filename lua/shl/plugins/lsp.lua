local M = {'neovim/nvim-lspconfig'}

M.dependencies = {
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	{
		'j-hui/fidget.nvim', opts = {},
	},
}

local function lsp_attach_callback(event)
end

function M.config()
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc)
				vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
			end

			map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
			map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
			map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
			map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
			map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
			map('K', vim.lsp.buf.hover, 'Hover Documentation')
			map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})

	-- LSP servers and clients are able to communicate to each other what features they support.
	--  By default, Neovim doesn't support everything that is in the LSP Specification.
	--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
	--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

	-- Enable the following language servers
	--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	--
	--  Add any additional override configuration in the following tables. Available keys are:
	--  - cmd (table): Override the default command used to start the server
	--  - filetypes (table): Override the default list of associated filetypes for the server
	--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
	--  - settings (table): Override the default settings passed when initializing the server.
	--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
	local servers = {
		clangd = {},
		zls = {},
		pyright = {},
		lua_ls = {
			-- cmd = {...},
			-- filetypes { ...},
			-- capabilities = {},
			settings = {
				Lua = {
					runtime = { version = 'LuaJIT' },
					workspace = {
						checkThirdParty = false,
						-- Tells lua_ls where to find all the Lua files that you have loaded
						-- for your neovim configuration.
						library = {
							'${3rd}/luv/library',
							unpack(vim.api.nvim_get_runtime_file('', true)),
						},
					},
					completion = {
						callSnippet = 'Replace',
					},
					-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
		},
	}
	-- Ensure the servers and tools above are installed
	--  To check the current status of installed tools and/or manually install
	--  other tools, you can run
	--    :Mason
	--
	--  You can press `g?` for help in this menu
	require('mason').setup()

	-- You can add other tools here that you want Mason to install
	-- for you, so that they are available from within Neovim.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		'stylua', -- Used to format lua code
		'ruff',
		'black',
	})
	require('mason-tool-installer').setup { ensure_installed = ensure_installed }

	require('mason-lspconfig').setup {
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for tsserver)
				server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
				require('lspconfig')[server_name].setup(server)
			end,
		},
	}
end

return M
