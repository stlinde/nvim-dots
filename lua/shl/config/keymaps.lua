-- [[ Mini Files ]]
vim.keymap.set('n', '<leader>ec', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<CR>', { desc = 'Config' })
vim.keymap.set('n', '<leader>ed', '<Cmd>lua MiniFiles.open()<CR>', { desc = 'Directory' })
vim.keymap.set('n', '<leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'File directory' })
vim.keymap.set('n', '<leader>ei', '<Cmd>edit $MYVIMRC<CR>', { desc = 'File directory' })
vim.keymap.set('n', '<leader>em', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/start/mini.nvim")<CR>', { desc = 'Mini.nvim directory' })
vim.keymap.set('n', '<leader>ep', '<Cmd>lua MiniFiles.open(vim.fn.stdpath("data").."/site/pack/deps/opt")<CR>', { desc = 'Plugins directory' })
vim.keymap.set('n', '<leader>eq', '<Cmd>lua Config.toggle_quickfix()<CR>', { desc = 'Quickfix' })
