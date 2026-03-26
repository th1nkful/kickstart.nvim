-- Wrap vim.notify to handle fast event contexts
-- This prevents errors when plugins call vim.notify during fast events
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Use pcall to catch fast event errors and schedule the notification
  local ok, err = pcall(original_notify, msg, level, opts)
  if not ok and err:match("E5560") then
    -- If we're in a fast event context, schedule for later
    vim.schedule(function()
      original_notify(msg, level, opts)
    end)
  end
end

vim.g.have_nerd_font = true
vim.opt.relativenumber = true

-- Font for GUI clients (Neovide, etc.) — terminal font is set in the terminal emulator
vim.o.guifont = 'JetBrainsMono Nerd Font:h13'
-- Winbar: show relative file path with breadcrumb-style separators
vim.o.winbar = '%{%v:lua._winbar_path()%}'

function _G._winbar_path()
  local buf = vim.api.nvim_get_current_buf()
  local bt = vim.bo[buf].buftype
  if bt ~= '' then
    return ''
  end

  local path = vim.fn.expand '%:.'
  if path == '' then
    return '[No Name]'
  end

  local sep = vim.g.have_nerd_font and '  ' or ' > '
  local parts = vim.split(path, '/', { plain = true })
  local result = {}
  for i, part in ipairs(parts) do
    if i == #parts then
      table.insert(result, '%#WinBarFilename#' .. part .. '%*')
    else
      table.insert(result, '%#WinBarPath#' .. part .. '%*')
    end
  end
  return ' ' .. table.concat(result, sep)
end

-- Winbar highlight groups (set after colorscheme loads)
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('winbar-highlights', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'WinBarPath', { fg = '#7f849c', bold = false })
    vim.api.nvim_set_hl(0, 'WinBarFilename', { fg = '#cdd6f4', bold = true })
  end,
})
-- Also set immediately in case colorscheme is already loaded
vim.api.nvim_set_hl(0, 'WinBarPath', { fg = '#7f849c', bold = false })
vim.api.nvim_set_hl(0, 'WinBarFilename', { fg = '#cdd6f4', bold = true })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.api.nvim_create_user_command('CopyPathToFile', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
vim.api.nvim_create_user_command('CopyRelativePath', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
vim.api.nvim_create_user_command('CopyPathToDir', function()
  local path = vim.fn.expand '%:p:h'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
