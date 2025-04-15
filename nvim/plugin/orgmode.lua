if vim.g.did_load_orgmode_plugin then
  return
end
vim.g.did_load_orgmode_plugin = true

require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_agenda_start_on_weekday = 0,
  calendar_week_start_day = 0,
  org_default_notes_file = '~/orgfiles/refile.org',
  org_capture_templates = {
    s = {
      description = 'Scratch',
      template = '* Untitled %u\n%?\n%a',
    },
    t = {
      description = 'Task',
      template = '* TODO %?\n  DEADLINE: %t\n%a\n%u',
      target = '~/orgfiles/todo.org',
    },
    j = {
      description = 'Journal',
      template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n%?\n',
      target = '~/orgfiles/journal/%<%Y-%m>.org',
      datetree = { reversed = true, tree_type = 'month' },
    },
  },
})

require('org-roam').setup({
  directory = '~/orgfiles/roam',
  org_files = { '~/orgfiles' },
})
