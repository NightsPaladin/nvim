vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "~/work/wiki/" },
  callback = function()
    vim.bo.filetype = "telekasten"
  end,
})
