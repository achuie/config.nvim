if vim.g.did_load_colorscheme_plugin then
  return
end
vim.g.did_load_colorscheme_plugin = true

local nightfox = require('nightfox')
nightfox.setup {
  options = {
    styles = {
      comments = "italic",
      keywords = "italic"
    }
  },
  groups = {
    all = {
      EndOfBuffer = { fg = "bg4" }
    }
  },
}

local autotheme = function()
  if vim.o.background == "light" and vim.g.fox_theme ~= "dayfox" then
    vim.g.fox_theme = "dayfox"
    vim.cmd.colorscheme("dayfox")
  end
  if vim.o.background == "dark" and vim.g.fox_theme ~= "nightfox" then
    vim.g.fox_theme = "nightfox"
    vim.cmd.colorscheme("terafox")
  end
end

autotheme()

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = autotheme,
})
