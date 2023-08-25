nnoremap gcc :!gcc -std=c17 -O3 -g -Wall -Wextra % -o %:r && ./%:r <CR>

let g:neoformat_c_astyle = {
            \ 'exe': 'astyled',
            \ 'replace': 1,
            \ 'args': [
                \ '--style=allman', 
                \ '-s4', 
                \ '--attach-namespaces', '--attach-closing-while', 
                \ '--indent-switches', '--indent-col1-comments', 
                \ '--break-blocks', '--break-one-line-headers',
                \ '--pad-oper', 
                \ '--align-pointer=name', 
                \ '--remove-braces'
                \ ]
            \ }

let g:neoformat_enabled_c = ['astyle']
