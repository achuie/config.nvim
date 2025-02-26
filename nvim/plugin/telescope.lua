if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

vim.keymap.set('n', '<leader>sf', function()
  builtin.find_files()
end, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch via [g]rep' })
vim.keymap.set('n', '<leader>sG', fuzzy_grep, { desc = '[s]earch fuzzily via [G]rep' })
vim.keymap.set('n', '<leader>sT', fuzzy_grep_current_file_type, { desc = '[s]earch via grep amongst current file[T]ype' })
vim.keymap.set('n', '<leader>st', live_grep_current_file_type, { desc = '[s]earch via grep amongst current file[t]ype' })
vim.keymap.set(
  'n',
  '<leader>s*t',
  grep_string_current_file_type,
  { desc = '[s]earch current string [*] amongst current file[t]ype via grep' }
)
vim.keymap.set('n', '<leader>s*g', builtin.grep_string, { desc = '[s]earch current string [*] via [g]rep' })
vim.keymap.set('n', '<leader>sp', project_files, { desc = '[s]earch files amongst [p]roject files' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[t]elescope quickfix list [c]' })
vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[t]elescope command history [q]' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[t]elescope [l]oclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[t]elescope [r]egisters' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] find existing buffers' })
vim.keymap.set(
  'n',
  '<leader>/',
  builtin.current_buffer_fuzzy_find,
  { desc = '[/] fuzzily search in current buffer' }
)
vim.keymap.set('n', '<leader>tds', builtin.lsp_document_symbols, { desc = '[t]elescope lsp [d]ocument [s]ymbols' })
vim.keymap.set(
  'n',
  '<leader>tws',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = '[t]elescope lsp dynamic [w]orkspace [s]ymbols' }
)

-- Search from Visual mode
function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end
vim.keymap.set('v', '<leader>sg', function()
  local text = vim.getVisualSelection()
  builtin.live_grep({ default_text = text })
end, { desc = '[s]earch via [g]rep for current selection' })
vim.keymap.set('v', '<leader>/', function()
  local text = vim.getVisualSelection()
  builtin.current_buffer_fuzzy_find({ default_text = text })
end, { desc = '[/] fuzzily search for current selection in current buffer' })

vim.keymap.set('n', '<leader>tt', builtin.treesitter, { desc = '[t]elescope [t]ags' })

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    -- layout_config = layout_config,
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        -- ['<esc>'] = actions.close,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
        ['<M-p>'] = require('telescope.actions.layout').toggle_preview,
      },
      n = {
        q = actions.close,
        ['<M-p>'] = require('telescope.actions.layout').toggle_preview,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    -- selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

telescope.load_extension('fzf')
-- telescope.load_extension('smart_history')
