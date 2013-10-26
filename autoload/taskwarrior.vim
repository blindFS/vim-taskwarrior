function! taskwarrior#list(...) abort
    let pos = getpos('.')
    setlocal modifiable
    setlocal nowrap
    %delete
    if a:0 > 0
        let b:command = join(a:000, ' ')
    endif
    if !exists('b:command')
        let b:command = ''
    endif

    let [re_cmd, type] = taskwarrior#command_type()

    if type == 'special'
        call append(0, split((system("task ".b:command)), '\n'))
        setlocal filetype=text
    else
        call append(0, split((system("task ".b:command)), '\n')[:-3])
        let b:task_report_columns = split(substitute(substitute(system("task _get -- rc.report.".re_cmd.".columns"), '*\|\n', '', 'g'), '\.', '_', 'g'), ',')
        let b:task_report_labels = split(substitute(system("task _get -- rc.report.".re_cmd.".labels"), '*\|\n', '', 'g'), ',')
        let line1 = join(b:task_report_labels, ' ')
        let line2 = substitute(line1, '\S', '-', 'g')

        if len(getline(1)) == 0
            call append(line('$')-1, [line1, line2])
        endif

        for label in b:task_report_labels
            if index(split(getline(1), ' '), label) == -1
                call remove(b:task_report_columns, index(b:task_report_labels, label))
                call remove(b:task_report_labels, index(b:task_report_labels, label))
            endif
        endfor

        let b:task_columns = [0]
        for col in range(len(getline(1))-1)
            if getline(1)[col] == " " && getline(1)[col+1] != " "
                let b:task_columns += [col+1]
            endif
        endfor
        setlocal filetype=taskwarrior
    endif

    setlocal buftype=nofile
    setlocal nomodifiable

    nnoremap <buffer> A :call taskwarrior#annotate('add')<CR>
    nnoremap <buffer> D :call taskwarrior#delete()<CR>
    nnoremap <buffer> a :call taskwarrior#system_call('', 'add', taskwarrior#get_args(), 'echo')<CR>
    nnoremap <buffer> d :call taskwarrior#set_done()<CR>
    nnoremap <buffer> m :call taskwarrior#modify()<CR>
    nnoremap <buffer> q :call taskwarrior#quit()<CR>
    nnoremap <buffer> r :call taskwarrior#clear_completed()<CR>
    nnoremap <buffer> u :call taskwarrior#undo()<CR>
    nnoremap <buffer> x :call taskwarrior#annotate('del')<CR>
    nnoremap <buffer> s :call taskwarrior#sync('sync')<CR>
    nnoremap <buffer> <CR> :call taskwarrior#info(taskwarrior#get_uuid().' info')<CR>
    nnoremap <buffer> <left> :call taskwarrior#move_cursor('left')<CR>
    nnoremap <buffer> <S-tab> :call taskwarrior#move_cursor('left')<CR>
    nnoremap <buffer> <tab> :call taskwarrior#move_cursor('right')<CR>
    nnoremap <buffer> <right> :call taskwarrior#move_cursor('right')<CR>

    call setpos('.', pos)

endfunction

function! taskwarrior#init(...)
    if !executable('task')
       echoerr "This plugin depends on taskwarrior(http://taskwarrior.org)."
    endif
    if exists('g:task_view')
        call taskwarrior#quit()
    endif

    execute 'edit task\ '.escape(join(a:000, ' '), ' ')
    let g:task_view = bufnr('%')
    setlocal noswapfile
    call taskwarrior#list(join(a:000, ' '))

endfunction

function! taskwarrior#quit()
    silent! execute g:task_view.'bd!'
    unlet g:task_view
endfunction

