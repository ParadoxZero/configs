return {
	-- Mason: LSP installer
	{
		"mason-org/mason.nvim",
		opts = {},
		lazy = true,
		config = function()
			require("mason").setup({
				-- Optional configuration options
				ensure_installed = { "" }, -- add more lsp server if you want more language
				automatic_installation = true,
			})
		end,
	},
	-- Mason-lspconfig: Bridge between mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		opts = {
			automatic_installation = true,
		},
	},
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "gd", vim.lsp.buf.definition, { noremap = true, silent = true }, desc = "Go to definition" },
			{ "gD", vim.lsp.buf.declaration, { noremap = true, silent = true }, desc = "Go to declaration" },
			{ "gi", vim.lsp.buf.implementation, { noremap = true, silent = true }, desc = "Go to impl" },
			{ "gr", vim.lsp.buf.references, { noremap = true, silent = true }, desc = "Go to refs" },
			{ "<<Leader>cs", vim.lsp.buf.signature_help, { noremap = true, silent = true }, desc = "Signature help" },
			{ "<leader>ck", vim.lsp.buf.hover, { noremap = true, silent = true }, desc = "Hover Action" },
			{ "<leader>cn", vim.lsp.buf.rename, { noremap = true, silent = true }, desc = "Rename symbol" },
			{ "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true }, desc = "Code Action" },
			-- {
			-- 	"<leader>cf",
			-- 	function()
			-- 		vim.lsp.buf.format({ async = true })
			-- 	end,
			-- 	{ noremap = true, silent = true },
			-- 	desc = "Format code",
			-- },
		},
		config = function()
			-- Setup clangd with Chromium defaults
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index=false",
          "--j=2",
          "--pch-storage=disk",
          "--limit-results=20",
					"--enable-config",
          "--clang-tidy=false",
          "--header-insertion=never",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
				capabilities = capabilities,
			})
			vim.lsp.config("emmylua_ls", {
				-- Make the server aware of Neovim runtime files
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "strict",
							reportUnusedImport = "warning",
							reportUnusedVariable = "warning",
						},
					},
				},
			})

			vim.lsp.enable("clangd")
			vim.lsp.enable("emmylua_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("nushell")
			vim.lsp.enable("biome")

			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
			-- for _, ls in ipairs(language_servers) do
			-- 	require("lspconfig")[ls].setup({
			-- 		capabilities = capabilities,
			-- 		-- you can add other fields for setting up lsp server in this table
			-- 	})
			-- end
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client.name == "clangd" then
						require("which-key").add({
							{
								"<leader>ch",
								"<cmd>LspClangdSwitchSourceHeader<cr>",
								desc = "Switch src/header",
							},
						})
					end
				end,
			})
		end,
	},
	{
		"saghen/blink.cmp",
    version = '1.*',
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "super-tab" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				documentation = { auto_show = false },
        menu = {
          border = "rounded",
        }
			},
		},
		opts_extend = { "sources.default" },
	},
	-- Formatter
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black", "autopep8" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					json = { "biome" },
					jsonc = { "biome" },
					cpp = { "clang-format", lsp_format = "fallback" },
					go = { "gofmt" },
				},
			})
			require("which-key").add({
				{
					"<Leader>cf",
					function()
						require("conform").format()
					end,
					{ noremap = true, silent = true },
					desc = "Format Buffer",
				},
			})
		end,
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		enabled = false,
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
