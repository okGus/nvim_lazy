-- plugins/telescope.lua:
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find Git Files"})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep >")});
        end, { desc = "Grep String" })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find in Files" })
    end,
}
