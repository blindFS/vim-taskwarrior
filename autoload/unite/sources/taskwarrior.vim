let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
            \ 'name': 'task',
            \ 'hooks' : {},
            \ 'filters' : ['matcher_regexp'],
            \ 'action_table': {},
            \ 'syntax' : 'uniteSource__Task'
            \ }

" function! s:unite_source.hooks.on_syntax(args, context)
" endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(
                \ split(unite#util#system('task '.g:task_report_name), "\n")[2:],
                \ '{"word": v:val,
                \ "kind": "word",
                \ "source": "character",
                \ }')
endfunction

function! unite#sources#taskwarrior#define()
    return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
