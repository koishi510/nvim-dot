local autocmd = vim.api.nvim_create_autocmd

local root_markers = {
  ".git",
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "go.mod",
  "Cargo.toml",
  "compile_commands.json",
  "CMakeLists.txt",
  "elm.json",
  ".svlangserver",
  ".svlint.toml",
  "verible.filelist",
  "filelist.f",
  "files.f",
  "Makefile",
  "lua",
  "matlab.prj",
  "startup.m",
  "Contents.m",
}

local function project_root(path)
  local marker = vim.fs.find(root_markers, {
    path = path,
    upward = true,
  })[1]

  if marker then
    return vim.fs.dirname(marker)
  end
end

local function apply_dashboard_window(win, buf)
  if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.b[buf].snacks_indent = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].foldmethod = "manual"
  vim.wo[win].foldexpr = "0"
  vim.wo[win].foldtext = ""
  vim.wo[win].foldenable = false
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].statuscolumn = " "
  vim.wo[win].signcolumn = "no"
end

local function apply_tutor_window(win, buf)
  if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.b[buf].snacks_indent = false
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].signcolumn = "yes:1"
  vim.wo[win].statuscolumn = "%s%=%l "
end

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("VimResized", {
  desc = "Keep splits balanced after resizing",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

autocmd({ "BufEnter", "BufWinEnter" }, {
  desc = "Use project root as cwd for project files",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" then
      return
    end

    local root = project_root(vim.fs.dirname(path))
    if root and root ~= vim.fn.getcwd() then
      vim.cmd.tcd(vim.fn.fnameescape(root))
    end
  end,
})

autocmd("FileType", {
  pattern = "snacks_dashboard",
  desc = "Disable code UI in dashboard",
  callback = function(args)
    local wins = vim.fn.win_findbuf(args.buf)
    if #wins == 0 then
      apply_dashboard_window(vim.api.nvim_get_current_win(), args.buf)
      return
    end

    for _, win in ipairs(wins) do
      apply_dashboard_window(win, args.buf)
    end
  end,
})

autocmd({ "BufWinEnter", "WinEnter" }, {
  desc = "Keep dashboard free of fold and indent UI",
  callback = function(args)
    local buf = args.buf or vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype ~= "snacks_dashboard" then
      return
    end

    apply_dashboard_window(vim.api.nvim_get_current_win(), buf)
  end,
})

autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
  pattern = "tutor",
  desc = "Use native sign column for Tutor marks",
  callback = function(args)
    local buf = args.buf or vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype ~= "tutor" then
      return
    end

    apply_tutor_window(vim.api.nvim_get_current_win(), buf)
  end,
})
