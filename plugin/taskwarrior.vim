command! TaskList call taskwarrior#init()
command! TaskCleanCompleted call taskwarrior#system_call(' status:completed ', 'delete', '')
