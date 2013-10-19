command! TW call taskwarrior#init()
command! TWConfigEdit :execute "e ".$HOME."/.taskrc"
"
"commented out pending taskd collision avoidance
"command! TaskPush call taskwarrior#remote('push')
"command! TaskPull call taskwarrior#remote('pull')
"command! TaskMerge call taskwarrior#remote('merge')
"
"command ideas;
"
"command! TWAdd
"command! TWAnnotate
"command! TWComplete
"command! TWDelete
"command! TWDeleteAnnotation
"command! TWEdit
"command! TWModify
"command! TWSync
"command! TWSyncStatus
"command! TWTheme
"command! TWUndo
"command! TWConfigShow
"command! TWWiki
"command! TWWikiIndex
