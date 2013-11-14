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

let s:unite_source.action_table.delete = {
            \ 'description' : 'remove the bookmark',
            \ }

function! s:unite_source.action_table.delete.func(candidate)
    let current = substitute(a:candidate.word, '\s', '', 'g')
    let file = g:task_log_directory.'/.vim_tw.bookmark'
    let all = split(system('cat '.file), '\n')
    let allns = map(copy(all), "substitute(v:val, '[ \t]', '', 'g')")
    call remove(all, index(allns, current))
    execute 'redir! > '.file
    for line in all
        silent! echo line
    endfor
    redir END
endfunction

function! s:unite_source.gather_candidates(args, context)
    if findfile(g:task_log_directory.'/.vim_tw.bookmark') == ''
        call system('touch '.g:task_log_directory.'/.vim_tw.bookmark')
    endif
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
