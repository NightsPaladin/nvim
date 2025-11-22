-- Prevent replacing special (non-file) buffers with file buffers
-- Works with help, quickfix, terminal, Telescope, Snacks pickers, CodeCompanion chat, etc.

local group = vim.api.nvim_create_augroup("NoOverwriteSpecial", { clear = true })
vim.g.no_replace_special_enabled = true

local guard = false
local function with_guard(fn)
  if guard then return end
  guard = true
  vim.schedule(function()
    pcall(fn)
    guard = false
  end)
end

local function is_floating(win)
  local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
  return ok and cfg and cfg.relative ~= "" and cfg.relative ~= nil
end

local function is_normal_window(win)
  return vim.api.nvim_win_is_valid(win) and not is_floating(win)
end

local function is_file_buf(buf)
  if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "") then
    return false
  end
  -- Treat NvimTree as special to avoid being replaced
  if vim.bo[buf].filetype == "NvimTree" or vim.bo[buf].filetype == "nvimtree" or vim.bo[buf].filetype == "neo-tree" then
    return false
  end
  return true
end

local function is_special_buf(buf)
  if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype ~= "") then
    -- Consider NvimTree special even though its buftype is normal
    local ft = vim.bo[buf].filetype
    if ft == "NvimTree" or ft == "nvimtree" or ft == "neo-tree" then
      return true
    end
    return false
  end
  return true
end

-- Track the last window that shows a normal file buffer
local function set_last_file_win(win)
  if is_normal_window(win) then
    vim.g._no_replace_last_file_win = win
  end
end

local function get_last_file_win()
  local w = vim.g._no_replace_last_file_win
  if w and vim.api.nvim_win_is_valid(w) and is_normal_window(w) then
    return w
  end
  -- Fallback: find any window with a file buffer
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_normal_window(win) then
      local b = vim.api.nvim_win_get_buf(win)
      if is_file_buf(b) then
        return win
      end
    end
  end
  return nil
end

-- When leaving a special buffer, remember it on the window
vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  callback = function(args)
    if not vim.g.no_replace_special_enabled then return end
    local win = vim.api.nvim_get_current_win()
    if not is_normal_window(win) then return end
    local buf = args.buf
    if is_special_buf(buf) then
      vim.w[win].no_replace_last_special_buf = buf
    end
  end,
})

-- Track last file window whenever we enter a file buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    if not vim.g.no_replace_special_enabled then return end
    local win = vim.api.nvim_get_current_win()
    if not is_normal_window(win) then return end
    local buf = args.buf
    if is_file_buf(buf) then
      set_last_file_win(win)
    end
  end,
})

-- Core: if a file buffer appears in a window that used to have a special buffer, move it out
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    if not vim.g.no_replace_special_enabled then return end

    local win = vim.api.nvim_get_current_win()
    if not is_normal_window(win) then return end

    local buf = args.buf
    if not is_file_buf(buf) then return end

    local special = vim.w[win].no_replace_last_special_buf
    if not (special and vim.api.nvim_buf_is_valid(special) and is_special_buf(special)) then
      return
    end

    with_guard(function()
      local target = get_last_file_win()
      if not target or target == win then
        -- No suitable file window: create a vsplit
        vim.cmd("vsplit")
        target = vim.api.nvim_get_current_win()
      end

      -- Move the file buffer to the target window
      if vim.api.nvim_win_is_valid(target) then
        pcall(vim.api.nvim_win_set_buf, target, buf)
      end

      -- Restore the special buffer in the original window
      if vim.api.nvim_buf_is_valid(special) then
        if vim.api.nvim_get_current_win() ~= win then
          pcall(vim.api.nvim_set_current_win, win)
        end
        pcall(vim.api.nvim_win_set_buf, win, special)
      end

      -- Focus the file window where the user intended to go
      if vim.api.nvim_win_is_valid(target) then
        pcall(vim.api.nvim_set_current_win, target)
      end

      vim.w[win].no_replace_last_special_buf = nil
    end)
  end,
})

-- Optional: a toggle command
vim.api.nvim_create_user_command("NoReplaceSpecialToggle", function()
  vim.g.no_replace_special_enabled = not vim.g.no_replace_special_enabled
  vim.notify("NoReplaceSpecial: " .. (vim.g.no_replace_special_enabled and "ON" or "OFF"))
end, {})
