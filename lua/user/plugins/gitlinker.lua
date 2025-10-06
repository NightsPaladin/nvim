return {
  "linrongbin16/gitlinker.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "GitLink",
  opts = {},
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank Git Link" },
    { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open Git Link" },
  },
  config = function()
    require("gitlinker").setup()
  end,
}
