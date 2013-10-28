let g:task_report_command = ['active', 'all', 'blocked', 'blocking', 'completed', 'list', 'long', 'ls', 'minimal', 'newest', 'next', 'oldest', 'overdue', 'ready', 'recurring', 'unblocked', 'waiting']
let g:task_interactive_command = ['delete', 'undo', 'config', 'edit', 'start', 'sync', 'synchronize', 'add', 'modify', 'import', 'colors', 'logo']
let g:task_all_commands = split(system('task _command'), '\n')
let g:task_all_configurations = split(system('task _config'), '\n')
let g:task_filter = ['id:', 'description:', 'due:', 'proj:', 'pri:', 'status:', 'tag:']
let g:task_report_name = index(g:task_report_command, get(g:, 'task_report_name')) != -1 ? get(g:, 'task_report_name') : 'next'
let g:task_highlight_field = get(g:, 'task_highlight_field', 1)
let g:task_field_highlight_link = get(g:, 'task_field_highlight_link', 'IncSearch')
let g:task_field_highlight_advanced = get(g:, 'task_field_highlight_advanced', '')
let g:task_readonly = get(g:, 'task_readonly', 0)
let g:task_rc_override = get(g:, 'task_rc_override', '')
"
"commented out pending taskd collision avoidance
"command! TaskPush call tw#remote('push')
"command! TaskPull call tw#remote('pull')
"command! TaskMerge call tw#remote('merge')
"
"commands;
"
command! -nargs=? -complete=customlist,s:cmdcomplete TW :call taskwarrior#init(<q-args>)
command! TWAdd :call taskwarrior#system_call('', 'add', taskwarrior#get_args(), 'interactive')
command! TWAnnotate :call taskwarrior#annotate('add')
"command! TWArchive
"command! TWArchiveCompleted
"command! TWArchiveDeleted
"command! TWArchiveNotes
command! TWComplete :call taskwarrior#set_done()
"command! TWConfigColor
"command! TWConfigDiagnostic
"command! TWConfigSet
command! TWDelete :call taskwarrior#delete()
command! TWDeleteAnnotation :call taskwarrior#annotate('del')
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
command! TWModifyInteractive :call taskwarrior#system_call(taskwarrior#get_id(), 'modify', taskwarrior#get_args(), 'interactive')
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
command! TWReportInfo :call taskwarrior#info(taskwarrior#get_uuid().' info')
"command! TWReportProjects
"command! TWReportSort
"command! TWReportTags
command! TWSync call taskwarrior#sync('sync')
"command! TWSyncFiles
"command! TWSyncStatus
"command! TWTheme
"command! TWThemeEdit
"command! TWThemeShow
command! TWToggleReadonly :let g:task_readonly = (g:task_readonly ? 0 : 1) | call taskwarrior#init()
command! TWToggleHLField :let g:task_highlight_field = (g:task_highlight_field ? 0 : 1) | call taskwarrior#refresh()
command! TWUndo :call taskwarrior#undo()
"command! TWWiki
"command! TWWikiDiary
"command! TWWikiDiaryAdd
"command! TWWikiGenIndex
"command! TWWikiGenProject
"command! TWWikiGenTag
"command! TWWikiIndex

function! s:cmdcomplete(A,L,P)
    let command = deepcopy(g:task_all_commands)
    let filter = deepcopy(g:task_filter)
    let config = deepcopy(g:task_all_configurations)
    let lead = a:A == '' ? '.*' : a:A
    for ph in split(a:L, ' ')[0:-1]
        if ph == 'config' || ph == 'show'
            return filter(config, 'matchstr(v:val,"'.lead.'") != ""')
        elseif index(command, ph) != -1
            return filter(filter, 'matchstr(v:val,"'.lead.'") != ""')
        endif
    endfor
    return filter(command+filter, 'matchstr(v:val,"'.lead.'") != ""')
endfunction
