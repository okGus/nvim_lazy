return {
    'mbbill/undotree',
    config = function()
        vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
    end,
}

--vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
