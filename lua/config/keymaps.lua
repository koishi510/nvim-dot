local map = vim.keymap.set
local git = require("config.git")
local quickfix = require("config.quickfix")

local function delete_buffer()
  Snacks.bufdelete.delete()
end

local function delete_other_buffers()
  Snacks.bufdelete.other()
end

local function format_buffer()
  if git.has_conflict_markers(0) then
    vim.notify("Skip formatting: Git conflict markers found", vim.log.levels.WARN)
    return
  end

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

  require("config.layout").focus_main()
  vim.cmd.copen()
  vim.cmd.resize(require("config.layout").bottom_height())
  vim.wo.winfixheight = true
end

local function diagnostics_to_quickfix(bufnr, title)
  local diagnostics = vim.diagnostic.get(bufnr)

  table.sort(diagnostics, function(a, b)
    local file_a = vim.api.nvim_buf_get_name(a.bufnr or 0)
    local file_b = vim.api.nvim_buf_get_name(b.bufnr or 0)
    if file_a == file_b then
      if a.lnum == b.lnum then
        return a.col < b.col
      end
      return a.lnum < b.lnum
    end
    return file_a < file_b
  end)

  vim.fn.setqflist({}, " ", {
    title = title,
    items = vim.diagnostic.toqflist(diagnostics),
  })

  if vim.tbl_isempty(diagnostics) then
    vim.notify(title .. " is empty", vim.log.levels.INFO)
    return
  end

  vim.cmd.copen()
end

local function workspace_diagnostics_to_quickfix()
  diagnostics_to_quickfix(nil, "Workspace diagnostics")
end

local function grep_to_quickfix()
  if vim.fn.executable("rg") ~= 1 then
    vim.notify("rg is not installed", vim.log.levels.ERROR)
    return
  end

  vim.ui.input({ prompt = "rg quickfix: " }, function(query)
    if not query or query == "" then
      return
    end

    local cwd = require("config.root").start_dir
    vim.system({
      "rg",
      "--vimgrep",
      "--smart-case",
      "--hidden",
      "--glob",
      "!.git",
      query,
    }, { cwd = cwd, text = true }, function(result)
      vim.schedule(function()
        if result.code and result.code > 1 then
          vim.notify((result.stderr or ""):gsub("%s+$", ""), vim.log.levels.ERROR)
          return
        end

        local lines = vim.split(result.stdout or "", "\n", { trimempty = true })
        local items = vim.fn.getqflist({
          lines = lines,
          efm = "%f:%l:%c:%m",
        }).items

        vim.fn.setqflist({}, " ", {
          title = "rg: " .. query,
          items = items,
        })

        if vim.tbl_isempty(items) then
          vim.notify("No rg matches: " .. query, vim.log.levels.INFO)
          return
        end

        vim.cmd.copen()
      end)
    end)
  end)
end

local function open_preview()
  if vim.bo.filetype == "markdown" then
    vim.cmd.MarkdownPreviewToggle()
    return
  end

  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("No file to preview", vim.log.levels.WARN)
    return
  end

  local ext = vim.fn.fnamemodify(file, ":e"):lower()

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
    html = "xdg-open",
    htm = "xdg-open",
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

  vim.system({ viewer, file }, { detach = true }, function() end)
end

map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>wq", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose both" })
map("n", "<leader>gcc", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose current" })
map("n", "<leader>gci", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose incoming" })
map("n", "<leader>gcn", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose none" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gm", "<cmd>DiffviewOpen<cr>", { desc = "Merge view" })
map("n", "<leader>gq", git.set_conflict_qflist, { desc = "Find conflicts" })
map("n", "<leader>fG", grep_to_quickfix, { desc = "Grep quickfix" })
map("n", "<leader>v", open_preview, { desc = "Open preview" })
map("n", "<leader>mc", "<cmd>VimtexCompile<cr>", { desc = "Compile LaTeX" })
map("n", "<leader>mv", "<cmd>VimtexView<cr>", { desc = "View PDF" })
map("n", "<leader>mx", "<cmd>VimtexStop<cr>", { desc = "Stop LaTeX" })
map("n", "<leader>mC", "<cmd>VimtexClean<cr>", { desc = "Clean LaTeX" })
map("n", "<leader>me", "<cmd>VimtexErrors<cr>", { desc = "Show LaTeX errors" })
map("n", "<leader>mt", "<cmd>VimtexTocToggle<cr>", { desc = "Toggle LaTeX TOC" })
map("n", "<leader>mI", "<cmd>VimtexInfo<cr>", { desc = "Show LaTeX info" })
map("n", "<leader>cy", copy_line_diagnostics, { desc = "Copy line diagnostics" })
map("n", "<leader>cY", copy_buffer_diagnostics, { desc = "Copy buffer diagnostics" })
map("n", "<leader>cq", workspace_diagnostics_to_quickfix, { desc = "Diagnostics quickfix" })
map("n", "<leader>ay", quickfix.copy_agent_prompt, { desc = "Copy agent quickfix prompt" })
map("n", "<leader>xQ", toggle_quickfix, { desc = "Quickfix window" })
map("n", "<leader>xw", quickfix.write_with_notify, { desc = "Write quickfix" })
map("n", "<leader>xy", quickfix.copy, { desc = "Copy quickfix" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<A-h>", "<C-w>h", { desc = "Focus window left" })
map("n", "<A-j>", "<C-w>j", { desc = "Focus window down" })
map("n", "<A-k>", "<C-w>k", { desc = "Focus window up" })
map("n", "<A-l>", "<C-w>l", { desc = "Focus window right" })
map("n", "<A-H>", "<cmd>vertical resize -2<cr>", { desc = "Shrink window width" })
map("n", "<A-J>", "<cmd>resize -2<cr>", { desc = "Shrink window height" })
map("n", "<A-K>", "<cmd>resize +2<cr>", { desc = "Grow window height" })
map("n", "<A-L>", "<cmd>vertical resize +2<cr>", { desc = "Grow window width" })
map("n", "<A-q>", delete_buffer, { desc = "Delete buffer" })
map("n", "<A-i>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<A-o>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", delete_buffer, { desc = "Delete buffer" })
map("n", "<leader>cf", format_buffer, { desc = "Format buffer" })
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
