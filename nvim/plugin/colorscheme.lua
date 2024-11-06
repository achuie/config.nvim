if vim.g.did_load_colorscheme_plugin then
  return
end
vim.g.did_load_colorscheme_plugin = true

local tokyonight = require('tokyonight')

tokyonight.setup {
  style = "moon",
  on_highlights = function(hl, c)
    -- Show gutter tildes beyond end of file
    hl.EndOfBuffer = { fg = c.bg_highlight }
    hl.CursorLineNr = { bold = true, fg = c.fg_dark }
    hl.LineNrAbove = { fg = c.dark3 }
    hl.LineNrBelow = { fg = c.dark3 }
  end,
}

vim.cmd.colorscheme "tokyonight"
