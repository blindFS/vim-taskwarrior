syntax keyword taskwarrior_tablehead ID Project Pri Due A Age Urgency Description Completed Active Status
syntax match taskwarrior_ID /^\s*\zs\d\+/
syntax match taskwarrior_Due /\d\{1,2}\/\d\{1,2}\/\d\{4}/
syntax match taskwarrior_Seperater /^\(-\+\s*\)\{8,12}/
syntax match taskwarrior_Project /^\s*\d\+\s*\zs\S\+/
highlight default link taskwarrior_tablehead Keyword
highlight default link taskwarrior_ID VarId
highlight default link taskwarrior_Due Todo
highlight default link taskwarrior_Project Class
highlight default link taskwarrior_Seperater String
