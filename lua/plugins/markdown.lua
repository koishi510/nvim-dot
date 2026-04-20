return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ignore = function(bufnr)
        return require("config.git").has_conflict_markers(bufnr)
      end,
      completions = {
        lsp = {
          enabled = true,
        },
      },
      render_modes = true,
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "TextChangedI" }, {
        group = vim.api.nvim_create_augroup("markdown-conflict-render", { clear = true }),
        pattern = { "*.md", "*.markdown" },
        callback = function(args)
          if require("config.git").has_conflict_markers(args.buf) then
            pcall(require("render-markdown.core.manager").set_buf, args.buf, false)
          end
        end,
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    build = "cd app && npx --yes yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
    end,
  },
}
