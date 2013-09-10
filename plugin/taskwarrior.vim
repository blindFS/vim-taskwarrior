command! TaskList call taskwarrior#init()
command! TaskEditConfig :execute "e ".$HOME."/.taskrc"
command! TaskPush call taskwarrior#remote('push')
command! TaskPull call taskwarrior#remote('pull')
command! TaskMerge call taskwarrior#remote('merge')
