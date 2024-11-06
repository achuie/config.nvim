-- Exit if the language server isn't available
if vim.fn.executable('clangd') ~= 1 then
  return
end

local root_files = {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac',  -- AutoTools
}

vim.lsp.start {
  name = 'clangd',
  cmd = { 'clangd' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  single_file_support = true,
  capabilities = require('user.lsp').make_client_capabilities(),
}
