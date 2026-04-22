local function session_dir()
  return vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")
end

return {
  {
    "olimorris/persisted.nvim",
    cmd = {
      "SessionDelete",
      "SessionLoad",
      "SessionLoadFromFile",
      "SessionLoadLast",
      "SessionSave",
      "SessionStart",
      "SessionStop",
      "SessionToggle",
    },
    opts = {
      save_dir = session_dir(),
      autostart = true,
      autoload = false,
      follow_cwd = true,
      use_git_branch = true,
      should_save = function()
        local ft = vim.bo.filetype
        return ft ~= "snacks_dashboard" and ft ~= "gitcommit"
      end,
    },
    config = function(_, opts)
      require("persisted").setup(opts)
    end,
    keys = {
      { "<leader>ss", "<cmd>SessionSave<cr>", desc = "Save session" },
      { "<leader>sl", "<cmd>SessionLoad<cr>", desc = "Load session" },
      { "<leader>sL", "<cmd>SessionLoadLast<cr>", desc = "Load last session" },
      { "<leader>sd", "<cmd>SessionDelete<cr>", desc = "Delete session" },
      { "<leader>st", "<cmd>SessionToggle<cr>", desc = "Toggle session" },
    },
  },
}
