return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.nvim", -- icons via mini suite
  },
  ft = { "markdown", "codecompanion" },
  ---@type render.md.UserConfig
  opts = {
    -- Extend rendering beyond plain markdown to CodeCompanion chat buffers
    file_types = { "markdown", "codecompanion" },
    debounce = 100,
    anti_conceal = true, -- keep cursor area legible
    heading = {
      enabled = true,
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      signs = false,
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
      position = "inline",
      padding = { left = 0, right = 1 },
      border = false,
    },
    paragraph = {
      enabled = true,
      conceal = { emphasis = true, links = true },
    },
    list = {
      enabled = true,
      indent = 2,
      icons = { "•", "◦", "▪" },
      highlight = "RenderMarkdownList",
    },
    checkbox = {
      enabled = true,
      unchecked = "",
      checked = "",
      partial = "",
      highlight = "RenderMarkdownCheckbox",
    },
    code = {
      enabled = true,
      sign = "󰉨 ",
      min_width = 40,
      pad_amount = 1,
      border = "rounded",
      line_numbers = "auto",
      highlight = "RenderMarkdownCode",
      background = "RenderMarkdownCodeBg",
    },
    inline_code = {
      enabled = true,
      padding = 0,
      highlight = "RenderMarkdownInlineCode",
      background = "RenderMarkdownInlineCodeBg",
    },
    quote = {
      enabled = true,
      icon = "│",
      repeat_linebreak = false,
      highlight = "RenderMarkdownQuote",
    },
    horizontal_rule = {
      enabled = true,
      icon = "────────────────────────",
      highlight = "RenderMarkdownRule",
    },
    link = {
      enabled = true,
      highlight = "RenderMarkdownLink",
      style = "conceal",
    },
    table = {
      enabled = true,
      style = "columns",
      border = "single",
      alignment_indicator = "⋮",
      highlight = "RenderMarkdownTable",
    },
    callout = {
      enabled = true,
      icons = {
        note = "󰌵 ",
        tip = "󰠠 ",
        info = " ",
        warning = " ",
        caution = " ",
        danger = " ",
        success = "󰗡 ",
      },
      highlight = {
        note = "RenderMarkdownCalloutNote",
        tip = "RenderMarkdownCalloutTip",
        info = "RenderMarkdownCalloutInfo",
        warning = "RenderMarkdownCalloutWarn",
        caution = "RenderMarkdownCalloutCaution",
        danger = "RenderMarkdownCalloutDanger",
        success = "RenderMarkdownCalloutSuccess",
      },
    },
    performance = {
      throttle = 50,
      max_bytes = 500000,
    },
  },
  keys = {
    {
      "<leader>tm",
      function()
        require("render-markdown").toggle()
      end,
      desc = "[T]oggle [M]arkdown",
    },
  },
}

