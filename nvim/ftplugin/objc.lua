-- Exit if the language server isn't available
if vim.fn.executable('clangd') ~= 1 then
  return
end

vim.cmd([[runtime! ftplugin/cpp.lua]])
