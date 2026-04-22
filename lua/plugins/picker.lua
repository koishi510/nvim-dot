local function root()
  local project = require("config.root").buf_project_root()
  return project or require("config.root").start_dir
end

local function ensure_runtime_dir()
  local dir = vim.env.XDG_RUNTIME_DIR
  if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 and vim.fn.filewritable(dir) ~= 2 then
    local fallback = vim.fs.joinpath("/tmp", "nvim-runtime-" .. vim.fn.getpid())
    vim.fn.mkdir(fallback, "p", "0700")
    if vim.fn.filewritable(fallback) == 2 then
      vim.env.XDG_RUNTIME_DIR = fallback
    end
  end
end

local function fzf(method, opts)
  return function()
    ensure_runtime_dir()
    require("config.layout").focus_main()
    local call_opts = vim.deepcopy(opts or {})
    if call_opts.cwd == false then
      call_opts.cwd = nil
    else
      call_opts = vim.tbl_extend("force", { cwd = root() }, call_opts)
    end
    require("fzf-lua")[method](call_opts)
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    init = ensure_runtime_dir,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      "default-title",
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline-right",
      },
      winopts = function()
        return require("config.layout").picker_winopts()
      end,
      files = {
        fd_opts = table.concat({
          "--color=never",
          "--type f",
          "--hidden",
          "--follow",
          "--exclude .git",
        }, " "),
      },
      grep = {
        rg_opts = table.concat({
          "--column",
          "--line-number",
          "--no-heading",
          "--color=always",
          "--smart-case",
          "--hidden",
          "--glob !.git",
        }, " "),
      },
      keymap = {
        builtin = {
          ["<Esc>"] = "hide",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
    },
    config = function(_, opts)
      ensure_runtime_dir()
      require("fzf-lua").setup(opts)
    end,
    keys = {
      { "<leader>ff", fzf("files"), desc = "Find files" },
      { "<leader>fg", fzf("live_grep"), desc = "Live grep" },
      { "<leader>fb", fzf("buffers", { cwd = false }), desc = "Find buffers" },
      { "<leader>fh", fzf("help_tags", { cwd = false }), desc = "Help tags" },
      { "<leader>fr", fzf("oldfiles", { cwd = false }), desc = "Recent files" },
      { "<leader>fc", fzf("commands", { cwd = false }), desc = "Commands" },
      { "<leader>fk", fzf("keymaps", { cwd = false }), desc = "Keymaps" },
      { "<leader>/", fzf("keymaps", { cwd = false }), desc = "Find keymaps" },
      { "<leader>cs", fzf("lsp_document_symbols", { cwd = false }), desc = "Document symbols" },
      { "<leader>cS", fzf("lsp_workspace_symbols", { cwd = false }), desc = "Workspace symbols" },
      { "<leader>xd", fzf("diagnostics_document", { cwd = false }), desc = "Document diagnostics" },
      { "<leader>xD", fzf("diagnostics_workspace", { cwd = false }), desc = "Workspace diagnostics" },
    },
  },
}
