local languages = {
  "c",
  "cmake",
  "cpp",
  "bash",
  "css",
  "dockerfile",
  "elm",
  "go",
  "html",
  "javascript",
  "json",
  "latex",
  "lua",
  "matlab",
  "markdown",
  "markdown_inline",
  "make",
  "powershell",
  "python",
  "query",
  "regex",
  "rust",
  "systemverilog",
  "bibtex",
  "tsx",
  "typescript",
  "vue",
  "vim",
  "vimdoc",
  "yaml",
}

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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function(args)
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
