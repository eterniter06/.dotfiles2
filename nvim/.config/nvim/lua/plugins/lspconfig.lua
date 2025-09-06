return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
            require'lspconfig'.clangd.setup{
                cmd = {
                    "clangd",
                    "--cross-file-rename",
                    "--clang-tidy"
                }
            }
        end
    }
}
