return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "gopls",
        "html",
        "cssls",
        "lua_ls",
        "basedpyright",
        "rust_analyzer",
        "texlab",
        "vtsls",
        "vue_ls",
        "jsonls",
        "yamlls",
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      height = 18,
      border = {
        enable = true,
        top_char = " ",
        bottom_char = " ",
      },
      list = {
        position = "right",
        width = 0.33,
      },
    },
    keys = {
      { "gd", "<cmd>Glance definitions<cr>", desc = "Definitions" },
      { "gr", "<cmd>Glance references<cr>", desc = "References" },
      { "gs", "<cmd>Glance implementations<cr>", desc = "Implementations" },
      { "gy", "<cmd>Glance type_definitions<cr>", desc = "Type definitions" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gK", vim.lsp.buf.hover, "Hover docs")
        map("n", "<leader>sd", vim.lsp.buf.document_symbol, "Document symbols")
        map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>f", function()
          local ok, conform = pcall(require, "conform")
          if ok then
            conform.format({ async = true, lsp_fallback = true, bufnr = bufnr })
            return
          end

          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end

      local servers = {
        bashls = {},
        clangd = {},
        gopls = {},
        html = {},
        cssls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        jsonls = {},
        rust_analyzer = {},
        texlab = {},
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  vue_plugin,
                },
              },
            },
          },
        },
        vue_ls = {},
        yamlls = {},
      }

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = capabilities
            server.on_attach = on_attach
            lspconfig[server_name].setup(server)
          end,
        },
      })

      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
        },
      })
    end,
  },
}
