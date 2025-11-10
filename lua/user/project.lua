-- filepath: lua/user/project.lua
-- Snacks.nvim Project Picker & Root Detection
-- This module is loaded after snacks.nvim is ready

local projects_root = "~/work" -- Set your projects root directory here
local root_markers = { ".git", "package.json", "Cargo.toml", "go.mod" }

local Path = require("plenary.path")
local scan = require("plenary.scandir")
local snacks = require("snacks")

-- Recursively scan for project roots
local function find_projects(root, markers)
  local expanded_root = vim.fn.expand(root)
  local projects = {}
  scan.scan_dir(expanded_root, {
    hidden = true,
    depth = 3,
    add_dirs = true,
    on_insert = function(dir)
      for _, marker in ipairs(markers) do
        if Path:new(dir):joinpath(marker):exists() then
          table.insert(projects, dir)
          break
        end
      end
    end,
  })
  return projects
end

-- Snacks picker for projects
local function pick_project()
  local projects = find_projects(projects_root, root_markers)
  if #projects == 0 then
    vim.notify("No projects found in " .. projects_root, vim.log.levels.WARN)
    return
  end

  local expanded_root = vim.fn.expand(projects_root)
  local items = {}

  for _, project_path in ipairs(projects) do
    local project_name = vim.fn.fnamemodify(project_path, ":t")
    local relative_path = project_path:gsub("^" .. vim.pesc(expanded_root) .. "/", "")

    table.insert(items, {
      file = project_path,
      text = string.format("%-30s  %s", project_name, relative_path),
    })
  end

  snacks.picker.pick({
    items = items,
    title = "Select Project",
    prompt = "",
    format = function(item, picker)
      -- Return highlighting segments: just display the pre-formatted text
      return {
        { item.text, "Normal" },
      }
    end,
    on_select = function(item)
      vim.cmd("lcd " .. item.file)
      vim.notify("Set local directory to " .. item.file)
    end,
  })
end

vim.api.nvim_create_user_command("SnacksProjects", pick_project, { desc = "Pick a project with snacks.nvim" })

-- Upward search for nearest project root from current directory
local function find_upwards_root(start_dir, markers)
  local dir = Path:new(start_dir)
  while dir:absolute() ~= "/" do
    for _, marker in ipairs(markers) do
      if dir:joinpath(marker):exists() then
        return dir:absolute()
      end
    end
    dir = dir:parent()
  end
  return nil
end

vim.api.nvim_create_user_command("SetProjectRoot", function()
  local cwd = vim.fn.getcwd()
  local root = find_upwards_root(cwd, root_markers)
  if root then
    vim.cmd("lcd " .. root)
    vim.notify("Set local directory to " .. root)
  else
    vim.notify("No project root found upwards from " .. cwd, vim.log.levels.WARN)
  end
end, { desc = "Set local directory to nearest project root upwards" })

-- Keymaps
vim.keymap.set("n", "<leader>pr", "<cmd>SetProjectRoot<cr>", { desc = "Project Root" })
vim.keymap.set("n", "<leader>pp", "<cmd>SnacksProjects<cr>", { desc = "Search Projects" })

-- vim: ts=2 sts=2 sw=2 et
