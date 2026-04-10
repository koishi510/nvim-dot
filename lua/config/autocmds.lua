local autocmd = vim.api.nvim_create_autocmd

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
