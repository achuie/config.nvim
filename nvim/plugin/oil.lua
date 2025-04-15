if vim.g.did_load_oil_plugin then
  return
end
vim.g.did_load_oil_plugin = true

local detail = false
require('oil').setup({
  default_file_explorer = true,
  keymaps = {
    ['gd'] = {
      desc = 'Toggle file detail view',
      callback = function()
        detail = not detail
        if detail then
          require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
        else
          require('oil').set_columns({ 'icon' })
        end
      end,
    },
    ['o'] = { 'actions.select', opts = { horizontal = true } },
    ['a'] = { 'actions.select', opts = { vertical = true } },
    ['gt'] = { 'actions.select', opts = { tab = true } },
  },
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
