return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "n",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofumpt" },
      -- Conform can also run multiple formatters sequentially
      python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },

      -- DevOps & Infrastructure-as-Code
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
      yaml = { "yamlfmt" },
      json = { "jq" },
      jsonc = { "jq" },
      markdown = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      toml = { "taplo" },

      -- Web development (native Prettier support)
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      vue = { "prettier" },
      svelte = { "prettier" },
      graphql = { "prettier" },
      handlebars = { "prettier" },
    },
    formatters = {
      yamlfmt = {
        command = "yamlfmt",
        args = { "-formatter", "indent=2,include_document_start=true" },
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
