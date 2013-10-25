let g:task_report_command = ['active', 'all', 'blocked', 'completed', 'list', 'long', 'ls', 'minimal', 'newest', 'next', 'oldest', 'overdue', 'ready', 'recurring', 'unblocked', 'waiting']
let g:task_all_commands = split(system('task _command'), '\n')
let g:task_filter = ['id:', 'description:', 'due:', 'proj:', 'pri:', 'status:', 'tag:']
let g:task_report_name = index(g:task_report_command, get(g:, 'task_report_name')) != -1 ? get(g:, 'task_report_name') : 'next'
"
"commented out pending taskd collision avoidance
"command! TaskPush call tw#remote('push')
"command! TaskPull call tw#remote('pull')
"command! TaskMerge call tw#remote('merge')
"
"commands;
"
command! -nargs=? -complete=customlist,s:cmdcomplete TW :call taskwarrior#init(<q-args>)
"command! TWAdd
"command! TWAnnotate
"command! TWArchive
"command! TWArchiveCompleted
"command! TWArchiveDeleted
"command! TWArchiveNotes
"command! TWComplete
"command! TWConfigColor
"command! TWConfigDiagnostic
"command! TWConfigGet
"command! TWConfigSet
"command! TWConfigShow
"command! TWDelete
"command! TWDeleteAnnotation
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
"command! TWReportInfo
"command! TWReportProjects
"command! TWReportSort
"command! TWReportTags
command! TWSync call taskwarrior#sync('sync')
"command! TWSyncFiles
"command! TWSyncStatus
"command! TWTheme
"command! TWThemeEdit
"command! TWThemeShow
"command! TWUndo
"command! TWWiki
"command! TWWikiDiary
"command! TWWikiDiaryAdd
"command! TWWikiGenIndex
"command! TWWikiGenProject
"command! TWWikiGenTag
"command! TWWikiIndex

" TODO get proper value to complete
function! s:cmdcomplete(A,L,P)
    let candidates = g:task_all_commands
    let lead = a:A == '' ? '.*' : a:A
    if index(candidates, matchstr(a:L, '\S\+\ze\s\+\S*$')) != -1
        let candidates = g:task_filter
    endif
    return filter(candidates, 'matchstr(v:val,"'.lead.'") != ""')
endfunction
