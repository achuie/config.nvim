-- Exit if the language server isn't available
if vim.fn.executable('rust-analyzer') ~= 1 then
  return
end

local root_files = {
  'Cargo.toml',
  'rust-project.json',
  'rust-toolchain.toml',
  'rustfmt.toml',
}

vim.lsp.start {
  name = 'rust_analyzer',
  cmd = { 'rust-analyzer' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  single_file_support = true,
  capabilities = require('user.lsp').make_client_capabilities(),
}
