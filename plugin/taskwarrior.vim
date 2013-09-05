command! TaskList call taskwarrior#init()
command! TaskEditConfig :execute "e ".$HOME."/.taskrc"
