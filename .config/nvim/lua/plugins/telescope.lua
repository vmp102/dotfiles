return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><leader>",
      LazyVim.pick("auto", { hidden = true, no_ignore = false }),
      desc = "Find files (root dir)",
    },
    {
      "<leader>ff",
      LazyVim.pick("auto", { hidden = true, no_ignore = false }),
      desc = "Find files (root dir)",
    },
    {
      "<leader>fF",
      LazyVim.pick("auto", { cwd = false, hidden = true, no_ignore = false }),
      desc = "Find files (cwd)",
    },
  },
}
