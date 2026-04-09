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
            "WhichKeyFloat",
            "Pmenu",
            "PmenuSel",
            "SnacksNormal",
            "SnacksNormalNC",
            "SnacksBackdrop",
            "SnacksPicker",
            "SnacksPickerInput",
            "SnacksPickerBox",
            "SnacksPickerList",
            "SnacksPickerPreview",
            "SnacksPickerPrompt",
            "SnacksPickerBorder",
            "SnacksInput",
            "SnacksInputBorder",
            "SnacksNotifier",
            "SnacksNotifierBorder",
            "SnacksExplorer",
            "SnacksExplorerBorder",
            "SnacksTerminal",
            "SnacksTerminalBorder",
          }

          for _, group in ipairs(transparent_groups) do
            highlights[group] = highlights[group] or {}
            highlights[group].bg = "NONE"
          end

          local border_groups = {
            "SnacksPickerBorder",
            "SnacksInputBorder",
            "SnacksNotifierBorder",
            "SnacksExplorerBorder",
            "SnacksTerminalBorder",
          }

          for _, group in ipairs(border_groups) do
            highlights[group] = highlights[group] or {}
            highlights[group].bg = "NONE"
            highlights[group].fg = "#7a88cf"
          end
        end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
