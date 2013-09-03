syntax keyword taskwarrior_Tablehead ID Project Pri Due A Age Urgency Description Complete Active Status UUID
let exp = 'syntax match taskwarrior_%s /^.\{%d}/ contains=taskwarrior_%s'
if exists("b:task_columns")
    execute printf(exp, 'ID'         , b:task_columns[1], '')
    execute printf(exp, 'Project'    , b:task_columns[2], 'ID')
    execute printf(exp, 'Status'     , b:task_columns[3], 'Project')
    execute printf(exp, 'Pri'        , b:task_columns[4], 'Status')
    execute printf(exp, 'Due'        , b:task_columns[5], 'Pri')
    execute printf(exp, 'Complete'   , b:task_columns[6], 'Due')
    execute printf(exp, 'Description', b:task_columns[7], 'Complete')
    execute printf(exp, 'UUID'       , len(getline(2))  , 'Description')
endif
highlight default link taskwarrior_Tablehead Type
highlight default link taskwarrior_ID VarId
highlight default link taskwarrior_Project String
highlight default link taskwarrior_Status Include
highlight default link taskwarrior_Pri Class
highlight default link taskwarrior_Due Todo
highlight default link taskwarrior_Complete Keyword
highlight default link taskwarrior_Description Normal
highlight default link taskwarrior_UUID VarId
