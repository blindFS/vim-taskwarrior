let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
            \ 'name': 'task/history',
            \ 'hooks' : {},
            \ 'filters' : ['matcher_regexp'],
            \ 'action_table': {},
            \ 'syntax' : 'uniteSource_task_history'
            \ }

function! s:unite_source.hooks.on_syntax(args, context)
    syntax match uniteSource_task_history_command /\%3c\w\+/ contained containedin=uniteSource_task_history
    syntax match uniteSource_task_history_rc /rc\..*$/ contained containedin=uniteSource_task_history
    highlight default link uniteSource_task_history_command Keyword
    highlight default link uniteSource_task_history_rc String
endfunction

function! s:unite_source.gather_candidates(args, context)
    if findfile(g:task_log_directory.'/.vim_tw.history') == ''
        call system('touch '.g:task_log_directory.'/.vim_tw.history')
    endif
    return map(
                \ reverse(split(unite#util#system('cat '.g:task_log_directory.'/.vim_tw.history'), "\n")),
                \ '{"word": v:val,
                \ "kind": "tasklog",
                \ "source": "task/history",
                \ }')
endfunction

function! unite#sources#taskhistory#define()
    return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
