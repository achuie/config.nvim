--[[ Setting options ]]

-- <leader> key. Defaults to `\`. Some people prefer space.
-- g.mapleader = ' '
-- g.maplocalleader = ' '

vim.o.compatible = false

-- Enable true colour support
if vim.fn.has('termguicolors') then
  vim.o.termguicolors = true
end

-- Search down into subfolders
vim.o.path = vim.o.path .. '**'

-- Confirm dialog
vim.o.confirm = true

-- Enable mouse mode but not in Visual
vim.o.mouse = 'nih'

-- Make relative line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Highlight matching parentheses, etc
vim.o.showmatch = true

-- Search options to highlight as pattern is typed, highlight all matches, and case-insensitive unless \C or capital is
-- in search
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Spellcheck, except for CJK characters, and check camelcased words separately
vim.o.spell = false
vim.o.spelllang = 'en_us,cjk'
vim.o.spelloptions = 'camel'

-- Use spaces instead of tabs, 4 spaces by default
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 8

-- Set line length
vim.o.textwidth = 120

--[[
  c  Auto-wrap comments using textwidth, inserting the current comment leader
        automatically.
  q  Allow formatting of comments with "gq".
  r  Automatically insert the current comment leader after hitting <Enter> in
        Insert mode. 
  t  Auto-wrap text using textwidth (does not apply to comments)
]]
vim.o.formatoptions = 'c,q,r,t'

-- Show tabs and indicate long lines
vim.o.list = true
vim.opt.listchars = { tab = '›—', extends = '→', precedes = '←', nbsp = '·' }

-- Cmdline history
vim.o.history = 10000

-- Recognize binary and hexadecimal in addition to decimal
vim.o.nrformats = 'bin,hex'

-- Save undo history
vim.o.undofile = true

-- Normal split directions
vim.o.splitright = true
vim.o.splitbelow = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Better completion experience: only fill from menu when selected and limit menu height
vim.o.completeopt = 'menu,menuone,noselect,noinsert,preview'
vim.o.pumheight = 20

-- Enable folds; open all folds quickly by toggling off with `zi`
vim.o.foldenable = true

-- Prettier folds
vim.o.fillchars = [[foldopen:,foldclose:]]

-- Mujin controller access
vim.g.netrw_scp_cmd = 'scp -q -i ~/.ssh/mujin/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

-- Highlight cursor's current line
vim.o.cursorline = true

-- Search for project `.editorconfig` files
vim.g.editorconfig = true

-- Native plugins
vim.cmd.filetype('plugin', 'indent', 'on')

-- Allows filtering the quickfix list with :cfdo
vim.cmd.packadd('cfilter')

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')


--[[ Keymaps ]]

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Use <F11> to toggle Paste Insert mode and numbers
vim.keymap.set('n', '<F11>', function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.go.paste = not vim.go.paste
end)

-- Map redraw screen command to also turn off search highlighting until the next search
vim.keymap.set('n', '<C-L>', ':nohl<CR><C-L>')

-- Buffer mappings
vim.keymap.set('n', '[b', vim.cmd.bprevious, { desc = 'previous [b]uffer' })
vim.keymap.set('n', ']b', vim.cmd.bnext, { desc = 'next [b]uffer' })
vim.keymap.set('n', '[B', vim.cmd.bfirst, { desc = 'first [B]uffer' })
vim.keymap.set('n', ']B', vim.cmd.blast, { desc = 'last [B]uffer' })

-- Tab mappings
vim.keymap.set('n', '[T', vim.cmd.tabfirst, { desc = 'first [T]ab' })
vim.keymap.set('n', '[t', vim.cmd.tabprevious, { desc = 'previous [t]ab' })
vim.keymap.set('n', ']t', vim.cmd.tabnext, { desc = 'next [t]ab' })
vim.keymap.set('n', ']T', vim.cmd.tablast, { desc = 'last [T]ab' })
vim.keymap.set('n', 'te', vim.cmd.tabedit, { desc = '[e]dit [t]ab' })
vim.keymap.set('n', 'tn', vim.cmd.tabnew, { desc = 'open [n]ew buffer in [t]ab' })
vim.keymap.set('n', 'tm', ':tabm<Space>', { desc = '[m]ove [t]ab ±N positions' })
vim.keymap.set('n', 'td', vim.cmd.tabclose, { desc = '[d]elete current [t]ab' })

-- Search for visually selected text
vim.keymap.set('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- Fold lines not matching previous search; `zr` for more context, `zm` for less
vim.keymap.set('n', '<Leader>z', function()
    vim.cmd([[:setlocal
    \ foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
    \ foldmethod=expr foldlevel=0 foldcolumn=2]])
end)

-- Toggle error highlighting for overlength lines
vim.keymap.set('n', '<Leader>l', function()
    vim.cmd(vim.api.nvim_replace_termcodes([[
    if exists('w:long_line_match') <Bar>
    \   silent! call matchdelete(w:long_line_match) <Bar>
    \   unlet w:long_line_match <Bar>
    \ elseif &textwidth > 0 <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>'.&tw.'v.\+',-1) <Bar>
    \ else <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>80v.\+',-1) <Bar>
    \ endif]], true, true, true))
end, { silent = true })

-- Fill line with char
vim.cmd([[function! FillLine(str)
    let reps = (&textwidth - col("$") + 1) / len(a:str)
    if reps > 0
        .s/$/\=(''.repeat(a:str, reps))/
    endif
endfunction]])

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

vim.keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'toggle quickfix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

vim.keymap.set('n', '[c', cleft, { desc = '[c]ycle quickfix left' })
vim.keymap.set('n', ']c', cright, { desc = '[c]ycle quickfix right' })
vim.keymap.set('n', '[C', vim.cmd.cfirst, { desc = 'first quickfix entry' })
vim.keymap.set('n', ']C', vim.cmd.clast, { desc = 'last quickfix entry' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

vim.keymap.set('n', '[l', lleft, { desc = 'cycle [l]oclist left' })
vim.keymap.set('n', ']l', lright, { desc = 'cycle [l]oclist right' })
vim.keymap.set('n', '[L', vim.cmd.lfirst, { desc = 'first [L]oclist entry' })
vim.keymap.set('n', ']L', vim.cmd.llast, { desc = 'last [L]oclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
vim.keymap.set('n', '<leader>w+', function()
  local curWinWidth = vim.api.nvim_win_get_width(0)
  vim.api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { desc = 'inc window [w]idth' })
vim.keymap.set('n', '<leader>w-', function()
  local curWinWidth = vim.api.nvim_win_get_width(0)
  vim.api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { desc = 'dec window [w]idth' })
vim.keymap.set('n', '<leader>h+', function()
  local curWinHeight = vim.api.nvim_win_get_height(0)
  vim.api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { desc = 'inc window [h]eight' })
vim.keymap.set('n', '<leader>h-', function()
  local curWinHeight = vim.api.nvim_win_get_height(0)
  vim.api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { desc = 'dec window [h]eight' })

-- Close floating windows [Neovim 0.10 and above]
vim.keymap.set('n', '<leader>fq', function()
  vim.cmd('fclose!')
end, { desc = '[f]loating windows: [q]uit/close all' })

-- Shortcut for expanding to current buffer's directory in command mode
vim.keymap.set('c', '%%', function()
  if vim.fn.getcmdtype() == ':' then
    return vim.fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

-- Diagnostic navigation
vim.keymap.set('n', '<leader>e', function()
  local _, winid = vim.diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, desc = 'previous [d]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, desc = 'next [d]iagnostic' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev {
    severity = vim.diagnostic.severity.ERROR,
  }
end, { noremap = true, desc = 'previous [e]rror diagnostic' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next {
    severity = vim.diagnostic.severity.ERROR,
  }
end, { noremap = true, desc = 'next [e]rror diagnostic' })
vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev {
    severity = vim.diagnostic.severity.WARN,
  }
end, { noremap = true, desc = 'previous [w]arning diagnostic' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next {
    severity = vim.diagnostic.severity.WARN,
  }
end, { noremap = true, desc = 'next [w]arning diagnostic' })
vim.keymap.set('n', '[h', function()
  vim.diagnostic.goto_prev {
    severity = vim.diagnostic.severity.HINT,
  }
end, { noremap = true, desc = 'previous [h]int diagnostic' })
vim.keymap.set('n', ']h', function()
  vim.diagnostic.goto_next {
    severity = vim.diagnostic.severity.HINT,
  }
end, { noremap = true, desc = 'next [h]int diagnostic' })


--[[ Diagnostic messages ]]

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

-- Requires Nerd fonts
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}


--[[ Filetypes ]]

vim.filetype.add({
  extension = {
    pm = 'pollen'
  }
})
