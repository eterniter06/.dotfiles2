nnoremap gcc :!gcc -std=c17 -O3 -g -Wall -Wextra % -o %:r && ./%:r <CR>

set formatprg=clangformat
