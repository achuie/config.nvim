if vim.g.did_load_indentblankline_plugin then
  return
end
vim.g.did_load_indentblankline_plugin = true

local ibl = require('ibl')

ibl.setup {
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
}
