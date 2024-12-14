return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local s = luasnip.snippet
			local t = luasnip.text_node
			local f = luasnip.function_node

			-- lua snips
			local function get_file_name()
				local full_path = vim.fn.expand("%:t:r") -- Get the file name without extension
				if full_path == "" then
					return "UnnamedClass"
				end
				return full_path
			end

			-- Utility function to determine the package based on the file path
			local function get_package_name()
				local full_path = vim.fn.expand("%:p:h") -- Get the directory path
				local src_index = full_path:find("src/main/java/")
				if src_index then
					local package_path = full_path:sub(src_index + 14):gsub("/", ".")
					return package_path
				end
				return "default.package" -- Default if no package path is found
			end

			-- Add the Java class snippet
			luasnip.add_snippets("java", {
				s("class", {
					f(function()
						return "package " .. get_package_name() .. ";"
					end, {}),
					t({ "", "", "public class " }),
					f(function()
						return get_file_name()
					end, {}),
					t({ " {", "", "}" }),
				}),
			})

			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				sources = {
					{
						name = "lazydev",
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "cmp-lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},
}
