return {
  "nvim-lualine/lualine.nvim",
  config = function()
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

    -- local custom_fname = require("lualine.components.filename"):extend()
    -- local highlight = require("lualine.highlight")
    -- local default_status_colors = { saved = "#348934", modified = "#9A3434" }
    --
    -- function custom_fname:init(options)
    --   custom_fname.super.init(self, options)
    --   self.status_colors = {
    --     saved = highlight.create_component_highlight_group(
    --       { fg = default_status_colors.saved },
    --       "filename_status_saved",
    --       self.options
    --     ),
    --     modified = highlight.create_component_highlight_group(
    --       { fg = default_status_colors.modified },
    --       "filename_status_modified",
    --       self.options
    --     ),
    --   }
    --   if self.options.color == nil then
    --     self.options.color = ""
    --   end
    -- end
    --
    -- function custom_fname:update_status()
    --   local data = custom_fname.super.update_status(self)
    --   data = highlight.component_format_highlight(
    --     vim.bo.modified and self.status_colors.modified or self.status_colors.saved
    --   ) .. data
    --   return data
    -- end

    local filename = {
      -- custom_fname,
      "filename",
      file_status = true, -- displays file status (readonly, modified, etc.)
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
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

    require("lualine").setup({
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
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
