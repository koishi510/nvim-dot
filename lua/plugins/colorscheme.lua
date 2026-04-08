return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(highlights)
          local transparent_groups = {
            "Normal",
            "NormalFloat",
            "NormalNC",
            "SignColumn",
            "EndOfBuffer",
            "StatusLine",
            "StatusLineNC",
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "TelescopeNormal",
            "TelescopeBorder",
            "TelescopePromptNormal",
            "TelescopePromptBorder",
            "TelescopeResultsNormal",
            "TelescopeResultsBorder",
            "TelescopePreviewNormal",
            "TelescopePreviewBorder",
            "WhichKeyFloat",
            "Pmenu",
            "PmenuSel",
          }

          for _, group in ipairs(transparent_groups) do
            highlights[group] = highlights[group] or {}
            highlights[group].bg = "NONE"
          end
        end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
