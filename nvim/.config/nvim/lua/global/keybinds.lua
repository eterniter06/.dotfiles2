-- Credits: https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/keymaps.lua

local function map(mode, lhs, rhs, opts)
    local options = { noremap=true, silent=true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Use leader as spacebar
vim.g.mapleader = ' '

-- jk to Escape in insert mode
map('i', 'jk', '<Esc>')

-- Window focus
map('n', '<C-j>', '<C-W><C-j>')
map('n', '<C-k>', '<C-W><C-k>')
map('n', '<C-l>', '<C-W><C-l>')
map('n', '<C-h>', '<C-W><C-h>')

-- Centered page up and page down
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- Centred searching
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Clipboard copy and paste
map('n', 'yc', '"+y')
map('n', 'yp', '"+p')
map('v', 'yc', '"+y')
map('v', 'yp', '"+p')

-- Source init file on change
-- Todo: Make this only work on config files
map('n', '<leader>r', ':source %<Cr>')
