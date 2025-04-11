if vim.g.did_load_orgmode_plugin then
  return
end
vim.g.did_load_orgmode_plugin = true

require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
})

require('org-roam').setup({ directory = '~/orgfiles' })
