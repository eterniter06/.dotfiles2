local set = vim.opt

-- Tabstop settings: Use 4 spaces for tab by default
set.tabstop = 4
set.shiftwidth = 4
set.expandtab = true

-- Conceal level
set.conceallevel = 2

-- Set update time to 1s (Default is 4)
-- Duration before swap file is written
set.updatetime = 2000

-- 24 bit RGB TUI
set.termguicolors = true

-- New windows open below and to the right
set.splitbelow = true
set.splitright = true

-- Show line numbering
set.relativenumber = true
set.number = true

-- Briefly display matching bracket
set.showmatch = true

-- autocomplete for menu and command
set.wildmenu = true
set.wildoptions = pum,fuzzy
set.wildmode = "list:longest,full"

-- LSP diagnostics symbols
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Mark current line in insert mode
-- TODO: Modify to show different markings for insert and normal mode
vim.cmd([[
    :autocmd InsertEnter,InsertLeave * set cul!
]])
