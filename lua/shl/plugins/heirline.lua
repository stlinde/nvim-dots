local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local icons = {
	-- ✗   󰅖 󰅘 󰅚 󰅙 󱎘 
	close = "󰅙 ",
	dir = "󰉋 ",
	lsp = " ", --   
	vim = " ",
	debug = " ",
	-- err = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
	-- warn = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
	-- info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
	-- hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
}
local separators = {
	rounded_left = "",
	rounded_right = "",
	rounded_left_hollow = "",
	rounded_right_hollow = "",
	powerline_left = "",
	powerline_right = "",
	powerline_right_hollow = "",
	powerline_left_hollow = "",
	slant_left = "",
	slant_right = "",
	inverted_slant_left = "",
	inverted_slant_right = "",
	slant_ur = "",
	slant_br = "",
	vert = "│",
	vert_thick = "┃",
	block = "█",
	double_vert = "║",
	dotted_vert = "┊",
}

local colors = require("catppuccin.utils.colors")

conditions.buffer_not_empty = function()
	return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

conditions.hide_in_width = function(size)
	return vim.api.nvim_get_option_value("columns", { scope = "local" }) > (size or 140)
end

---------------------------------- Components ---------------------------------
local Align = { provider = "%=", hl = { bg = colors.crust } }
local Space = { provider = " " }

local ViMode = {
	{
		init = function(self)
			self.mode = vim.api.nvim_get_mode().mode
			if not self.once then
				vim.api.nvim_create_autocmd("ModeChanged", {
					pattern = "*:*o",
					command = "redrawstatus",
				})
				self.once = true
			end
		end,
		static = {
			MODE_NAMES = {
				["!"] = "SHELL",
				["R"] = "REPLACE",
				["Rc"] = "REPLACE",
				["Rv"] = "V-REPLACE",
				["Rvc"] = "V-REPLACE",
				["Rvx"] = "V-REPLACE",
				["Rx"] = "REPLACE",
				["S"] = "S-LINE",
				["V"] = "V-LINE",
				["Vs"] = "V-LINE",
				["\19"] = "S-BLOCK",
				["\22"] = "V-BLOCK",
				["\22s"] = "V-BLOCK",
				["c"] = "COMMAND",
				["ce"] = "EX",
				["cv"] = "EX",
				["i"] = "INSERT",
				["ic"] = "INSERT",
				["ix"] = "INSERT",
				["n"] = "NORMAL",
				["niI"] = "NORMAL",
				["niR"] = "NORMAL",
				["niV"] = "NORMAL",
				["no"] = "O-PENDING",
				["noV"] = "O-PENDING",
				["no\22"] = "O-PENDING",
				["nov"] = "O-PENDING",
				["nt"] = "NORMAL",
				["ntT"] = "NORMAL",
				["r"] = "REPLACE",
				["r?"] = "CONFIRM",
				["rm"] = "MORE",
				["s"] = "SELECT",
				["t"] = "TERMINAL",
				["v"] = "VISUAL",
				["vs"] = "VISUAL",
			},
			MODE_COLORS = {
				[""] = colors.yellow,
				[""] = colors.yellow,
				["s"] = colors.yellow,
				["!"] = colors.maroon,
				["R"] = colors.flamingo,
				["Rc"] = colors.flamingo,
				["Rv"] = colors.rosewater,
				["Rx"] = colors.flamingo,
				["S"] = colors.teal,
				["V"] = colors.lavender,
				["Vs"] = colors.lavender,
				["c"] = colors.peach,
				["ce"] = colors.peach,
				["cv"] = colors.peach,
				["i"] = colors.green,
				["ic"] = colors.green,
				["ix"] = colors.green,
				["n"] = colors.blue,
				["niI"] = colors.blue,
				["niR"] = colors.blue,
				["niV"] = colors.blue,
				["no"] = colors.pink,
				["no"] = colors.pink,
				["noV"] = colors.pink,
				["nov"] = colors.pink,
				["nt"] = colors.red,
				["null"] = colors.pink,
				["r"] = colors.teal,
				["r?"] = colors.maroon,
				["rm"] = colors.sky,
				["s"] = colors.teal,
				["t"] = colors.red,
				["v"] = colors.mauve,
				["vs"] = colors.mauve,
			},
		},
		provider = function(self)
			local mode = self.mode:sub(1, 1)
			return string.format("▌ %s ", self.MODE_NAMES[mode])
		end,
		hl = function(self)
			local mode = self.mode:sub(1, 1)
			return { fg = self.MODE_COLORS[mode], bg = colors.mantle, bold = true }
		end,
		update = {
			"ModeChanged",
		},
	},
	{
		provider = "",
		hl = { bg = colors.crust, fg = colors.mantle },
	},
}
local FileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	condition = conditions.buffer_not_empty,
	hl = { bg = colors.crust, fg = colors.subtext1 },
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
			vim.fn.fnamemodify(filename, ":t"),
			extension,
			{ default = true }
		)
	end,
	provider = function(self)
		return self.icon and (" %s "):format(self.icon)
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local FileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":t")
		if filename == "" then
			return "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
	hl = { fg = colors.subtext1, bold = true },
}

