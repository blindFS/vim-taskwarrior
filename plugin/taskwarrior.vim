if exists('g:loaded_taskwarrior') && g:loaded_taskwarrior
  echo "taskwarrior loaded"
  finish
endif

" FIRST -- WSL env in Windows OR native Linux env
let s:is_win                        = has('win32') || has('win64')

if s:is_win
  let g:tw_cmd = 'wsl task'
  let g:tw_grep = 'findstr'
else
  let g:tw_cmd = 'task'
  let g:tw_grep = 'grep'
endif

" override from vimrc
let g:tw_cmd                        = get(g:, 'taskwarrior_cmd', 'task')
" let g:tw_grep                       = get(g:, 'taskwarrior_grep_cmd', 'grep')

" if !executable(system(g:tw_cmd))
    " echoerr "This plugin depends on taskwarrior(https://taskwarrior.org)."
    " finish
" endif

" global variable settings
let g:task_report_command           = get(g:, 'task_report_command', [])
let s:task_report_command           = ['active', 'all', 'blocked', 'blocking',  'burndown.daily', 'burndown.monthly', 'burndown.weekly', 'completed',
                                      \'ghistory.annual', 'ghistory.monthly', 'history.annual', 'history.monthly',  'information', 'list', 'long', 'ls',
                                      \'minimal', 'newest', 'next', 'oldest', 'overdue', 'projects', 'ready', 'recurring',  'summary',  'tags', 'unblocked', 'waiting']
let g:task_report_command           = extend(s:task_report_command, g:task_report_command)

let g:task_interactive_command      = ['annotate', 'denotate', 'execute', 'duplicate',
                                      \ 'append', 'prepend', 'stop', 'delete', 'done', 'undo',
                                      \ 'config', 'edit', 'start', 'sync', 'synchronize', 'add',
                                      \ 'modify', 'import', 'colors', 'color', 'logo', 'context']

let g:task_all_commands             = split(system(g:tw_cmd.' _command'), '\n')

let g:task_filter                   = ['description:', 'proj:', 'pri:', 'status:', 'tag:', 'due.before:', 'due.after:', 'entry.before', 'entry.after', 'end.before', 'end.after', '+']
let g:task_all_configurations       = split(system(g:tw_cmd.' _config'), '\n')
let g:task_report_name              = index(g:task_report_command, get(g:, 'task_report_name')) != -1 ? get(g:, 'task_report_name') : 'next'
let g:task_highlight_field          = get(g:, 'task_highlight_field', 1)
let g:task_readonly                 = get(g:, 'task_readonly', 0)
let g:task_rc_override              = get(g:, 'task_rc_override', '')
let g:task_default_prompt           = get(g:, 'task_default_prompt', ['due', 'project', 'priority', 'description', 'tag', 'depends']) " what to show when adding / modifying item
let g:task_info_vsplit              = get(g:, 'task_info_vsplit', 0)
let g:task_info_size                = get(g:, 'task_info_size', g:task_info_vsplit? 50 : 15)
let g:task_info_position            = get(g:, 'task_info_position', 'belowright')
let g:task_log_directory            = get(g:, 'task_log_file', matchstr(system(g:tw_cmd.' show | '.g:tw_grep.' data.location')[0:-2], '\S*$'))
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
command! -nargs=? -complete=customlist,taskwarrior#complete#TW TW :call taskwarrior#init(<q-args>)
command! -buffer TWAdd               :call taskwarrior#action#new()
command! -nargs=? TWReportInfo :call taskwarrior#action#show_info(<q-args>)
command! TWDeleteCompleted :call taskwarrior#action#clear_completed()
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
"command! TWSyncFiles
"command! TWSyncStatus
"command! TWTheme
command! TWUndo :call taskwarrior#action#undo()

let g:loaded_taskwarrior = 1
