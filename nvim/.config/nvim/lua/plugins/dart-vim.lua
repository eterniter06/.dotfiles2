return {
    'dart-lang/dart-vim-plugin',
    ft = 'dart',

    -- style guide sets indentation space and other recommended dart-styling
    config = function()
        vim.cmd([[
            let g:dart_html_in_string = v:true
            let g:dart_style_guide = 2
            let g:dart_format_on_save = v:true
        ]])
    end
}
