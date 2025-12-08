return {
  -- Mason: LSP installer
  {
    "williamboman/mason.nvim",
    opts = {},
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
      { "gd",         vim.lsp.buf.definition,     { noremap = true, silent = true }, desc = "Go to definition" },
      { "gD",         vim.lsp.buf.declaration,    { noremap = true, silent = true }, desc = "Go to declaration" },
      { "gi",         vim.lsp.buf.implementation, { noremap = true, silent = true }, desc = "Go to impl" },
      { "gr",         vim.lsp.buf.references,     { noremap = true, silent = true }, desc = "Go to refs" },
      { "<C-k>",      vim.lsp.buf.signature_help, { noremap = true, silent = true }, desc = "Signature help" },
      { "<leader>ck", vim.lsp.buf.hover,          { noremap = true, silent = true }, desc = "Hover Action" },
      { "<leader>cn", vim.lsp.buf.rename,         { noremap = true, silent = true }, desc = "Rename symbol" },
      { "<leader>ca", vim.lsp.buf.code_action,    { noremap = true, silent = true }, desc = "Code Action" },
      {
        "<leader>cf",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        { noremap = true, silent = true },
        desc = "Format code",
      },
    },

    config = function()
      -- Setup clangd with Chromium defaults
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--cross-file-rename",
          "--clang-tidy",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Enable inlay hints for type hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
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
      vim.lsp.enable('nushell')

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      -- for _, ls in ipairs(language_servers) do
      -- 	require("lspconfig")[ls].setup({
      -- 		capabilities = capabilities,
      -- 		-- you can add other fields for setting up lsp server in this table
      -- 	})
      -- end
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
