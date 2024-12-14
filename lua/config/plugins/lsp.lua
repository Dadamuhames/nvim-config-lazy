return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "nvim-java/nvim-java" },
			{ "elmcgill/springboot-nvim", dependencies = { "mfussenegger/nvim-jdtls" } },
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
				-- used for completion, annotations and signatures of Neovim apis
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			{ "Bilal2453/luvit-meta", lazy = true },
			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local lspconfig = require("lspconfig")

			lspconfig.pylsp.setup({
				settings = {
					python = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportIncompatibleVariableOverride = "none",
							},
						},
					},
				},
			})

			require("java").setup()

			lspconfig.jdtls.setup({})
			lspconfig.gopls.setup({})
			lspconfig.ts_ls.setup({})
			lspconfig.sqls.setup({
				settings = {
					sqls = {
						connections = {
							{
								driver = "mysql",
								dataSourceName = "root:root_pass@tcp(127.0.0.1:3306)/sqlsdb",
							},
						},
					},
				},
			})

			local springboot_nvim = require("springboot-nvim")
			vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
			vim.keymap.set("n", "<leader>jc", springboot_nvim.generate_class, { desc = "Java Create Class" })
			vim.keymap.set("n", "<leader>ji", springboot_nvim.generate_interface, { desc = "Java Create Interface" })
			vim.keymap.set("n", "<leader>je", springboot_nvim.generate_enum, { desc = "Java Create Enum" })

			springboot_nvim.setup({})

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})
		end,
	},
}
