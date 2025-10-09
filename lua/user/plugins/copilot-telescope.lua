-- lua/config/copilot-telescope.lua
-- Simple multi-file selection for CopilotChat

local M = {}

-- Module-level variables (will be populated on first use)
local telescope
local actions
local action_state

-- Lazy-load telescope modules when first needed
local function ensure_telescope_loaded()
  if telescope and actions and action_state then
    return true
  end

  local telescope_ok, tele = pcall(require, "telescope.builtin")
  local actions_ok, act = pcall(require, "telescope.actions")
  local action_state_ok, act_state = pcall(require, "telescope.actions.state")

  if not (telescope_ok and actions_ok and action_state_ok) then
    vim.notify("Telescope not available. Make sure telescope.nvim is installed and loaded.", vim.log.levels.ERROR)
    return false
  end

  -- Cache at module level so callbacks can access them
  telescope = tele
  actions = act
  action_state = act_state

  return true
end

-- Function to insert files into CopilotChat
local function insert_files_into_chat(files)
  if #files == 0 then
    vim.notify("No files selected", vim.log.levels.WARN)
    return
  end

  -- Build file references
  local lines = {}
  for _, file in ipairs(files) do
    table.insert(lines, "#file:" .. file)
  end
  table.insert(lines, "")

  -- Open CopilotChat
  local ok, chat = pcall(require, "CopilotChat")
  if not ok then
    vim.notify("CopilotChat not loaded", vim.log.levels.ERROR)
    return
  end

  chat.open()

  -- Wait a bit for the buffer to be ready
  vim.defer_fn(function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(bufnr)

    -- Make sure we're in the copilot-chat buffer
    if not buf_name:match("copilot%-chat") then
      vim.notify("Failed to open CopilotChat buffer", vim.log.levels.ERROR)
      return
    end

    -- Get current cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor[1]

    -- Insert the lines at cursor position
    vim.api.nvim_buf_set_lines(bufnr, current_row - 1, current_row - 1, false, lines)

    -- Move cursor after inserted lines and enter insert mode
    vim.api.nvim_win_set_cursor(0, { current_row + #lines, 0 })
    vim.cmd("startinsert!")
  end, 100)
end

-- Select files from project
function M.select_files()
  if not ensure_telescope_loaded() then
    return
  end

  telescope.find_files({
    prompt_title = "Select Files for CopilotChat (Tab to multi-select, Enter to confirm)",
    attach_mappings = function(prompt_bufnr, map)
      -- Disable the default select action
      actions.select_default:replace(function() end)

      -- Map Enter to our custom handler
      map("i", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        -- Collect selected files
        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            table.insert(files, entry.value or entry[1])
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            table.insert(files, entry.value or entry[1])
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      map("n", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        -- Collect selected files
        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            table.insert(files, entry.value or entry[1])
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            table.insert(files, entry.value or entry[1])
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      return true
    end,
  })
end

-- Select from open buffers
function M.select_buffers()
  if not ensure_telescope_loaded() then
    return
  end

  telescope.buffers({
    prompt_title = "Select Buffers for CopilotChat (Tab to multi-select, Enter to confirm)",
    attach_mappings = function(prompt_bufnr, map)
      -- Disable the default select action
      actions.select_default:replace(function() end)

      -- Map Enter to our custom handler
      map("i", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            local bufnr = entry.bufnr
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name and name ~= "" then
              local relative = vim.fn.fnamemodify(name, ":.")
              table.insert(files, relative)
            end
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            local name = vim.api.nvim_buf_get_name(entry.bufnr)
            if name and name ~= "" then
              local relative = vim.fn.fnamemodify(name, ":.")
              table.insert(files, relative)
            end
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      map("n", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            local bufnr = entry.bufnr
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name and name ~= "" then
              local relative = vim.fn.fnamemodify(name, ":.")
              table.insert(files, relative)
            end
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            local name = vim.api.nvim_buf_get_name(entry.bufnr)
            if name and name ~= "" then
              local relative = vim.fn.fnamemodify(name, ":.")
              table.insert(files, relative)
            end
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      return true
    end,
  })
end

-- Select git changed files
function M.select_git_files()
  if not ensure_telescope_loaded() then
    return
  end

  telescope.git_status({
    prompt_title = "Select Git Files for CopilotChat (Tab to multi-select, Enter to confirm)",
    attach_mappings = function(prompt_bufnr, map)
      -- Disable the default select action
      actions.select_default:replace(function() end)

      -- Map Enter to our custom handler
      map("i", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            table.insert(files, entry.value or entry[1])
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            table.insert(files, entry.value or entry[1])
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      map("n", "<CR>", function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        local files = {}
        if #multi > 0 then
          -- Multiple selections
          for _, entry in ipairs(multi) do
            table.insert(files, entry.value or entry[1])
          end
        else
          -- Single selection
          local entry = action_state.get_selected_entry()
          if entry then
            table.insert(files, entry.value or entry[1])
          end
        end

        actions.close(prompt_bufnr)
        insert_files_into_chat(files)
      end)

      return true
    end,
  })
end

-- Create commands and keymaps (they will check if telescope is available when called)
-- Create user commands
vim.api.nvim_create_user_command("CopilotChatFiles", M.select_files, {
  desc = "Select project files for CopilotChat",
})
vim.api.nvim_create_user_command("CopilotChatBuffers", M.select_buffers, {
  desc = "Select open buffers for CopilotChat",
})
vim.api.nvim_create_user_command("CopilotChatGitFiles", M.select_git_files, {
  desc = "Select git changed files for CopilotChat",
})

-- Create keymaps
vim.keymap.set("n", "<leader>af", M.select_files, {
  desc = "Select files for Copilot Chat",
})
vim.keymap.set("n", "<leader>ab", M.select_buffers, {
  desc = "Select buffers for Copilot Chat",
})
vim.keymap.set("n", "<leader>ag", M.select_git_files, {
  desc = "Select git files for Copilot Chat",
})

return M
