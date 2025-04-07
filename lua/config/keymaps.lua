--vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- select a section of text and move the text
-- keeping the text context pretty cool
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- to comment or uncomment, Ctrl-c to Esc instead of using Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

--Nvimtree
--vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

-- Search and replace
-- global search and replace
vim.keymap.set("n", "<leader>sr", ":%s/", { noremap = true } )
-- search with in function and replace
vim.keymap.set("n", "<leader>sf", ":.,/}/s/", { noremap = true } )

-- Indent with Tab and un-indent with Shift + Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

