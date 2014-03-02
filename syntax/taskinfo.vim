if exists("b:current_syntax")
    finish
endif

syntax match taskinfo_head /.*\%1l/
highlight default link taskinfo_head   Tabline

let b:current_syntax = 'taskinfo'
