return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  config = function()
    local ok, snacks = pcall(require, "snacks")
    if not ok then return end
    snacks.setup({
      -- Widely-used core modules
      notifier     = { enabled = true }, -- richer notifications
      bigfile      = { enabled = true }, -- optimize large files automatically
      dashboard    = { enabled = true }, -- startup dashboard
      input        = { enabled = true }, -- better input/select prompts
      picker       = { enabled = true }, -- Snacks' picker UI (we still keep Telescope; no keymaps overridden here)
      lazygit      = { enabled = true }, -- integration if lazygit is available
      quickfile    = { enabled = true }, -- quick file opener helpers
      statuscolumn = { enabled = true }, -- enhanced statuscolumn UI

      -- Avoid overlap with Mini's indent/scope features on this branch
      indent       = { enabled = false },
    })
  end,
}