return {
  {
    "S1M0N38/love2d.nvim",
    cmd = "LoveRun",
    opts = {},
    keys = {
      { "<leader>vv", "<cmd>LoveRun<cr>", desc = "Run LÖVE Project" },
      { "<leader>vs", "<cmd>LoveStop<cr>", desc = "Stop LÖVE Project" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = {
                  "${3rd}/love2d/library",
                },
              },
              diagnostics = {
                globals = { "love" },
              },
            },
          },
        },
      },
    },
  },
}
