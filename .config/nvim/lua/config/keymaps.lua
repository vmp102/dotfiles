-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open Snacks Dashboard
vim.keymap.set("n", "<leader>;", function()
  Snacks.dashboard.open()
end, { desc = "Dashboard" })
