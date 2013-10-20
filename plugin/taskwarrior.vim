"
"commented out pending taskd collision avoidance
"command! TaskPush call taskwarrior#remote('push')
"command! TaskPull call taskwarrior#remote('pull')
"command! TaskMerge call taskwarrior#remote('merge')
"
"commands;
"
command! TW call taskwarrior#init()
"command! TWAdd
"command! TWAnnotate
"command! TWArchive
"command! TWArchiveCompleted
"command! TWArchiveDeleted
"command! TWArchiveNotes
"command! TWComplete
"command! TWConfigDiagnostic
"command! TWConfigGet
"command! TWConfigSet
"command! TWConfigShow
"command! TWDelete
"command! TWDeleteAnnotation
"command! TWDeleteCompleted
"command! TWDeleteNote
"command! TWEdit
"command! TWEditAnnotation
"command! TWEditDescription
command! TWEditTaskrc :execute "e ".$HOME."/.taskrc"
command! TWEditVimrc :execute "e ".$HOME."/.vimrc"
"command! TWExport
"command! TWHelp
"command! TWHistory
"command! TWModify
"command! TWNote
"command! TWOpen
"command! TWOpenInline
command! TWSync call taskwarrior#remote('sync')
"command! TWSyncFiles 
"command! TWSyncStatus
"command! TWTheme
"command! TWThemeEdit
"command! TWUndo
"command! TWWiki
"command! TWWikiGenIndex
"command! TWWikiGenProject
"command! TWWikiGenTag
"command! TWWikiIndex
