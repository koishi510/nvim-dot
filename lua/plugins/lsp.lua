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
        "elmls",
        "gopls",
        "html",
        "cssls",
        "lua_ls",
        "matlab_ls",
        "basedpyright",
        "rust_analyzer",
        "texlab",
        "verible",
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
      local util = require("lspconfig.util")
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

      local function root_pattern(...)
        local matcher = util.root_pattern(...)

        return function(fname)
          return matcher(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end
      end

      local servers = {
        bashls = {
          root_dir = root_pattern(".git", "Makefile"),
        },
        clangd = {
          root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".clangd", "CMakeLists.txt", ".git"),
        },
        gopls = {
          root_dir = root_pattern("go.work", "go.mod", ".git"),
        },
        html = {
          root_dir = root_pattern("package.json", ".git"),
        },
        cssls = {
          root_dir = root_pattern("package.json", ".git"),
        },
        elmls = {
          root_dir = root_pattern("elm.json", ".git"),
        },
        lua_ls = {
          root_dir = root_pattern(".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", "lua", ".git"),
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
        matlab_ls = {
          root_dir = root_pattern("matlab.prj", "startup.m", "Contents.m", ".git"),
        },
        basedpyright = {
          root_dir = root_pattern(
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git"
          ),
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        jsonls = {
          root_dir = root_pattern("package.json", ".git"),
        },
        rust_analyzer = {
          root_dir = root_pattern("Cargo.toml", "rust-project.json", ".git"),
        },
        texlab = {
          root_dir = root_pattern(".latexmkrc", "latexmkrc", ".git"),
        },
        verible = {
          root_dir = root_pattern(".svlangserver", ".svlint.toml", "verible.filelist", "filelist.f", "files.f", ".git"),
        },
        vtsls = {
          root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
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
        vue_ls = {
          root_dir = root_pattern("package.json", "vue.config.js", "vite.config.ts", "vite.config.js", ".git"),
        },
        yamlls = {
          root_dir = root_pattern(".yamllint", ".yamllint.yaml", ".yamllint.yml", ".git"),
        },
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
