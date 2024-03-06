-- [[ MiniFiles ]]
local files_status, files = pcall(require, 'mini.files')
files.setup()

-- [[ MiniBufremove ]]
local bufremove_status, bufremove = pcall(require, 'mini.bufremove')
bufremove.setup()

-- [[ MiniComment ]]
local comment_status, comment = pcall(require, 'mini.comment')
comment.setup()

-- [[ MiniSurround ]]
local surround_status, surround = pcall(require, 'mini.surround')
surround.setup()

-- [[ MiniAi ]]
local ai_status, ai = pcall(require, 'mini.ai')
ai.setup()
