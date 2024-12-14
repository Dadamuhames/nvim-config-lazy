print("Hello world!");

require("config.lazy");


-- set
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_set_option("clipboard", "unnamed");
vim.api.nvim_set_hl(0, "TSError", { ctermbg=NONE, fg="#ff0000" })  -- Customize the color as needed


-- remap
vim.g.mapleader = " "
vim.keymap.set("n", "--", vim.cmd.Ex)

