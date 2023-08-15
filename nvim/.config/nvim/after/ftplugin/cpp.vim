lua << EOF
local function map(mode, lhs, rhs, opts)
    local options = { noremap=true, silent=true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.lsp.start({
  name = 'C++ LSP: CCLS',
  cmd = {'ccls'},
  root_dir = vim.fn.getcwd(),
})

-- Compile and run cpp file
map('n', 'cpp', ':!c++ -std=c++17 -O3 -g -Wall -Wextra % -o %:r && ./%:r <CR>')
EOF
" End of lua block

let g:neoformat_cpp_astyle = {
            \ 'exe': 'astyled',
            \ 'replace': 1,
            \ 'args': [
                \ '--style=allman',
                \ '-s4',
                \ '--attach-namespaces', '--attach-closing-while',
                \ '--indent-switches', '--indent-namespaces', '--indent-col1-comments',
                \ '--break-blocks', '--break-one-line-headers',
                \ '--pad-oper',
                \ '--align-pointer=name',
                \ '--close-templates']
            \ }

let g:neoformat_enabled_cpp = ['astyle']
