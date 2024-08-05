-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>i", "<cmd>bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>o", "<cmd>bp<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half screen" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next word" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous word" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without replace register" })

vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true })

vim.keymap.set("v", "<leader>fj", ":!jq .<CR>", { desc = "Format JSON in visual mode" })
vim.keymap.set("x", "<leader>fj", ":!jq .<CR>", { desc = "Format JSON in visual line mode" })

-- For insert mode
vim.keymap.set("n", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to pane below" })
vim.keymap.set("n", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to pane above" })
vim.keymap.set("n", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right pane" })

vim.keymap.set("i", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left pane" })
vim.keymap.set("i", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to pane below" })
vim.keymap.set("i", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to pane above" })
vim.keymap.set("i", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right pane" })
