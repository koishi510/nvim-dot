local autocmd = vim.api.nvim_create_autocmd

do
  local function extend_to_word(bufnr, diagnostics)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return diagnostics
    end
    local out = {}
    for _, d in ipairs(diagnostics) do
      local end_lnum = d.end_lnum or d.lnum
      local end_col = d.end_col or d.col
      local needs_fix = end_lnum == d.lnum and end_col <= d.col + 1
      if needs_fix then
        local line = vim.api.nvim_buf_get_lines(bufnr, d.lnum, d.lnum + 1, false)[1]
        if line and #line > d.col then
          local rest = line:sub(d.col + 1)
          local word = rest:match("^[%w_]+") or rest:match("^%S+")
          if word and #word > 1 then
            d = vim.tbl_extend("force", d, {
              end_lnum = d.lnum,
              end_col = d.col + #word,
            })
          end
        end
      end
      table.insert(out, d)
    end
    return out
  end

  for _, name in ipairs({ "underline", "virtual_text" }) do
    local handler = vim.diagnostic.handlers[name]
    if handler and handler.show and not handler._extend_to_word then
      handler._extend_to_word = true
      local orig_show = handler.show
      handler.show = function(ns, bufnr, diagnostics, opts)
        return orig_show(ns, bufnr, extend_to_word(bufnr, diagnostics), opts)
      end
    end
  end
end

vim.filetype.add({
  extension = {
    asm = "asm",
    nasm = "asm",
    s = "asm",
    S = "asm",
    mly = "menhir",
    v = "verilog",
  },
})

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

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.h",
  desc = "Treat .h headers as C++ when sibling C++ sources exist",
  callback = function(args)
    local dir = vim.fs.dirname(args.file)
    if dir == "" or dir == nil then
      return
    end
    if vim.fn.glob(dir .. "/*.cpp") ~= "" or vim.fn.glob(dir .. "/*.cc") ~= "" or vim.fn.glob(dir .. "/*.cxx") ~= "" then
      vim.bo[args.buf].filetype = "cpp"
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd("VimResized", {
  desc = "Keep splits balanced after resizing",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

local function check_external_changes()
  if vim.fn.mode() ~= "c" then
    vim.cmd.checktime()
  end
end

local autosave_skip_filetypes = {
  gitcommit = true,
  gitrebase = true,
  gitconfig = true,
  hgcommit = true,
  oil = true,
}

local function autosave_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
    return
  end

  if autosave_skip_filetypes[vim.bo[bufnr].filetype] then
    return
  end

  if not vim.bo[bufnr].modified then
    return
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return
  end

  vim.b[bufnr].autosave_skip_format = true
  local ok, err = pcall(function()
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd.write()
    end)
  end)
  vim.b[bufnr].autosave_skip_format = nil

  if not ok then
    vim.notify("Autosave failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  desc = "Save modified file buffers when leaving the editing area",
  callback = function(args)
    autosave_buffer(args.buf)
  end,
})

autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave", "TermClose" }, {
  desc = "Reload files changed by external tools",
  callback = function()
    check_external_changes()
  end,
})

autocmd("FileChangedShellPost", {
  desc = "Report files reloaded after external changes",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    local file = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
    vim.notify("Reloaded external change: " .. file, vim.log.levels.INFO)
  end,
})

autocmd("FileChangedShell", {
  desc = "Warn before external changes collide with unsaved edits",
  callback = function(args)
    vim.v.fcs_choice = "ask"

    if not vim.bo[args.buf].modified then
      return
    end

    local name = vim.api.nvim_buf_get_name(args.buf)
    local file = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
    vim.notify("External change detected, but buffer has unsaved edits: " .. file, vim.log.levels.WARN)
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
