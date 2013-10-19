command! TW call taskwarrior#init()
command! TWEditConfig :execute "e ".$HOME."/.taskrc"
"
"commented out pending taskd collision avoidance
"command! TaskPush call taskwarrior#remote('push')
"command! TaskPull call taskwarrior#remote('pull')
"command! TaskMerge call taskwarrior#remote('merge')