local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " ● ",
		hl = { fg = colors.lavender },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "",
		hl = { fg = colors.red },
	},
}

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			return { fg = colors.text, bold = true, force = true }
		end
	end,
}

FileNameBlock = utils.insert(
	FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName),
	unpack(FileFlags),
	{ provider = "%< " }
)

local FileType = {
	provider = function()
		return (" %s "):format(vim.bo.filetype)
	end,
	hl = { bg = colors.crust, fg = colors.overlay0 },
	condition = function()
		return conditions.buffer_not_empty() and conditions.hide_in_width()
	end,
}

local FileSize = {
	provider = function()
		local suffix = { "b", "k", "M", "G", "T", "P", "E" }
		local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
		fsize = (fsize < 0 and 0) or fsize
		if fsize < 1024 then
			return string.format(" %s ", fsize .. suffix[1])
		end

		local i = 0
		if fsize ~= nil then
			i = math.floor((math.log(fsize) / math.log(1024)))
		end

		return string.format(" %.2g%s ", fsize / math.pow(1024, i), suffix[i + 1])
	end,
	hl = { bg = colors.crust, fg = colors.overlay0 },
	condition = function()
		return conditions.buffer_not_empty() and conditions.hide_in_width()
	end,
}

local LSPActive = {
	condition = function()
		return conditions.hide_in_width(120) and conditions.lsp_attached()
	end,
	update = { "LspAttach", "LspDetach" },
	on_click = {
		callback = function()
			vim.defer_fn(function()
				vim.cmd("LspInfo")
			end, 100)
		end,
		name = "heirline_LSP",
	},
	provider = function()
		local names = {}
		for _, server in pairs(vim.lsp.get_clients()) do
			table.insert(names, server.name)
		end

		if #names == 0 then
			return ""
		end

		return ("  %s "):format(table.concat(names, " "))
	end,
	hl = { bg = colors.crust, fg = colors.subtext1, bold = true, italic = false },
}

local Linters = {
	provider = function()
		local linters = require("lint")._resolve_linter_by_ft(vim.bo.filetype)

		if #linters == 0 then
			return ""
		end

		return ("  %s "):format(table.concat(linters, " "))
	end,
	hl = { bg = colors.crust, fg = colors.overlay0 },
	condition = function()
		return conditions.buffer_not_empty() and conditions.hide_in_width()
	end,
}

local Formatters = {
	provider = function()
		local formatters = {}
		for _, formatter in pairs(require("conform").list_formatters()) do
			if formatter.available then
				table.insert(formatters, formatter.name)
			end
		end

		if #formatters == 0 then
			return ""
		end

		return ("  %s "):format(table.concat(formatters, " "))
	end,
	on_click = {
		callback = function()
			vim.defer_fn(function() end, 100)
		end,
		name = "heirline_Formatters",
	},
	hl = { bg = colors.crust, fg = colors.overlay0 },
	condition = function()
		return conditions.buffer_not_empty() and conditions.hide_in_width()
	end,
}

