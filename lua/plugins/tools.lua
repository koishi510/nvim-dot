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
      local lint_specs = {
        c = { "clangtidy", "cppcheck" },
        cpp = { "clangtidy", "cppcheck" },
        css = { "stylelint" },
        go = { "golangcilint" },
        javascript = { "eslint_d", "eslint" },
        javascriptreact = { "eslint_d", "eslint" },
        python = { "ruff" },
        rust = { "clippy" },
        typescript = { "eslint_d", "eslint" },
        typescriptreact = { "eslint_d", "eslint" },
        vue = { "eslint_d", "eslint" },
      }
      local warned = {}

      local function available(names)
        local result = {}

        for _, name in ipairs(names) do
          local linter = lint.linters[name]
          local cmd = linter and linter.cmd
          local executable = type(cmd) == "string" and vim.fn.executable(cmd) == 1

          if linter and (cmd == nil or executable) then
            table.insert(result, name)
          end
        end

        return result
      end

      lint.linters_by_ft = vim.tbl_map(available, lint_specs)

      local function try_lint(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        local names = lint_specs[ft]
        local linters = names and available(names) or nil

        if names and #names > 0 and (#linters == 0) then
          local key = ft .. ":" .. table.concat(names, ",")
          if not warned[key] then
            warned[key] = true
            vim.notify(
              string.format("No linters available for %s. Install one of: %s", ft, table.concat(names, ", ")),
              vim.log.levels.WARN
            )
          end
          return
        end

        lint.try_lint(linters)
      end

      local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function(args)
          try_lint(args.buf)
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        try_lint()
      end, { desc = "Run lint" })
    end,
  },
}
