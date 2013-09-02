syntax keyword taskwarrior_tablehead ID Project Pri Due A Age Urgency Description Complete Active Status UUID
syntax keyword taskwarrior_status Completed Pending
syntax match taskwarrior_ID /^\s*\zs\d\+/
syntax match taskwarrior_UUID /[0-9a-f]\{8}\(-[0-9a-f]\{4}\)\{3}-[0-9a-f]\{12}/
syntax match taskwarrior_Due /\d\{1,2}\/\d\{1,2}\/\d\{4}/
syntax match taskwarrior_Seperater /^\(-\+\s*\)\{8,12}/
highlight default link taskwarrior_tablehead Keyword
highlight default link taskwarrior_status Include
highlight default link taskwarrior_ID VarId
highlight default link taskwarrior_UUID VarId
highlight default link taskwarrior_Due Todo
highlight default link taskwarrior_Seperater String
