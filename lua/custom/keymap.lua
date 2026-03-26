-- Window management (navigation via smart-splits.lua)
-- Smart window cycling that skips special buffers
local function is_special_win(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  local bufname = vim.api.nvim_buf_get_name(buf)
  local skip_filetypes = { 'NvimTree', 'neo-tree', 'undotree', 'diff' }
  return vim.tbl_contains(skip_filetypes, ft)
end

local function smart_window_cycle()
  local start_win = vim.api.nvim_get_current_win()
  local visited = { [start_win] = true }

  vim.cmd 'wincmd w'
  local win = vim.api.nvim_get_current_win()

  while is_special_win(win) and not visited[win] do
    visited[win] = true
    vim.cmd 'wincmd w'
    win = vim.api.nvim_get_current_win()
  end

  if is_special_win(win) then vim.api.nvim_set_current_win(start_win) end
end

vim.keymap.set('n', '<C-w>w', smart_window_cycle, { desc = 'Cycle windows (skip special buffers)' })
vim.keymap.set('n', '<C-w><C-w>', smart_window_cycle, { desc = 'Cycle windows (skip special buffers)' })

vim.keymap.set('n', '<leader>wd', '<cmd>close<CR>', { desc = '[W]indow [D]elete' })
vim.keymap.set('n', '<leader>ws', '<cmd>split<CR>', { desc = '[W]indow [S]plit Horizontal' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = '[W]indow Split [V]ertical' })

-- Buffer management
vim.keymap.set('n', '<leader>bc', '<cmd>enew<CR>', { desc = '[B]uffer [C]reate' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bq', '<cmd>bd<CR>', { desc = '[B]uffer [Q]uit' })
vim.keymap.set('n', '<leader>nn', '<cmd>enew<CR>', { desc = '[N]ew Buffer' })

vim.keymap.set('n', '<A-C>', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<M-C>', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })
vim.keymap.set('n', '<Esc>C', '<cmd>Bdelete!<CR>', { desc = 'Force delete buffer' })

vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', { desc = '[W]rite and [Q]uit' })
vim.keymap.set('n', '<leader>ww', '<cmd>w<CR>', { desc = '[W]rite' })

-- Command results
vim.keymap.set('n', '<leader>cc', '<cmd>cclose<CR>', { desc = '[C]ommand Results [C]lose' })
vim.keymap.set('n', '<leader>co', '<cmd>copen<CR>', { desc = '[C]ommand Results [O]pen' })

vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line [D]own' })
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line [U]p' })

-- Move cursor by viewport height
local function move_viewport_down()
  local height = vim.api.nvim_win_get_height(0)
  vim.cmd('normal! ' .. height .. 'j')
end

local function move_viewport_up()
  local height = vim.api.nvim_win_get_height(0)
  vim.cmd('normal! ' .. height .. 'k')
end

vim.keymap.set('n', '<S-Down>', move_viewport_down, { desc = 'Move cursor down by viewport height' })
vim.keymap.set('n', '<S-Up>', move_viewport_up, { desc = 'Move cursor up by viewport height' })
vim.keymap.set('v', '<S-Down>', move_viewport_down, { desc = 'Move cursor down by viewport height' })
vim.keymap.set('v', '<S-Up>', move_viewport_up, { desc = 'Move cursor up by viewport height' })

-- Option+Arrow: word boundary jumping (like terminal/vscode)
vim.keymap.set({ 'n', 'v' }, '<A-Left>', 'b', { desc = 'Jump word back' })
vim.keymap.set({ 'n', 'v' }, '<A-Right>', 'w', { desc = 'Jump word forward' })
vim.keymap.set({ 'n', 'v' }, '<M-Left>', 'b', { desc = 'Jump word back' })
vim.keymap.set({ 'n', 'v' }, '<M-Right>', 'w', { desc = 'Jump word forward' })
vim.keymap.set('i', '<A-Left>', '<C-Left>', { desc = 'Jump word back' })
vim.keymap.set('i', '<A-Right>', '<C-Right>', { desc = 'Jump word forward' })
vim.keymap.set('i', '<M-Left>', '<C-Left>', { desc = 'Jump word back' })
vim.keymap.set('i', '<M-Right>', '<C-Right>', { desc = 'Jump word forward' })
vim.keymap.set('n', 'U', '<cmd>redo<CR>', { desc = 'Redo' })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move line [D]own' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move line [U]p' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and reselect' })
vim.keymap.set('v', '<', '<gv', { desc = 'Dedent and reselect' })
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, '<M-y>', '<C-y>', { desc = 'Accept current completion' })

vim.keymap.set('n', '<leader>fd', '<cmd>CopyPathToDir<CR>', { desc = 'Copy Current [F]ile [D]irectory' })
vim.keymap.set('n', '<leader>fp', '<cmd>CopyPathToFile<CR>', { desc = 'Copy Current [F]ile [P]ath' })
vim.keymap.set('n', '<leader>fr', '<cmd>CopyRelativePath<CR>', { desc = 'Copy Current [F]ile [R]elative Path' })

vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { desc = '[L]anguage Server [R]estart' })

vim.keymap.set('v', '<D-S-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', '<D-S-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('i', '<D-S-v>', '<C-r>+', { desc = 'Paste from clipboard' })
vim.keymap.set('v', '<D-S-v>', '"+p', { desc = 'Paste from clipboard' })

-- CMD + arrow for line start/end
vim.keymap.set({ 'n', 'v' }, '<D-Left>', '0', { desc = 'Go to beginning of line' })
vim.keymap.set({ 'n', 'v' }, '<D-Right>', '$', { desc = 'Go to end of line' })
vim.keymap.set('i', '<D-Left>', '<Home>', { desc = 'Go to beginning of line' })
vim.keymap.set('i', '<D-Right>', '<End>', { desc = 'Go to end of line' })

-- Mouse: disable right-click paste, middle-click closes buffer
vim.keymap.set({ 'n', 'i', 'v' }, '<RightMouse>', '<Nop>')
vim.keymap.set('n', '<MiddleMouse>', function()
  -- If clicked on the bufferline/tabline, close that buffer
  local mouse = vim.fn.getmousepos()
  if mouse.screenrow == 1 then
    -- Click was on the tabline — use bufferline's close
    vim.cmd 'BufferLinePickClose'
  else
    vim.cmd 'Bdelete'
  end
end, { desc = 'Middle-click closes buffer' })
vim.keymap.set({ 'i', 'v' }, '<MiddleMouse>', '<Nop>')

vim.keymap.set('n', '<C-e>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-y>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<C-e>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<C-y>', '<Nop>', { noremap = true })
