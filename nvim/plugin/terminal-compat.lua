if vim.g.did_load_terminal_compat_plugin then
  return
end
vim.g.did_load_terminal_compat_plugin = true

-- Disable true-color support for terminal emulators that don't handle 24-bit
-- color escape sequences well (e.g. MeshCentral's built-in terminal).
vim.o.termguicolors = false
