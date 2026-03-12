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
        explorer = {
          hidden = true,
          layout = {
            layout = {
              position = "right",
            },
          },
        },
        files = {
          hidden = true,
          ignored = false,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
}
