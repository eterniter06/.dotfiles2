return{
    'akinsho/flutter-tools.nvim',
    --lazy = false,
    ft = "dart",
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Make dart load before
        'dart-lang/dart-vim-plugin',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
}
