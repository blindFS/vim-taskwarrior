function! taskwarrior#list()
    setlocal modifiable
    %delete
    " for var in split((system("task all")),'\n')[:-4]
    "     echom var
    " endfor
    call append(0, split((system("task all")),'\n')[:-3])
    silent! %global/\n^\s\{2,}/join
    if len(getline(1)) == 0
        call append(line('$')-1,
                    \['ID Status Project Pri Due Completed Active Age Description',
                    \'-- ------ ------- --- --- --------- ------ --- -----------'])
    endif
    let b:task_columns = [0]
    for col in range(len(getline(1))-1)
        if getline(1)[col] == " " && getline(1)[col+1] != " "
            let b:task_columns += [col+1]
        endif
    endfor
    normal gg
    setlocal ft=taskwarrior
    setlocal syntax=taskwarrior
    setlocal buftype=nofile
    setlocal nomodifiable

    nnoremap <buffer> q :call taskwarrior#quit()<CR>
    nnoremap <buffer> c :call taskwarrior#system_call(' ', 'add', taskwarrior#get_args())<CR>
    " nnoremap <buffer> d :call taskwarrior#system_call(taskwarrior#get_filter_by_id(), 'done', '')<CR>
    nnoremap <buffer> x :call taskwarrior#delete()<CR>
    nnoremap <buffer> m :call taskwarrior#system_call(taskwarrior#get_filter_by_id(), 'modify', taskwarrior#get_args())<CR>

endfunction

function! taskwarrior#init()
    if !executable('task')
       echoerr "This plugin depends on taskwarrior(http://taskwarrior.org)."
    endif
    if exists('g:task_view')
        execute g:task_view.'buffer'
    else
        execute 'edit Taskwarrior'
        let g:task_view = bufnr('%')
        setlocal noswapfile
    endif
    call taskwarrior#list()

endfunction

function! taskwarrior#quit()
    silent! execute g:task_view.'bd!'
    unlet g:task_view
endfunction

function! taskwarrior#delete()
    echom "!task ".taskwarrior#get_uuid()." delete"
    execute "!task ".taskwarrior#get_uuid()." delete"
    call taskwarrior#list()
endfunction

function! taskwarrior#get_args()
    let due = input("due - '1h','2d','3w'...:")
    let project = input("project:")
    let priority = input("priority - 'L','M','H':")
    let description = input("description:")
    return " due:".due." project:".project." priority:".priority." ".description
endfunction

function! taskwarrior#get_id()
    if matchstr(getline('.'), '^\s*\zs\d\+') != ""
        return " ".matchstr(getline('.'), '^\s*\zs\d\+')." "
    endif
    return 1
endfunction

function! taskwarrior#system_call(filter, command, args)
    call system("task".a:filter.a:command.a:args)
    " TODO refresh bug
    call taskwarrior#list()
endfunction

function! taskwarrior#get_uuid()
    if !taskwarrior#get_id()
        return substitute(system('task'.taskwarrior#get_id().'uuids'), '\n', '', 'g')
    endif
    if line('.') > 2 && line('.') < line('$')
        let uuids = []
        for line in split(system('task completed'), '\n')[1:-2]
            let uuids += [matchstr(line, '[-0-9a-f]\{36}')]
        endfor
        return uuids[line('.')-2]
    endif
    return ' '
endfunction
