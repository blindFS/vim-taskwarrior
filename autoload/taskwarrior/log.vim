if !isdirectory(expand(g:task_log_directory))
    call mkdir(expand(g:task_log_directory), 'p')
endif
let s:history_file  = expand(g:task_log_directory.'/.vim_tw.history')
let s:bookmark_file = expand(g:task_log_directory.'/.vim_tw.bookmark')

function! taskwarrior#log#history(action)
    if findfile(s:history_file) == ''
        call writefile([], s:history_file)
    endif
    if a:action == 'write' && filewritable(s:history_file) && b:hist == 1
        let fl = readfile(s:history_file)
        let numb = len(fl)
        let last = numb ? substitute(fl[-1], '\v($|\n|\t|\s)', '', 'g') : ''
        let current = join([b:command, b:filter, b:rc], '	')
        if last == substitute(current, '[\t ]', '', 'g')
            return
        endif
        call add(fl, current)
        if numb >= g:task_log_max
            call remove(fl, 0)
        endif
        call writefile(fl, s:history_file)
    elseif a:action == 'read' && filereadable(s:history_file)
        call taskwarrior#init(join(split(readfile(s:history_file)[-1], '	'), ' '))
    elseif a:action == 'clear'
        call writefile([], s:history_file)
    elseif a:action != 'write'
        let hists = readfile(s:history_file)
        if a:action == 'previous'
            if b:hist >= len(hists)
                return
            endif
            let b:hist += 1
        elseif a:action == 'next'
            if b:hist == 1
                return
            endif
            let b:hist -= 1
        endif
        let hlist = split(substitute(hists[-b:hist], '\v($|\n)', ' ', ''), '	')
        if len(hlist) != 3
            return
        endif
        let [b:command, b:filter, b:rc] = hlist
        call taskwarrior#list()
    endif
endfunction

function! taskwarrior#log#bookmark(action)
    if findfile(s:bookmark_file) == ''
        call writefile([], s:bookmark_file)
    endif
    if a:action == 'new' && filewritable(s:bookmark_file)
        let now = b:command.'	'.b:filter.'	'.b:rc
        let ext = readfile(s:bookmark_file)
        if index(ext, now) == -1
            execute 'redir >> '.s:bookmark_file
            silent! echo now
            redir END
            echohl String
            echomsg 'New bookmark added.'
            echohl None
        endif
    elseif a:action == 'clear'
        call writefile([], s:bookmark_file)
    endif
endfunction
