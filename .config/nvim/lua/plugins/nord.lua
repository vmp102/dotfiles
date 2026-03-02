return {
  -- 1. Your Nord Theme (Saved)
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({})
      -- REMOVED: vim.cmd.colorscheme("nord")
      -- (We let LazyVim handle the loading instead)
    end,
  },

  -- 2. Add Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({})
    end,
  },

  -- 3. Tell LazyVim which one to use by default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe", -- Change this to "nord" to swap back!
    },
  },
}
