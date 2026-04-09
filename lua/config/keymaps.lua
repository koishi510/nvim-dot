local map = vim.keymap.set
local git = require("config.git")
local quit = require("config.quit")
local smart_quit = quit.smart_quit

local function is_real_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
    return false
  end

  if vim.bo[buf].buftype ~= "" then
    return false
  end

  local ft = vim.bo[buf].filetype
  if ft == "snacks_dashboard" or ft:match("^snacks_") then
    return false
  end

  return true
end

local function real_buffers()
  local ret = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_real_buffer(buf) then
      ret[#ret + 1] = buf
    end
  end

  return ret
end

local function delete_buffer()
  local current = vim.api.nvim_get_current_buf()
  local buffers = real_buffers()

  if #buffers == 1 and buffers[1] == current then
    smart_quit()
    return
  end

  Snacks.bufdelete.delete()
end

local function delete_other_buffers()
  Snacks.bufdelete.other()
end

local function format_buffer()
  local ok, conform = pcall(require, "conform")

  if ok then
    conform.format({ async = true, lsp_fallback = true })
    return
  end

  vim.lsp.buf.format({ async = true })
end

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>f", format_buffer, { desc = "Format buffer" })
map("n", "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Conflict choose both" })
map("n", "<leader>cn", "<cmd>GitConflictChooseNone<cr>", { desc = "Conflict choose none" })
map("n", "<leader>co", "<cmd>GitConflictChooseOurs<cr>", { desc = "Conflict choose ours" })
map("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Conflict choose theirs" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diffview" })
map("n", "<leader>gf", git.set_conflict_qflist, { desc = "List conflicted files" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gm", "<cmd>DiffviewOpen<cr>", { desc = "Merge view" })
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontally" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", delete_buffer, { desc = "Delete buffer" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
map("n", "<leader>bo", delete_other_buffers, { desc = "Close other buffers" })

map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next conflict marker" })
map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Previous conflict marker" })

vim.api.nvim_create_user_command("SmartQuit", smart_quit, {
  desc = "Quit current file without leaving explorer fullscreen",
})

vim.api.nvim_create_user_command("SmartQuitForce", function()
  smart_quit({ force = true })
end, {
  desc = "Force quit current file without leaving special windows fullscreen",
})

vim.api.nvim_create_user_command("SmartQuitSet", function(opts)
  local arg = opts.args:lower()
  if arg == "on" or arg == "true" or arg == "enable" then
    quit.persist_enabled(true)
    return
  end

  if arg == "off" or arg == "false" or arg == "disable" then
    quit.persist_enabled(false)
    return
  end

  vim.notify("Use :SmartQuitSet on|off", vim.log.levels.ERROR)
end, {
  nargs = 1,
  complete = function()
    return { "on", "off" }
  end,
  desc = "Persistently enable or disable SmartQuit",
})

map("c", "<CR>", function()
  if vim.fn.getcmdtype() ~= ":" then
    return "<CR>"
  end

  local line = vim.fn.getcmdline()
  if (line == "q!" or line == "quit!") and not quit.should_use_native_quit() then
    return "<C-u>SmartQuitForce<CR>"
  end

  if (line == "q" or line == "quit") and not quit.should_use_native_quit() then
    return "<C-u>SmartQuit<CR>"
  end

  return "<CR>"
end, { expr = true, desc = "Run SmartQuit for :q" })
