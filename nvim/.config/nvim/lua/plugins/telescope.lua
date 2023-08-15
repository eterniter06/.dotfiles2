-- fzf settings
local fzf = {
  fuzzy = true,                    -- false will only do exact matching
  override_generic_sorter = true,  -- override the generic sorter
  override_file_sorter = true,     -- override the file sorter
  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                   -- the default case_mode is "smart_case"
}

-- Telescope along with extensions
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },
    config = function()
        -- Investigate if required
        require('telescope').load_extension('fzf')

        local builtin = require('telescope.builtin')

        -- Some keymaps
        vim.keymap.set('n', '<C-p>f', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>g', builtin.git_files, {})
        vim.keymap.set('n', '<C-p>r', builtin.live_grep, {})
        vim.keymap.set('n', '<C-p>b', builtin.buffers, {})
        vim.keymap.set('n', '<C-p>h', builtin.help_tags, {})
    end
}
