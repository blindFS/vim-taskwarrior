let g:task_report_command           = ['active', 'all', 'blocked', 'blocking', 'completed', 'list', 'long', 'ls', 'minimal', 'newest', 'next', 'oldest', 'overdue', 'ready', 'recurring', 'unblocked', 'waiting']
let g:task_interactive_command      = ['annotate', 'denotate', 'exeucte', 'duplicate', 'append', 'prepend', 'stop', 'delete', 'done', 'undo', 'config', 'edit', 'start', 'sync', 'synchronize', 'add', 'modify', 'import', 'colors', 'logo']
let g:task_filter                   = ['description:', 'proj:', 'pri:', 'status:', 'tag:', 'due.before:', 'due.after:', 'entry.before', 'entry.after', 'end.before', 'end.after', '+']
let g:task_all_commands             = split(system('task _command'), '\n')
let g:task_all_configurations       = split(system('task _config'), '\n')
let g:task_report_name              = index(g:task_report_command, get(g:, 'task_report_name')) != -1 ? get(g:, 'task_report_name') : 'next'
let g:task_highlight_field          = get(g:, 'task_highlight_field', 1)
let g:task_field_highlight_link     = get(g:, 'task_field_highlight_link', 'IncSearch')
let g:task_field_highlight_advanced = get(g:, 'task_field_highlight_advanced', '')
let g:task_readonly                 = get(g:, 'task_readonly', 0)
let g:task_rc_override              = get(g:, 'task_rc_override', '')
let g:task_default_prompt           = get(g:, 'task_default_prompt', ['due', 'project', 'priority', 'description', 'tag', 'depends'])
let g:task_info_vsplit              = get(g:, 'task_info_vsplit', 0)
let g:task_info_size                = get(g:, 'task_info_size', 15)
let g:airline_readonly_symbol       = get(g:, 'airline_readonly_symbol', '  ')
"
"commented out pending taskd collision avoidance
"command! TaskPush call tw#remote('push')
"command! TaskPull call tw#remote('pull')
"command! TaskMerge call tw#remote('merge')
"
"commands;
"
command! -nargs=? -complete=customlist,taskwarrior#TW_complete TW :call taskwarrior#init(<q-args>)
"command! TWArchive
"command! TWArchiveCompleted
"command! TWArchiveDeleted
"command! TWArchiveNotes
"command! TWConfigColor
"command! TWConfigDiagnostic
"command! TWConfigSet
command! TWDeleteCompleted :call taskwarrior#clear_completed()
"command! TWDeleteNote
"command! TWEdit
"command! TWEditAnnotation
"command! TWEditDescription
command! TWEditTaskrc :execute "e ".$HOME."/.taskrc"
command! TWEditVitrc :execute "e ".$HOME."/.vitrc"
"command! TWExport
"command! TWHelp
"command! TWHelpCommands
"command! TWHelpQuick
"command! TWHistory
"command! TWInsert
"command! TWImport
"command! TWModify
"command! TWModifyIncrement
"command! TWModifyReplace
"command! TWNote
"command! TWOpen
"command! TWOpenInline
"command! TWPackage
"command! TWPackageInstall
"command! TWPackageList
"command! TWPackageRemove
"command! TWPackageUpdate
"command! TWReport
"command! TWReportAgenda
"command! TWReportBreak
"command! TWReportCalendar
"command! TWReportDesc
"command! TWReportEdit
"command! TWReportGantt
"command! TWReportProjects
"command! TWReportTags
"command! TWSyncFiles
"command! TWSyncStatus
"command! TWTheme
"command! TWThemeEdit
"command! TWThemeShow
command! TWUndo :call taskwarrior#undo()
"command! TWWiki
"command! TWWikiDiary
"command! TWWikiDiaryAdd
"command! TWWikiGenIndex
"command! TWWikiGenProject
"command! TWWikiGenTag
"command! TWWikiIndex
