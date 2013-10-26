if exists('b:task_report_labels')
    for word in b:task_report_labels
        execute "syntax keyword taskwarrior_Tablehead ".word
    endfor
endif
let exp = 'syntax match taskwarrior_%s /^.*\%%<%dv/ contains=taskwarrior_%s'
if exists('b:task_columns') && exists('b:task_report_columns')
    execute printf(exp, b:task_report_columns[0], b:task_columns[1]+1, '')
    for i in range(1, len(b:task_report_columns)-2)
        if exists('b:task_columns['.(i+1).']')
            execute printf(exp, b:task_report_columns[i] , b:task_columns[i+1]+1, b:task_report_columns[i-1])
        endif
    endfor
    execute printf(exp, b:task_report_columns[-1], len(getline(2))+2, b:task_report_columns[-2])
endif
highlight default link taskwarrior_tablehead   Type
highlight default link taskwarrior_id          VarId
highlight default link taskwarrior_project     String
highlight default link taskwarrior_Status      Include
highlight default link taskwarrior_priority    Class
highlight default link taskwarrior_due         Todo
highlight default link taskwarrior_end         Keyword
highlight default link taskwarrior_description Normal
highlight default link taskwarrior_entry_age   Special
highlight default link taskwarrior_depends     Todo
highlight default link taskwarrior_tags        Keyword
highlight default link taskwarrior_uuid        VarId
highlight default link taskwarrior_urgency     Todo
