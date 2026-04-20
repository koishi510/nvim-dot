return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "uga-rosa/cmp-dictionary",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "jmbuhr/cmp-pandoc-references",
      "kristijanhusak/vim-dadbod-completion",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local lspkind = require("lspkind")
      local has_selected_completion = false

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      cmp.event:on("confirm_done", function()
        has_selected_completion = false
      end)
      cmp.event:on("menu_opened", function()
        has_selected_completion = false
      end)
      cmp.event:on("menu_closed", function()
        has_selected_completion = false
      end)

      local dictionaries = vim.tbl_filter(function(path)
        return vim.fn.filereadable(path) == 1
      end, {
        "/usr/share/dict/words",
        "/usr/dict/words",
      })

      require("cmp_dictionary").setup({
        dic = {
          ["*"] = dictionaries,
        },
        exact_length = 2,
        first_case_insensitive = true,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              buffer = "[Buf]",
              dictionary = "[Dict]",
              luasnip = "[Snip]",
              nvim_lsp = "[LSP]",
              pandoc_references = "[Ref]",
              path = "[Path]",
              ["vim-dadbod-completion"] = "[DB]",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              has_selected_completion = true
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              has_selected_completion = true
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_selected_completion and cmp.get_selected_entry() then
              cmp.confirm({ select = false })
            else
              cmp.close()
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              has_selected_completion = true
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              has_selected_completion = true
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
          { name = "dictionary", keyword_length = 3 },
        }),
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype({ "markdown", "tex", "plaintex", "quarto" }, {
        sources = cmp.config.sources({
          { name = "pandoc_references" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
          { name = "dictionary", keyword_length = 3 },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
