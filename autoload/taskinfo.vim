function! taskinfo#init(command, filter, info)
    if exists('g:task_info')
        call taskinfo#quit()
    endif

    if a:command != 'info'
                \ && exists('g:task_info_arg')
                \ && g:task_info_arg == [a:command, a:filter]
        unlet g:task_info_arg
        return
    endif

    execute g:task_info_position.' '.g:task_info_size.
                \ (g:task_info_vsplit ? 'v' : '').'split'
    edit taskinfo
    let g:task_info = bufnr('%')
    let g:task_info_arg = [a:command, a:filter]
    setlocal noswapfile
    setlocal modifiable
    call append(0, a:info)
    silent global/^[\t ]*$/delete
    silent global/^[ -]\+$/delete
    setlocal readonly
    setlocal nomodifiable
    setlocal buftype=nofile
    setlocal nowrap
    setlocal filetype=taskinfo
    1

    let b:command = a:command
    let b:filter = a:filter

    nnoremap <silent> <buffer> q :call taskinfo#quit()<CR>
    nnoremap <silent> <buffer> <enter> :call taskinfo#quit()<CR>

    if a:command != 'info'
        wincmd W
    endif
endfunction

function! taskinfo#quit()
    silent! execute g:task_info.'bd!'
    unlet g:task_info
endfunction
