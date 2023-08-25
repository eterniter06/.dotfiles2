return {
    {
        'vim-airline/vim-airline',
        lazy = false,
        config = function()
            vim.cmd([[
                let g:airline#extensions#tagbar#flags = 'f'
                let g:airline#extensions#tabline#enabled = 1
                let g:airline#extensions#tabline#fnamemod = ':t'

                let g:airline_powerline_fonts = 1

                if !exists('g:airline_symbols')
                    let g:airline_symbols = {}
                endif

                " unicode symbols
                let g:airline_left_sep = '»'
                let g:airline_left_sep = '▶'
                let g:airline_right_sep = '«'
                let g:airline_right_sep = '◀'
                let g:airline_symbols.colnr = ' ㏇:'
                let g:airline_symbols.colnr = ' ℅:'
                let g:airline_symbols.crypt = '🔒'
                let g:airline_symbols.linenr = '☰'
                let g:airline_symbols.linenr = ' ␊:'
                let g:airline_symbols.linenr = ' ␤:'
                let g:airline_symbols.linenr = '¶'
                let g:airline_symbols.maxlinenr = ''
                let g:airline_symbols.maxlinenr = '㏑'
                let g:airline_symbols.branch = '⎇'
                let g:airline_symbols.paste = 'ρ'
                let g:airline_symbols.paste = 'Þ'
                let g:airline_symbols.paste = '∥'
                let g:airline_symbols.spell = 'Ꞩ'
                let g:airline_symbols.notexists = 'Ɇ'
                let g:airline_symbols.notexists = '∄'
                let g:airline_symbols.whitespace = 'Ξ'

                " powerline symbols
                let g:airline_left_sep = ''
                let g:airline_left_alt_sep = ''
                let g:airline_right_sep = ''
                let g:airline_right_alt_sep = ''
                let g:airline_symbols.branch = ''
                let g:airline_symbols.colnr = ' ℅:'
                let g:airline_symbols.readonly = ''
                let g:airline_symbols.linenr = ' :'
                let g:airline_symbols.maxlinenr = '☰ '
                let g:airline_symbols.dirty='⚡'
            ]])
        end
    },
    {
        'vim-airline/vim-airline-themes',
        lazy = false,
        config = function()
            vim.cmd([[
                let g:airline_theme = 'dracula'
            ]])
        end
    }
}
