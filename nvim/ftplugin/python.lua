-- Exit if the language server isn't available
if vim.fn.executable('ruff') ~= 1 then
  return
end

local root_files = {
  'pyproject.toml',
  'ruff.toml',
}

vim.lsp.start {
  name = 'ruff',
  cmd = { 'ruff server' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  single_file_support = true,
  capabilities = require('user.lsp').make_client_capabilities(),
}
