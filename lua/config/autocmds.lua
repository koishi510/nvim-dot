local autocmd = vim.api.nvim_create_autocmd

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
