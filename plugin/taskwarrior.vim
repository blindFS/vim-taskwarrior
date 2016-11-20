if exists('g:loaded_taskwarrior') && g:loaded_taskwarrior
    finish
endif

if !executable('task')
    echoerr "This plugin depends on taskwarrior(https://taskwarrior.org)."
    finish
endif

let g:task_report_command           = get(g:, 'task_report_command', [])
let s:task_report_command           = ['active', 'all', 'blocked', 'blocking', 'completed', 'list', 'long', 'ls', 'minimal', 'newest', 'next', 'oldest', 'overdue', 'ready', 'recurring', 'unblocked', 'waiting']
let g:task_report_command           = extend(s:task_report_command, g:task_report_command)
let g:task_interactive_command      = ['annotate', 'denotate', 'execute', 'duplicate',
            \ 'append', 'prepend', 'stop', 'delete', 'done', 'undo',
            \ 'config', 'edit', 'start', 'sync', 'synchronize', 'add',
            \ 'modify', 'import', 'colors', 'color', 'logo', 'context']
let g:task_filter                   = ['description:', 'proj:', 'pri:', 'status:', 'tag:', 'due.before:', 'due.after:', 'entry.before', 'entry.after', 'end.before', 'end.after', '+']
let g:task_all_commands             = split(system('task _command'), '\n')
let g:task_all_configurations       = split(system('task _config'), '\n')
let g:task_report_name              = index(g:task_report_command, get(g:, 'task_report_name')) != -1 ? get(g:, 'task_report_name') : 'next'
let g:task_highlight_field          = get(g:, 'task_highlight_field', 1)
let g:task_readonly                 = get(g:, 'task_readonly', 0)
let g:task_rc_override              = get(g:, 'task_rc_override', '')
let g:task_default_prompt           = get(g:, 'task_default_prompt', ['due', 'project', 'priority', 'description', 'tag', 'depends'])
let g:task_info_vsplit              = get(g:, 'task_info_vsplit', 0)
let g:task_info_size                = get(g:, 'task_info_size', g:task_info_vsplit? 50 : 15)
let g:task_info_position            = get(g:, 'task_info_position', 'belowright')
" let g:task_log_directory = get(g:, 'task_log_file', system('task _get -- rc.data.location')[0:-2])
let g:task_log_directory            = get(g:, 'task_log_file', matchstr(system('task show | grep data.location')[0:-2], '\S*$'))
let g:task_log_max                  = get(g:, 'task_log_max', 10)
let g:task_left_arrow               = get(g:, 'task_left_arrow', ' <<')
let g:task_right_arrow              = get(g:, 'task_right_arrow', '>> ')
let g:task_readonly_symbol          = get(g:, 'task_readonly_symbol', '  ')
let g:task_gui_term                 = get(g:, 'task_gui_term', 1)
let g:task_columns_format           = {
            \ 'depends':     ['list', 'count', 'indicator'],
            \ 'description': ['combined', 'desc', 'oneline', 'truncated', 'count'],
            \ 'due':         ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'end':         ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'entry':       ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'id':          ['number'],
            \ 'imask':       ['number'],
            \ 'mask':        ['default'],
            \ 'modified':    ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'parent':      ['long', 'short'],
            \ 'priority':    ['short', 'long'],
            \ 'project':     ['full', 'parent', 'indented'],
            \ 'recur':       ['duration', 'indicator'],
            \ 'scheduled':   ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'start':       ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown', 'active'],
            \ 'status':      ['long', 'short'],
            \ 'tags':        ['list', 'indicator', 'count'],
            \ 'until':       ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'],
            \ 'urgency':     ['real', 'integer'],
            \ 'uuid':        ['long', 'short'],
            \ 'wait':        ['formatted', 'julian', 'epoch', 'iso', 'age', 'countdown'] }
"
"commented out pending taskd collision avoidance
"command! TaskPush call tw#remote('push')
"command! TaskPull call tw#remote('pull')
"command! TaskMerge call tw#remote('merge')
"
"commands;
"
command! -nargs=? -complete=customlist,taskwarrior#complete#TW TW :call taskwarrior#init(<q-args>)
command! -nargs=? TWReportInfo :call taskwarrior#action#show_info(<q-args>)
"command! TWConfigColor
command! TWDeleteCompleted :call taskwarrior#action#clear_completed()
"command! TWDeleteNote
"command! TWEdit
"command! TWEditAnnotation
"command! TWEditDescription
command! TWEditTaskrc :execute "e ".$HOME."/.taskrc"
command! TWEditVitrc :execute "e ".$HOME."/.vitrc"
command! TWEditTaskopenrc :execute "e ".$HOME."/.taskopenrc"
"command! TWExport
"command! TWHelp
command! TWHistory :Unite task/history
command! TWHistoryClear :call taskwarrior#log#history('clear')
command! TWBookmark :Unite task/bookmark
command! TWBookmarkClear :call taskwarrior#log#bookmark('clear')
"command! TWInsert
"command! TWImport
"command! TWNote
"command! TWOpen
"command! TWOpenInline
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
command! TWUndo :call taskwarrior#action#undo()
"command! TWWiki
"command! TWWikiDiary
"command! TWWikiDiaryAdd
"command! TWWikiGenIndex
"command! TWWikiGenProject
"command! TWWikiGenTag
"command! TWWikiIndex

let g:loaded_taskwarrior = 1
