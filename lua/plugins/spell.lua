local prose_filetypes = {
  "gitcommit",
  "latex",
  "mail",
  "markdown",
  "plaintex",
  "quarto",
  "tex",
  "text",
  "typst",
}

local prose_ft_config = {}

for _, ft in ipairs(prose_filetypes) do
  prose_ft_config[ft] = "iter"
end

local function toggle_spell()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell check " .. (vim.wo.spell and "enabled" or "disabled"))
end

return {
  {
    "ravibrock/spellwarn.nvim",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.opt.spelllang = { "en_us", "cjk" }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_spell", { clear = true }),
        pattern = prose_filetypes,
        callback = function(args)
          if vim.b[args.buf].bigfile then
            return
          end

          vim.wo.spell = true
        end,
      })
    end,
    opts = {
      enable = true,
      ft_default = false,
      ft_config = prose_ft_config,
      max_file_size = 10000,
      severity = {
        spellbad = "HINT",
        spellcap = "HINT",
        spelllocal = "HINT",
        spellrare = "INFO",
      },
      prefix = "spelling: ",
      diagnostic_opts = {
        severity_sort = true,
      },
    },
    keys = {
      { "<leader>ms", toggle_spell, desc = "Toggle spell check" },
    },
  },
}
