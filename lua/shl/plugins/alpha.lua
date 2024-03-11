-- [[ Install ]]
local M = { "goolord/alpha-nvim" }
M.event = "VimEnter"
M.dependencies = {
	"nvim-tree/nvim-web-devicons",
	"nvim-lua/plenary.nvim",
}

local header = {
	"           ▄ ▄                   ",
	"       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
	"       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
	"    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
	"  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
	"  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
	"▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
	"█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
	"    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
}

function M.config()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	-- Set header
	dashboard.section.header.val = header

	-- Set footer
	local fortune = require("alpha.fortune")
	dashboard.section.footer.val = fortune()

	-- Set menu
	dashboard.section.buttons.val = {
		dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
		dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
		dashboard.button("n", "  > Journal", ":Neorg journal today<CR>"),
		dashboard.button("s", "  > Settings", ":cd $MYVIMRC | Telescope find_files<CR>"),
		dashboard.button("q", "󰩈  > Quit NVIM", ":qa<CR>"),
	}

	-- Send config to alpha
	alpha.setup(dashboard.opts)

	-- Disable folding on alpha buffer
	vim.cmd([[
		autocmd FileType alpha setlocal nofoldenable
	]])
end

return M
