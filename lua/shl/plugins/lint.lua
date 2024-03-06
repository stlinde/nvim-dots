local M = { 'mfussenegger/nvim-lint' }

M.dependencies = {
	'williamboman/mason.nvim',
}

M.lazy = false

function M.config()
	require("lint").linters_by_ft = {
		bash = { "shellcheck" },
		dockerfile = { "hadolint" },
		fish = { "fish" },
		sh = { "shellcheck" },
		yaml = { "yamllint", "actionlint" },
		zsh = { "shellcheck" },
		NeogitCommitMessage = { "alex" },
		markdown = { "alex" },
		python = { "ruff" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("Linting", { clear = true }),
		callback = function()
			require("lint").try_lint()
		end,
	})
end

return M
