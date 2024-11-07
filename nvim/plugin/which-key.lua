if vim.g.did_load_whichkey_plugin then
  return
end
vim.g.did_load_whichkey_plugin = true

local whichkey = require('which-key')
whichkey.setup {
  preset = 'helix'
}
whichkey.add({
  { "<leader>c", desc = "[c]ode" },
  { "<leader>s", desc = "[s]earch" },
  { "<leader>g", desc = "[g]it" },
  { "<leader>s", desc = "[s]earch", mode = "v" },
})
