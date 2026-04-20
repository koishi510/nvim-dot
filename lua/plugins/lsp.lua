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
        "docker_compose_language_service",
        "dockerls",
        "elmls",
        "emmet_language_server",
        "gopls",
        "html",
        "cssls",
        "lua_ls",
        "matlab_ls",
        "neocmake",
        "basedpyright",
        "rust_analyzer",
        "sqlls",
        "tailwindcss",
        "taplo",
        "texlab",
        "verible",
        "vtsls",
        "vue_ls",
        "jsonls",
        "yamlls",
      },
      automatic_enable = false,
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
      { "<leader>jd", "<cmd>Glance definitions<cr>", desc = "Show definitions" },
      { "<leader>jr", "<cmd>Glance references<cr>", desc = "Show references" },
      { "<leader>ji", "<cmd>Glance implementations<cr>", desc = "Show implementations" },
      { "<leader>jy", "<cmd>Glance type_definitions<cr>", desc = "Show type definitions" },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local schemastore = require("schemastore")
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

        map("n", "gh", vim.lsp.buf.hover, "Hover docs")
        map("n", "<leader>sd", vim.lsp.buf.document_symbol, "Document symbols")
        map("n", "<leader>sw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
      end

      local function bounded_root(markers)
        return function(bufnr, on_dir)
          local root = require("config.root").root(require("config.root").buf_dir(bufnr), markers)
          if root then
            on_dir(root)
          end
        end
      end

      local servers = {
        bashls = {
          root_markers = { "Makefile" },
        },
        clangd = {
          root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", "CMakeLists.txt" },
        },
        gopls = {
          root_markers = { "go.work", "go.mod" },
        },
        html = {
          root_markers = { "package.json" },
        },
        cssls = {
          root_markers = { "package.json" },
        },
        docker_compose_language_service = {
          root_markers = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
        },
        dockerls = {
          root_markers = { "Dockerfile", "Containerfile" },
        },
        elmls = {
          root_markers = { "elm.json" },
        },
        emmet_language_server = {
          filetypes = {
            "css",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "typescriptreact",
            "vue",
          },
        },
        lua_ls = {
          root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", "lua" },
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
          root_markers = { "matlab.prj", "startup.m", "Contents.m" },
        },
        neocmake = {
          root_markers = { "CMakePresets.json", "CTestConfig.cmake", "CMakeLists.txt", "cmake" },
        },
        nginx_language_server = {
          root_markers = { "nginx.conf" },
        },
        basedpyright = {
          root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
          },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        jsonls = {
          root_markers = { "package.json" },
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        rust_analyzer = {
          root_markers = { "Cargo.toml", "rust-project.json" },
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
        sqlls = {
          root_markers = { ".sqllsrc.json" },
        },
        tailwindcss = {
          root_markers = {
            "tailwind.config.js",
            "tailwind.config.ts",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "postcss.config.js",
            "postcss.config.ts",
          },
          filetypes = {
            "html",
            "css",
            "scss",
            "less",
            "sass",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
        },
        taplo = {
          root_markers = { "taplo.toml", ".taplo.toml", "Cargo.toml", "pyproject.toml" },
        },
        texlab = {
          root_markers = { ".latexmkrc", "latexmkrc" },
        },
        verible = {
          root_markers = { ".svlangserver", ".svlint.toml", "verible.filelist", "filelist.f", "files.f" },
        },
        vtsls = {
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
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
          root_markers = { "package.json", "vue.config.js", "vite.config.ts", "vite.config.js" },
        },
        yamlls = {
          root_markers = { ".yamllint", ".yamllint.yaml", ".yamllint.yml" },
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = schemastore.yaml.schemas(),
            },
          },
        },
      }

      for server_name, server in pairs(servers) do
        server.capabilities = capabilities
        server.on_attach = on_attach
        if server.root_markers then
          server.root_dir = bounded_root(server.root_markers)
          server.root_markers = nil
        end
        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end

      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
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
