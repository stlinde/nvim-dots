-- [[ Leader ]]
-- Set <space> as leader key
-- Must be done before loading any plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- [[ Options ]]
-- UI
vim.opt.termguicolors = true
vim.opt.cmdheight = 1 -- Height of cmdline
vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true -- Use relative line numbers
vim.opt.signcolumn = 'yes' -- Show signolumn
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.concealcursor = "nc"
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', }
vim.opt.scrolloff = 10 -- minimal lines to keep above and below cursor
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Functionality
vim.opt.mouse:append("a") -- Enable mouse support in all modes.
vim.opt.clipboard:append("unnamedplus") -- Merge OS and Nvim Clipboard.
vim.opt.undofile = true -- Save undo history to file
vim.opt.undolevels = 10000
vim.opt.updatetime = 250 -- Decrease updatetime
vim.opt.timeout = true -- Enable timeout for which-key.
vim.opt.timeoutlen = 300 -- Set keypress timeout len
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.modifiable = true -- Enable editing in the buffer that you are in
vim.opt.formatoptions = "jcroqlnt" -- See `:help fo-table` for explanation
vim.opt.smoothscroll = true -- Enable smooth scrolling
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.hidden = true -- Enable changing buffers without saving
vim.opt.errorbells = false -- Disable error bells
vim.opt.swapfile = false -- Disable swapfiles
vim.opt.backup = false -- Disable backups
vim.opt.undodir = vim.fn.expand("~/.vim.undodir") -- Where to store undo history.
vim.opt.backspace = "indent,eol,start" -- Make backspace work on eol, indent, and start of line.
vim.opt.autochdir = false -- Don't automatically change directories.
vim.opt.iskeyword:append("-") -- Treat hyphenated words as one.
vim.opt.encoding = "UTF-8" -- Set encoding to "UTF-8".

-- Indentation
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Size of an indent
vim.opt.softtabstop = 2 -- How many spaces is a tab in insert mode

-- Search
vim.opt.incsearch = true -- Show matches while typing
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Unless \C or capital letter in search
vim.opt.hlsearch = true

-- Substitute
vim.opt.inccommand = 'split' -- Preview substitutions live

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
