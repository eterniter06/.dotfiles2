set formatprg=clangformat
lua << EOF
local function map(mode, lhs, rhs, opts)
    local options = { noremap=true, silent=true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Compile and run cpp file
map('n', 'cpp', ':!c++ -std=c++17 -O3 -g -Wall -Wextra % -o %:r && ./%:r <CR>')

EOF
" End of lua block
