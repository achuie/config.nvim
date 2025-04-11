if vim.g.did_load_whichkey_plugin then
  return
end
vim.g.did_load_whichkey_plugin = true

local whichkey = require('which-key')
whichkey.setup {
  preset = 'helix'
}
whichkey.add({
  { "<leader>c", desc = "[c]hange" },
  { "<leader>s", desc = "[s]earch" },
  { "<leader>g", desc = "[g]it" },
  { "<leader>s", desc = "[s]earch", mode = "v" },
  { "<leader>t", desc = "[t]elescope" },
  { "<leader>o", desc = "[o]rgmode" },
  { "<leader>n", desc = "org-roam" },
})
