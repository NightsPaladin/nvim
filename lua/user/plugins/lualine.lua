return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local mode = {
      "mode",
      fmt = function(str)
        return str:sub(1, 3)
      end,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
      cond = hide_in_width,
    }

    -- local filename = {
    --   "filename",
    --   file_status = true,  -- Shows [+] for modified, [RO] for readonly
    --   path = 1,            -- 0 = just filename, 1 = relative path, 2 = absolute path
    --
    --   -- Custom symbols for file status
    --   symbols = {
    --     modified = "●",      -- Clear dot indicator
    --     readonly = " ",      -- Lock symbol for readonly
    --     unnamed = "[No Name]",
    --   },
    -- }

    local filename = {
    "filename",
    file_status = true,
    path = 1,
    symbols = {
      modified = "●",  -- No symbol, just color
      readonly = " ",
      unnamed = "[No Name]",
    },
    -- Filename turns orange when modified
    color = function()
      if vim.bo.modified then
        return { fg = "#ff9e64", gui = "bold" }  -- Orange + bold
      end
      return nil  -- Default color when not modified
    end,
  }

    local filetype = {
      "filetype",
      icons_enabled = true,
      icon = nil,
      color = { fg = "orange" },
    }

    local branch = {
      "branch",
      icons_enabled = true,
      icon = "",
    }

    local location = {
      "location",
      padding = 0,
    }

    local spaces = function()
      return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
    end

    return {
      options = {
        theme = "base16",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        always_divide_middle = true,
        ignore_focus = { "NvimTree" },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, "diagnostics" },
        lualine_c = { filename },
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = { "progress" },
        lualine_z = { location },
      },
      extensions = { "quickfix", "man", "fugitive" },
    }
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
