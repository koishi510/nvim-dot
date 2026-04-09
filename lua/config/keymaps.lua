local map = vim.keymap.set
local git = require("config.git")

local function delete_buffer()
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
