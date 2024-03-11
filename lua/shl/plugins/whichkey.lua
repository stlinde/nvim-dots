-- [[ Install ]]
local M = { "folke/which-key.nvim" }
M.event = "VeryLazy"

function M.config()
	local whichkey = require("which-key")
	whichkey.setup()
	whichkey.register({
		["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
		["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
		["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
		["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
		["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
	})
end

return M
