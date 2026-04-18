return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "bibtex-tidy",
        "checkmake",
        "shellcheck",
        "shfmt",
        "stylua",
        "prettierd",
        "cmakelang",
        "gersemi",
        "hadolint",
        "eslint_d",
        "elm-format",
        "miss_hit",
        "nginx-config-formatter",
        "sql-formatter",
        "sqlfluff",
        "stylelint",
        "taplo",
        "tex-fmt",
        "typstyle",
        "verible",
        "ruff",
        "clang-format",
        "gofumpt",
        "goimports",
        "golangci-lint",
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
      formatters = {
        clang_format = {
          inherit = true,
          prepend_args = function(self, ctx)
            if vim.fs.find({ ".clang-format" }, { upward = true, path = ctx.dirname })[1] then
              return {}
            end
            return { "-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}" }
          end,
        },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = {
          c = true,
          cpp = true,
        }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return {
          timeout_ms = 1500,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        bash = { "shfmt" },
        bib = { "bibtex-tidy" },
        c = { "clang_format" },
        cmake = { "gersemi", "cmake_format", stop_after_first = true },
        cpp = { "clang_format" },
        css = { "prettierd", "prettier", stop_after_first = true },
        elm = { "elm_format" },
        go = { "goimports", "gofumpt" },
        html = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        latex = { "tex-fmt" },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        matlab = { "mh_style" },
        nginx = { "nginxfmt" },
        plaintex = { "tex-fmt" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        tex = { "tex-fmt" },
        tsx = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vim = { "trim_whitespace" },
        vimdoc = { "trim_whitespace" },
        verilog = { "verible" },
        vue = { "prettierd", "prettier", stop_after_first = true },
        systemverilog = { "verible" },
        toml = { "taplo" },
        typst = { "typstyle" },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        zsh = { "shfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters.elm_review = {
        cmd = "elm-review",
        args = { "--report=json" },
        ignore_exitcode = true,
        parser = function(output, bufnr, cwd)
          if output == "" then
            return {}
          end

          local ok, data = pcall(vim.json.decode, output)
          if not ok or type(data) ~= "table" or type(data.errors) ~= "table" then
            return {}
          end

          local diagnostics = {}
          local current = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))

          for _, file in ipairs(data.errors) do
            local path = file.path
            if type(path) == "string" and not path:match("^/") then
              path = vim.fs.joinpath(cwd, path)
            end
            path = type(path) == "string" and vim.fs.normalize(path) or nil

            if path == current and type(file.errors) == "table" then
              for _, item in ipairs(file.errors) do
                local region = item.region or {}
                local start = region.start or {}
                local finish = region["end"] or {}
                local message = item.message or item.rule or "elm-review"

                if type(item.details) == "table" and #item.details > 0 then
                  message = message .. "\n" .. table.concat(item.details, "\n")
                end

                table.insert(diagnostics, {
                  lnum = math.max((start.line or 1) - 1, 0),
                  col = math.max((start.column or 1) - 1, 0),
                  end_lnum = math.max((finish.line or start.line or 1) - 1, 0),
                  end_col = math.max((finish.column or start.column or 1) - 1, 0),
                  severity = vim.diagnostic.severity.WARN,
                  source = item.rule and ("elm-review: " .. item.rule) or "elm-review",
                  message = message,
                })
              end
            end
          end

          return diagnostics
        end,
      }

      local function has_config(markers)
        return function(bufnr)
          local path = vim.api.nvim_buf_get_name(bufnr)
          local dir = path ~= "" and vim.fs.dirname(path) or vim.fn.getcwd()
          if vim.fs.find(markers, { upward = true, path = dir })[1] then
            return {}
          end
        end
      end

      local function root_cwd(markers, extra_cmd)
        return function(bufnr)
          local file = vim.api.nvim_buf_get_name(bufnr)
          if file == "" then
            return
          end
          local root = vim.fs.root(file, markers)
          if not root then
            return
          end
          if extra_cmd and vim.fn.executable(extra_cmd) ~= 1 then
            return
          end
          return { cwd = root }
        end
      end

      local has_clang = has_config({ "compile_commands.json", ".clang-tidy" })
      local has_go_module = has_config({ "go.mod", "go.work" })
      local has_eslint = has_config({
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.mjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        "eslint.config.js",
        "eslint.config.cjs",
        "eslint.config.mjs",
        "eslint.config.ts",
      })
      local has_stylelint = has_config({
        ".stylelintrc",
        ".stylelintrc.json",
        ".stylelintrc.yaml",
        ".stylelintrc.yml",
        ".stylelintrc.js",
        ".stylelintrc.cjs",
        ".stylelintrc.mjs",
        "stylelint.config.js",
        "stylelint.config.cjs",
        "stylelint.config.mjs",
      })

      local lint_specs = {
        bash = { linters = { "shellcheck" } },
        c = { linters = { "clangtidy" }, setup = has_clang },
        cmake = { linters = { "cmake_lint" } },
        cpp = { linters = { "clangtidy" }, setup = has_clang },
        css = { linters = { "stylelint" }, setup = has_stylelint },
        dockerfile = { linters = { "hadolint" } },
        elm = { linters = { "elm_review" }, setup = root_cwd("elm.json") },
        go = { linters = { "golangcilint" }, setup = has_go_module },
        javascript = { linters = { "eslint_d" }, setup = has_eslint },
        javascriptreact = { linters = { "eslint_d" }, setup = has_eslint },
        make = { linters = { "checkmake" } },
        python = { linters = { "ruff" } },
        sh = { linters = { "shellcheck" } },
        sql = { linters = { "sqlfluff" }, setup = root_cwd(".sqlfluff") },
        typescript = { linters = { "eslint_d" }, setup = has_eslint },
        typescriptreact = { linters = { "eslint_d" }, setup = has_eslint },
        vue = { linters = { "eslint_d" }, setup = has_eslint },
        zsh = { linters = { "shellcheck" } },
      }

      lint.linters_by_ft = vim.tbl_map(function(spec)
        return spec.linters
      end, lint_specs)

      local function try_lint(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        local ft = vim.bo[bufnr].filetype
        local spec = lint_specs[ft]
        if not spec then
          return
        end

        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if line_count <= 1 and first_line == "" then
          return
        end

        local opts = {}
        if spec.setup then
          local result = spec.setup(bufnr)
          if result == nil then
            return
          end
          opts = result
        end

        lint.try_lint(spec.linters, opts)
      end

      local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = group,
        callback = function(args)
          try_lint(args.buf)
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        try_lint()
      end, { desc = "Lint buffer" })
    end,
  },
}
