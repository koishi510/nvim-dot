return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "stylua",
        "prettierd",
        "eslint_d",
        "ruff",
        "clang-format",
        "gofumpt",
        "goimports",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {
          c = true,
          cpp = true,
        }

        return {
          timeout_ms = 1500,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "fallback" or "prefer",
        }
      end,
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        css = { "prettierd", "prettier" },
        go = { "goimports", "gofumpt", "gofmt" },
        html = { "prettierd", "prettier" },
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        rust = { "rustfmt" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      local function available(names)
        local result = {}

        for _, name in ipairs(names) do
          if lint.linters[name] then
            table.insert(result, name)
          end
        end

        return result
      end

      lint.linters_by_ft = {
        c = available({ "clangtidy", "cppcheck" }),
        cpp = available({ "clangtidy", "cppcheck" }),
        css = available({ "stylelint" }),
        go = available({ "golangcilint" }),
        javascript = available({ "eslint_d", "eslint" }),
        javascriptreact = available({ "eslint_d", "eslint" }),
        python = available({ "ruff" }),
        rust = available({ "clippy" }),
        typescript = available({ "eslint_d", "eslint" }),
        typescriptreact = available({ "eslint_d", "eslint" }),
        vue = available({ "eslint_d", "eslint" }),
      }

      local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Run lint" })
    end,
  },
}
