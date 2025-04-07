return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Open Git Status" })
    end,
}

--vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
