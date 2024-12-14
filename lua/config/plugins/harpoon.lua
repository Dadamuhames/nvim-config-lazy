return {
	{
		"nvim-lua/plenary.nvim",
		dependencies = { "ThePrimeagen/harpoon" },
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<C-a>", mark.add_file)
			vim.keymap.set("n", "<C-i>", ui.toggle_quick_menu)

			vim.keymap.set("n", "<C-q>", ui.nav_next)
			vim.keymap.set("n", "<C-S-q>", ui.nav_prev)
		end,
	},
}
