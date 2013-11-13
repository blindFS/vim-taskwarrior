let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
            \ 'name': 'task/bookmark',
            \ 'hooks' : {},
            \ 'filters' : ['matcher_regexp'],
            \ 'action_table': {},
            \ 'syntax' : 'uniteSource_task_bookmark'
            \ }

function! s:unite_source.hooks.on_syntax(args, context)
    syntax match uniteSource_task_bookmark_command /\%3c\w\+/ contained containedin=uniteSource_task_bookmark
    syntax match uniteSource_task_bookmark_rc /rc\..*$/ contained containedin=uniteSource_task_bookmark
    highlight default link uniteSource_task_bookmark_command Keyword
    highlight default link uniteSource_task_bookmark_rc String
endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(
                \ reverse(split(unite#util#system('cat '.g:task_log_directory.'/.vim_tw.bookmark'), "\n")),
                \ '{"word": v:val,
                \ "kind": "tasklog",
                \ "source": "task/bookmark",
                \ }')
endfunction

function! unite#sources#taskbookmark#define()
    return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
