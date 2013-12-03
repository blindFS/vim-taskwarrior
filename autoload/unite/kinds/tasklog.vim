let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#tasklog#define()
    return s:kind
endfunction

let s:kind = {
            \ 'name' : 'tasklog',
            \ 'default_action' : 'show',
            \ 'action_table': {},
            \}

let s:kind.action_table.show = {
            \ 'description' : 'Show report',
            \ }

function! s:kind.action_table.show.func(candidate)
    call taskwarrior#init(join(split(a:candidate.word, '[ \t]'), ' '))
endfunction
