return {
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bib" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_flavor = "latex"
    end,
    keys = {
      { "<leader>vc", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
      { "<leader>vv", "<cmd>VimtexView<cr>", desc = "View PDF" },
      { "<leader>vs", "<cmd>VimtexStop<cr>", desc = "Stop LaTeX" },
      { "<leader>vC", "<cmd>VimtexClean<cr>", desc = "Clean LaTeX" },
      { "<leader>ve", "<cmd>VimtexErrors<cr>", desc = "Show LaTeX errors" },
      { "<leader>vt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle LaTeX TOC" },
      { "<leader>vi", "<cmd>VimtexInfo<cr>", desc = "Show LaTeX info" },
    },
  },
}