-- local Diagnostics = {
-- 	condition = function()
-- 		return conditions.buffer_not_empty() and conditions.hide_in_width() and conditions.has_diagnostics()
-- 	end,
-- 	static = {
-- 		error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
-- 		warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
-- 		info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
-- 		hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
-- 	},
-- 	init = function(self)
-- 		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
-- 		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
-- 		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
-- 		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
-- 	end,
-- 	update = { "DiagnosticChanged", "BufEnter" },
-- 	hl = { bg = colors.crust },
-- 	Space,
-- 	{
-- 		provider = function(self)
-- 			return self.errors > 0 and ("%s%s "):format(self.error_icon, self.errors)
-- 		end,
-- 		hl = { fg = colors.red },
-- 	},
-- 	{
-- 		provider = function(self)
-- 			return self.warnings > 0 and ("%s%s "):format(self.warn_icon, self.warnings)
-- 		end,
-- 		hl = { fg = colors.yellow },
-- 	},
-- 	{
-- 		provider = function(self)
-- 			return self.info > 0 and ("%s%s "):format(self.info_icon, self.info)
-- 		end,
-- 		hl = { fg = colors.sapphire },
-- 	},
-- 	{
-- 		provider = function(self)
-- 			return self.hints > 0 and ("%s%s "):format(self.hint_icon, self.hints)
-- 		end,
-- 		hl = { fg = colors.sky },
-- 	},
-- 	Space,
-- }

local Git = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,
	hl = { bg = colors.mantle },
	{
		provider = "",
		hl = { bg = colors.crust, fg = colors.mantle },
	},
	{
		provider = function(self)
			return ("  %s"):format(self.status_dict.head == "" and "~" or self.status_dict.head)
		end,
		hl = { fg = colors.mauve },
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("  %s"):format(count)
		end,
		hl = { fg = colors.green },
		condition = function()
			return conditions.buffer_not_empty() and conditions.hide_in_width()
		end,
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("  %s"):format(count)
		end,
		hl = { fg = colors.red },
		condition = function()
			return conditions.buffer_not_empty() and conditions.hide_in_width()
		end,
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("  %s"):format(count)
		end,
		hl = { fg = colors.peach },
		condition = function()
			return conditions.buffer_not_empty() and conditions.hide_in_width()
		end,
	},
	Space,
}

----------------------------------- Tabline -----------------------------------

local TablineBufnr = {
	provider = function(self)
		return tostring(self.bufnr) .. ". "
	end,
	hl = "Comment",
}

local TablineFileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":t")
		if self.dupes and self.dupes then
			filename = vim.fn.fnamemodify(self.filename, ":h:t") .. "/" .. filename
		end
		filename = filename == "" and "[No Name]" or filename
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active or self.is_visible, italic = true }
	end,
}

local TablineFileFlags = {
	{
		condition = function(self)
			return vim.api.nvim_buf_get_option(self.bufnr, "modified")
		end,
		provider = " ● ", --"[+]",
		hl = { fg = "green" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
				or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
		end,
		provider = function(self)
			if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
				return "  "
			else
				return ""
			end
		end,
		hl = { fg = "orange" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_buf_is_loaded(self.bufnr)
		end,
		-- a downright arrow
		provider = " 󰘓 ", --󰕁 
		hl = { fg = "gray" },
	},
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
		elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
			return { fg = "gray" }
		else
			return "TabLine"
		end
	end,
	on_click = {
		callback = function(self, minwid, nclicks)
			if nclicks == 1 then
				vim.api.nvim_win_set_buf(0, minwid)
			elseif nclicks == 2 then
				if vim.t.winrestcmd then
					vim.cmd(vim.t.winrestcmd)
					vim.t.winrestcmd = nil
				else
					vim.t.winrestcmd = vim.fn.winrestcmd()
					vim.cmd.wincmd("|")
					vim.cmd.wincmd("_")
				end
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_buffer_callback",
	},
	TablineBufnr,
	FileIcon,
	TablineFileName,
	TablineFileFlags,
}

local TablineCloseButton = {
	condition = function(self)
		-- return not vim.bo[self.bufnr].modified
		return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
	end,
	{ provider = " " },
	{
		provider = icons.close,
		hl = { fg = "gray" },
		on_click = {
			callback = function(_, minwid)
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
					vim.cmd.redrawtabline()
				end)
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = "heirline_tabline_close_buffer_callback",
		},
	},
}

local TablinePicker = {
	condition = function(self)
		return self._show_picker
	end,
	init = function(self)
		local bufname = vim.api.nvim_buf_get_name(self.bufnr)
		bufname = vim.fn.fnamemodify(bufname, ":t")
		local label = bufname:sub(1, 1)
		local i = 2
		while self._picker_labels[label] do
			label = bufname:sub(i, i)
			if i > #bufname then
				break
			end
			i = i + 1
		end
		self._picker_labels[label] = self.bufnr
		self.label = label
	end,
	provider = function(self)
		return self.label
	end,
	hl = { fg = "red", bold = true },
}

vim.keymap.set("n", "gbp", function()
	local tabline = require("heirline").tabline
	local buflist = tabline._buflist[1]
	buflist._picker_labels = {}
	buflist._show_picker = true
	vim.cmd.redrawtabline()
	local char = vim.fn.getcharstr()
	local bufnr = buflist._picker_labels[char]
	if bufnr then
		vim.api.nvim_win_set_buf(0, bufnr)
	end
	buflist._show_picker = false
	vim.cmd.redrawtabline()
end)

local TablineBufferBlock = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { TablinePicker, TablineFileNameBlock, TablineCloseButton })

