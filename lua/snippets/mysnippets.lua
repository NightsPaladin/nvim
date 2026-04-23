-- lua/snippets/mysnippets.lua
-- Personal LuaSnip snippets (Markdown focused)
-- Add this file to your LuaSnip loader logic if not already.

local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local c  = ls.choice_node
local sn = ls.snippet_node
local d  = ls.dynamic_node

-- Helper: choice of admonition/callout types
local callout_type = function(pos)
  return c(pos, {
    t("note"),
    t("tip"),
    t("info"),
    t("warning"),
    t("caution"),
    t("danger"),
    t("success"),
  })
end

-- Return module (optional if required elsewhere)
return {}
