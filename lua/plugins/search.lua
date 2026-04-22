local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  return vim.fn.fnamemodify(file, ":.")
end

return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {
      engine = "ripgrep",
      engines = {
        ripgrep = {
          path = "rg",
          showReplaceDiff = true,
          placeholders = {
            enabled = true,
          },
        },
      },
      icons = {
        enabled = true,
      },
      transient = true,
      windowCreationCommand = ("belowright %dsplit"):format(require("config.layout").bottom_height()),
    },
    keys = {
      {
        "<leader>fR",
        function()
          require("config.layout").focus_main()
          require("grug-far").open()
        end,
        desc = "Replace in project",
      },
      {
        "<leader>fw",
        function()
          require("config.layout").focus_main()
          require("grug-far").open({
            prefills = {
              search = vim.fn.expand("<cword>"),
            },
          })
        end,
        desc = "Replace word",
      },
      {
        "<leader>fF",
        function()
          require("config.layout").focus_main()
          require("grug-far").open({
            prefills = {
              paths = current_file(),
            },
          })
        end,
        desc = "Replace in file",
      },
      {
        "<leader>fR",
        function()
          require("grug-far").with_visual_selection()
        end,
        desc = "Replace selection",
        mode = "v",
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        border = "rounded",
        winblend = 0,
        wrap = true,
      },
    },
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
  },
}
