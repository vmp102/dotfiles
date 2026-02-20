return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = {
          hidden = true, -- show dotfiles
          ignored = false, -- show files in .gitignore (set to true if you want to keep gitignore active)
        },
        grep = {
          hidden = true,
        },
        explorer = {
          hidden = true,
        },
      },
    },
  },
}
