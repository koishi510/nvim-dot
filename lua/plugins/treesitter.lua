local languages = {
  "asm",
  "c",
  "cmake",
  "cpp",
  "bash",
  "css",
  "dockerfile",
  "elm",
  "go",
  "haskell",
  "html",
  "http",
  "javascript",
  "json",
  "latex",
  "lua",
  "matlab",
  "menhir",
  "markdown",
  "markdown_inline",
  "make",
  "nginx",
  "powershell",
  "python",
  "query",
  "regex",
  "rust",
  "sql",
  "systemverilog",
  "bibtex",
  "toml",
  "tsx",
  "typescript",
  "vue",
  "vim",
  "vimdoc",
  "yaml",
}

local filetypes = vim.list_extend(vim.deepcopy(languages), {
  "verilog",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ok, treesitter = pcall(require, "nvim-treesitter")
      if not ok then
        return
      end

      treesitter.setup({})
      vim.treesitter.language.register("systemverilog", { "verilog", "systemverilog" })

      local installed = treesitter.get_installed and treesitter.get_installed("parsers") or {}
      local have = {}
      for _, name in ipairs(installed) do
        have[name] = true
      end
      local missing = {}
      for _, lang in ipairs(languages) do
        if not have[lang] then
          table.insert(missing, lang)
        end
      end
      if #missing > 0 then
        treesitter.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
          if vim.b[args.buf].bigfile then
            return
          end

          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}
