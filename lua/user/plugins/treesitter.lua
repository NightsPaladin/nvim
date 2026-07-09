-- nvim-treesitter was fully rewritten for Neovim 0.12+.
-- The old master branch (configs module, opts-based setup) is archived and
-- incompatible with Neovim 0.12. The new main branch uses a minimal API:
-- parsers/queries are managed by the plugin; highlighting and other features
-- are enabled through Neovim's built-in vim.treesitter API.
--
-- To bulk-install parsers after switching, run: :TSInstall all
-- (excluding "ipkg" which has no valid parser)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- new rewrite; "master" is archived (Neovim 0.11 only)
  lazy = false,    -- the new rewrite does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Enable treesitter highlighting for all filetypes.
    -- If no parser is installed for a filetype, silently skip it.
    -- To install parsers, run :TSInstall <lang> or :TSInstall all
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
