if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

vim.defer_fn(function()
  local configs = require('nvim-treesitter.configs')
  vim.g.skip_ts_context_comment_string_module = true

  local longBuffer = function(_, buf)
    local max_filesize = 1000 * 1024 -- 1 MiB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > max_filesize
  end

  ---@diagnostic disable-next-line: missing-fields
  configs.setup {
    -- ensure_installed = 'all',
    -- auto_install = false, -- Do not automatically install missing parsers when entering buffer
    highlight = {
      enable = true,
      disable = longBuffer,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
      disable = longBuffer,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = '<c-space>',
        -- node_incremental = '<c-space>',
        -- scope_incremental = '<c-s>',
        -- node_decremental = '<M-space>',
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
      disable = longBuffer,
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobject, similar to targets.vim
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aC'] = '@call.outer',
          ['iC'] = '@call.inner',
          ['a#'] = '@comment.outer',
          ['i#'] = '@comment.outer',
          ['ai'] = '@conditional.outer',
          ['ii'] = '@conditional.outer',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['aP'] = '@parameter.outer',
          ['iP'] = '@parameter.inner',
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']n'] = '@parameter.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']N'] = '@parameter.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[n'] = '@parameter.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[N'] = '@parameter.outer',
          ['[]'] = '@class.outer',
        },
      },
      nsp_interop = {
        enable = true,
        peek_definition_code = {
          ['df'] = '@function.outer',
          ['dF'] = '@class.outer',
        },
      },
      disable = longBuffer,
    },
  }

  require('treesitter-context').setup {
    max_lines = 3,
  }

  require('ts_context_commentstring').setup()

  -- Tree-sitter based folding
  -- vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end, 0)
