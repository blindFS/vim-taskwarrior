let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#task#define()
    return s:kind
endfunction

let s:kind = {
            \ 'name' : 'task',
            \ 'default_action' : 'show',
            \ 'action_table': {},
            \}

let s:kind.action_table.show = {
            \ 'description' : 'Show report',
            \ }

function! s:kind.action_table.show.func(candidate)
    call taskwarrior#init(join(split(a:candidate.word, '[ \t]'), ' '))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
