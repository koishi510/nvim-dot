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
          local rainbow_groups = {
            RainbowDelimiterRed = "#f7768e",
            RainbowDelimiterYellow = "#e0af68",
            RainbowDelimiterBlue = "#7aa2f7",
            RainbowDelimiterOrange = "#ff9e64",
            RainbowDelimiterGreen = "#9ece6a",
            RainbowDelimiterViolet = "#bb9af7",
            RainbowDelimiterCyan = "#7dcfff",
          }

          for group, color in pairs(rainbow_groups) do
            highlights[group] = { fg = color, bg = "NONE" }
          end

          highlights.MatchParen = {
            fg = "#0f0f14",
            bg = "#9ece6a",
            bold = true,
          }

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
