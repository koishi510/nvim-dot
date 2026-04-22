local function current_markdown_file()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Markdown PDF export only supports markdown buffers", vim.log.levels.WARN)
    return nil
  end

  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("Save the markdown file before exporting PDF", vim.log.levels.WARN)
    return nil
  end

  if vim.bo.modified then
    vim.cmd.write()
  end

  return file
end

local function run_pdf_export(command, dir, output, failure_message)
  vim.notify("Exporting PDF: " .. vim.fn.fnamemodify(output, ":~:."))
  vim.system(command, { cwd = dir, text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("Exported PDF: " .. vim.fn.fnamemodify(output, ":~:."))
        return
      end

      local message = (result.stderr ~= "" and result.stderr or result.stdout or failure_message):gsub("%s+$", "")
      vim.notify(message, vim.log.levels.ERROR)
    end)
  end)
end

local function markdown_to_pdf_md_to_pdf()
  local file = current_markdown_file()

  if not file then
    return
  end

  if vim.fn.executable("md-to-pdf") ~= 1 then
    vim.notify("md-to-pdf is required to export markdown as PDF", vim.log.levels.ERROR)
    return
  end

  local output = vim.fn.fnamemodify(file, ":r") .. ".pdf"
  local dir = vim.fn.fnamemodify(file, ":p:h")
  local name = vim.fn.fnamemodify(file, ":t")

  run_pdf_export({ "md-to-pdf", name }, dir, output, "md-to-pdf export failed")
end

local function markdown_to_pdf_pandoc()
  local file = current_markdown_file()

  if not file then
    return
  end

  if vim.fn.executable("pandoc") ~= 1 then
    vim.notify("pandoc is required to export markdown as PDF", vim.log.levels.ERROR)
    return
  end

  local output = vim.fn.fnamemodify(file, ":r") .. ".pdf"
  local dir = vim.fn.fnamemodify(file, ":p:h")
  local name = vim.fn.fnamemodify(file, ":t")
  local output_name = vim.fn.fnamemodify(output, ":t")

  run_pdf_export({
    "pandoc",
    name,
    "--pdf-engine=xelatex",
    "-V",
    "mainfont=Noto Serif CJK SC",
    "-V",
    "CJKmainfont=Noto Serif CJK SC",
    "-o",
    output_name,
  }, dir, output, "pandoc export failed")
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ignore = function(bufnr)
        return require("config.git").has_conflict_markers(bufnr)
      end,
      completions = {
        lsp = {
          enabled = true,
        },
      },
      render_modes = true,
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle Markdown render", ft = "markdown" },
      { "<leader>mp", markdown_to_pdf_md_to_pdf, desc = "Export Markdown PDF", ft = "markdown" },
      { "<leader>mP", markdown_to_pdf_pandoc, desc = "Export Markdown PDF with Pandoc", ft = "markdown" },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "TextChangedI" }, {
        group = vim.api.nvim_create_augroup("markdown-conflict-render", { clear = true }),
        pattern = { "*.md", "*.markdown" },
        callback = function(args)
          if require("config.git").has_conflict_markers(args.buf) then
            pcall(require("render-markdown.core.manager").set_buf, args.buf, false)
          end
        end,
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    build = "cd app && npx --yes yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
    end,
    keys = {
      { "<F12>", "<cmd>MarkdownPreviewToggle<cr>", desc = "Preview Markdown", ft = "markdown" },
    },
  },
}