local get_bufs = function()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_get_option(bufnr, "buflisted")
	end, vim.api.nvim_list_bufs())
end

local buflist_cache = {}

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
	callback = function(args)
		vim.schedule(function()
			local buffers = get_bufs()
			for i, v in ipairs(buffers) do
				buflist_cache[i] = v
			end
			for i = #buffers + 1, #buflist_cache do
				buflist_cache[i] = nil
			end

			if #buflist_cache > 1 then
				vim.o.showtabline = 2
			elseif vim.o.showtabline ~= 1 then --otheriwise it breaks startup screen
				vim.o.showtabline = 1
			end
		end)
	end,
})

local BufferLine = utils.make_buflist(
	TablineBufferBlock,
	{ provider = " ", hl = { fg = "gray" } },
	{ provider = " ", hl = { fg = "gray" } },
	function()
		return buflist_cache
	end,
	false
)

local Tabpage = {
	{
		provider = function(self)
			return " %" .. self.tabnr .. "T" .. self.tabnr .. " "
		end,
		hl = { bold = true },
	},
	{
		provider = function(self)
			local n = #vim.api.nvim_tabpage_list_wins(self.tabpage)
			return n .. "%T "
		end,
		hl = { fg = "gray" },
	},
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
	update = { "TabNew", "TabClosed", "TabEnter", "TabLeave", "WinNew", "WinClosed" },
}

local TabpageClose = {
	provider = " %999X" .. icons.close .. "%X",
	hl = "TabLine",
}

local TabPages = {
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{
		provider = "%=",
	},
	utils.make_tablist(Tabpage),
	TabpageClose,
}

local TabLineOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		local bufnr = vim.api.nvim_win_get_buf(win)
		self.winid = win

		if vim.api.nvim_buf_get_option(bufnr, "filetype") == "neo-tree" then
			self.title = "NeoTree"
			return true
		end
	end,
	provider = function(self)
		local title = self.title
		local width = vim.api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,
	hl = function(self)
		if vim.api.nvim_get_current_win() == self.winid then
			return "TablineSel"
		else
			return "Tabline"
		end
	end,
}

-- vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
-- 	callback = function(args)
-- 		local counts = {}
-- 		local dupes = {}
-- 		local names = vim.tbl_map(function(bufnr)
-- 			return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
-- 		end, get_bufs())
-- 		for _, name in ipairs(names) do
-- 			counts[name] = (counts[name] or 0) + 1
-- 		end
-- 		for name, count in pairs(counts) do
-- 			if count > 1 then
-- 				dupes[name] = true
-- 			end
-- 		end
-- 		require("heirline").tabline.dupes = dupes
-- 	end,
-- })

local TabLine = {
	TabLineOffset,
	BufferLine,
	TabPages,
}

vim.o.laststatus = 3
vim.o.showcmdloc = "statusline"

----------------------------------- Finalize ----------------------------------
heirline.setup({
	statusline = {
		ViMode,
		FileNameBlock,
		FileType,
		FileSize,
		Align,
		LSPActive,
		Linters,
		Formatters,
		-- Diagnostics,
		Git,
	},
	-- tabline = TabLine,
})
