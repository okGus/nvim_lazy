--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('nvim-tree').setup()
        vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle File Explorer" })
    end,
}