function! taskwarrior#modify()
    if !exists('b:task_columns') || !exists('b:task_report_columns') || taskwarrior#get_id() =~ '^\s*$'
        return
    endif
    let field = b:task_report_columns[taskwarrior#current_column()]
    if field == 'uuid'
        return
    elseif field == 'description'
        call taskwarrior#system_call(taskwarrior#get_id(), 'modify', taskwarrior#get_args(field), 'interactive')
    else
        call taskwarrior#system_call(taskwarrior#get_id(), 'modify', taskwarrior#get_args(field), 'echo')
    endif
endfunction

function! taskwarrior#delete()
    execute "!task ".taskwarrior#get_uuid()." delete"
    call taskwarrior#list()
endfunction

function! taskwarrior#annotate(op)
    let annotation = input("annotation:")
    if a:op == 'add'
        call taskwarrior#system_call(taskwarrior#get_uuid(), ' annotate ', annotation, 'silent')
    else
        call taskwarrior#system_call(taskwarrior#get_uuid(), ' denotate ', annotation, 'silent')
    endif
endfunction

function! taskwarrior#set_done()
    call taskwarrior#system_call(taskwarrior#get_uuid(), ' done', '', 'silent')
endfunction

function! taskwarrior#get_args(...)
    if a:0 != 0
        let arg = ' '
        for key in a:000
            execute 'let this_'.key.'=input("'.key.':")'
            if key == 'description'
                execute "let arg = arg.' '.this_".key
            else
                execute "let arg = arg.' '.key.':'.this_".key
            endif
        endfor
        return arg
    else
        return taskwarrior#get_args('due', 'project', 'priority', 'description', 'tag', 'depends')
    endif
endfunction

function! taskwarrior#get_id()
    return matchstr(getline('.'), '^\s*\zs\d\+')." "
endfunction

function! taskwarrior#system_call(filter, command, args, mode)
    if a:mode == 'silent'
        call system("task ".a:filter.a:command.a:args)
    elseif a:mode == 'echo'
        echo "\n----------------\n"
        echo system("task ".a:filter.a:command.a:args)
    else
        execute '!task '.a:filter.a:command.a:args
    endif
    call taskwarrior#list()
endfunction

function! taskwarrior#get_uuid()
    if !exists('b:task_report_columns') || index(b:task_report_columns, 'uuid') == -1
        return taskwarrior#get_id()
    endif
    return matchstr(getline('.'), '[0-9a-f]\{8}\(-[0-9a-f]\{4}\)\{3}-[0-9a-f]\{12}')
endfunction

function! taskwarrior#undo()
    if has("gui_running")
        if executable('xterm')
            silent !xterm -e "task undo"
        endif
    else
        !task undo
    endif
    call taskwarrior#list()
endfunction

function! taskwarrior#info(command)
    for line in split(system("task ".a:command), '\n')
        echo line
    endfor
endfunction

function! taskwarrior#clear_completed()
    !task status:completed delete
    call taskwarrior#init()
endfunction

function! taskwarrior#sync(action)
    execute '!task '.a:action.' '
    if exists('g:task_view')
        call taskwarrior#list()
    endif
endfunction

function! taskwarrior#command_type()
    for sub in split(b:command, ' ')
        if index(g:task_report_command, sub) != -1
            return [ sub, 'report' ]
        elseif index(g:task_interactive_command, sub) != -1
            execute '!task '.b:command
            let b:command = g:task_report_name
            return [ g:task_report_name, 'report' ]
        elseif index(g:task_all_commands, sub) != -1
            return [ sub, 'special' ]
        endif
    endfor

    let b:command = b:command.' '.g:task_report_name
    return [ g:task_report_name, 'report' ]
endfunction

function! taskwarrior#move_cursor(direction)
    let ci = taskwarrior#current_column()
    if ci == -1 || (ci == 0 && a:direction == 'left') || (ci == len(b:task_columns)-1 && a:direction == 'right')
        return
    endif
    if a:direction == 'left'
        call search('\%'.(b:task_columns[ci-1]+1).'v', 'be')
    else
        call search('\%'.(b:task_columns[ci+1]+1).'v', 'e')
    endif
endfunction

function! taskwarrior#current_column()
    if getline('.') =~ '^\s*$' || !exists('b:task_columns') || !exists('b:task_report_columns')
        return -1
    endif
    let i = 0
    while  i < len(b:task_columns) && len(getline('.')[0:getpos('.')[2]-1]) > len(matchstr(getline('.'), '^.*\%'.b:task_columns[i].'v'))
        let i += 1
    endwhile
    return i-1
endfunction
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent
