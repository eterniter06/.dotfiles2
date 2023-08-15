return{
    'akinsho/flutter-tools.nvim',
    --lazy = false,
    ft = "dart",
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Make dart load before
        -- 'dart-lang/dart-vim-plugin',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup {} -- use defaults
        require("telescope").load_extension("flutter")

        vim.keymap.set('n', '<C-p>', function ()
            vim.cmd("Telescope flutter commands")
            end
        )

        vim.keymap.set('n', '<F5>', function () vim.cmd("FlutterRun")
            end
        )

        -- Shift + F5 is rendered as F17 in kitty
        vim.keymap.set('n', '<F17>', function () vim.cmd("FlutterQuit")
            end
        )
    end
}
