return {
  {
    "jmbuhr/cmp-pandoc-references",
    ft = { "markdown", "tex", "plaintex", "quarto" },
    keys = {
      {
        "<leader>ic",
        function()
          require("cmp").complete({
            config = {
              sources = {
                { name = "pandoc_references" },
              },
            },
          })
        end,
        desc = "Complete citation",
        mode = { "n", "i" },
      },
    },
  },
}
