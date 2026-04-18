local map = vim.keymap.set
local git = require("config.git")
local typst = require("config.typst")

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

local function format_diagnostic(d)
  local bufnr = d.bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local file = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
  local severity = vim.diagnostic.severity[d.severity] or "UNKNOWN"
  local source = d.source and (" [" .. d.source .. "]") or ""
  return string.format("%s:%d:%d: %s%s: %s", file, d.lnum + 1, d.col + 1, severity, source, d.message)
end

local function copy_diagnostics(diags, empty_msg)
  if #diags == 0 then
    vim.notify(empty_msg, vim.log.levels.INFO)
    return
  end
  local lines = {}
  for _, d in ipairs(diags) do
    table.insert(lines, format_diagnostic(d))
  end
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify(string.format("Copied %d diagnostic(s)", #diags))
end

local function copy_line_diagnostics()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  copy_diagnostics(diags, "No diagnostic on this line")
end

local function copy_buffer_diagnostics()
  local diags = vim.diagnostic.get(0)
  table.sort(diags, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)
  copy_diagnostics(diags, "No diagnostics in this buffer")
end

local function toggle_quickfix()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      vim.cmd.cclose()
      return
    end
  end

  if vim.tbl_isempty(vim.fn.getqflist()) then
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
    return
  end

  vim.cmd.copen()
end

local function open_preview()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No file to preview", vim.log.levels.WARN)
    return
  end

  local ext = vim.fn.fnamemodify(file, ":e"):lower()

  if ext == "typ" then
    typst.view()
    return
  end

  local viewers = {
    png = "imv",
    jpg = "imv",
    jpeg = "imv",
    webp = "imv",
    gif = "imv",
    bmp = "imv",
    svg = "imv",
    pdf = "zathura",
    mp4 = "mpv",
    mkv = "mpv",
    webm = "mpv",
    mov = "mpv",
    avi = "mpv",
    flv = "mpv",
    wmv = "mpv",
    m4v = "mpv",
    mp3 = "mpv",
    flac = "mpv",
    wav = "mpv",
    ogg = "mpv",
    opus = "mpv",
    m4a = "mpv",
    aac = "mpv",
  }
  local viewer = viewers[ext]

  if not viewer then
    vim.notify("No previewer for ." .. ext, vim.log.levels.WARN)
    return
  end

  if vim.fn.executable(viewer) == 0 then
    vim.notify(viewer .. " is not installed", vim.log.levels.ERROR)
    return
  end

  vim.system({ viewer, file }, { detach = true })
end

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose both" })
map("n", "<leader>cn", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose none" })
map("n", "<leader>co", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose ours" })
map("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose theirs" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
map("n", "<leader>gf", git.set_conflict_qflist, { desc = "Conflict files" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gm", "<cmd>DiffviewOpen<cr>", { desc = "Merge view" })
map("n", "<leader>pm", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Preview Markdown" })
map("n", "<leader>po", open_preview, { desc = "Open preview" })
map("n", "<leader>yc", typst.compile, { desc = "Compile Typst" })
map("n", "<leader>yv", typst.view, { desc = "View Typst PDF" })
map("n", "<leader>yw", typst.watch, { desc = "Watch Typst" })
map("n", "<leader>ys", typst.stop, { desc = "Stop Typst" })
map("n", "<leader>ly", copy_line_diagnostics, { desc = "Copy line diagnostics" })
map("n", "<leader>lY", copy_buffer_diagnostics, { desc = "Copy buffer diagnostics" })
map("n", "<leader>xQ", toggle_quickfix, { desc = "Quickfix window" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Grow height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shrink height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow width" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", delete_buffer, { desc = "Delete buffer" })
map("n", "<leader>lf", format_buffer, { desc = "Format buffer" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
map("n", "<leader>bo", delete_other_buffers, { desc = "Close others" })

map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = vim.v.count1 })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -vim.v.count1 })
end, { desc = "Previous diagnostic" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next conflict" })
map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Previous conflict" })
