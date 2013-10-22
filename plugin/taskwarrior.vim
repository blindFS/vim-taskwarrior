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
"command! TWInsert
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
