function! taskwarrior#list(...) abort
    setlocal noreadonly
    setlocal modifiable
    let pos = getpos('.')
    %delete
    call taskwarrior#buffer_var_init()
    let b:filter  = exists('a:1') ? a:1 :b:filter
    let b:command = exists('a:2') ? a:2 : b:command
    let b:type    = exists('a:3') ? a:3 : b:type
    let b:rc      = exists('a:4') ? a:4 : b:rc

    if b:type == 'special'
        setlocal buftype=nofile
        call append(0, split((system("task ".b:rc.' '.b:filter.' '.b:command)), '\n'))
        execute 'setlocal filetype=task'.b:command
        nnoremap <buffer> q :call taskwarrior#quit()<CR>
        call setpos('.', pos)
        return
    endif

    let b:summary = taskwarrior#global_stats()
    let b:sort = taskwarrior#sort_order_list()[0]
    let context = split((system("task ".b:rc.' '.b:filter.' '.b:command)), '\n')
    call append(0, context[:-3])
    global/^\s*$/delete
    let b:task_report_columns = split(substitute(system("task _get -- rc.report.".b:command.".columns"), '*\|\n', '', 'g'), ',')
    let b:task_report_labels = split(substitute(system("task _get -- rc.report.".b:command.".labels"), '*\|\n', '', 'g'), ',')
    let line1 = join(b:task_report_labels, ' ')

    if len(getline(1)) == 0
        call append(line('$')-1, line1)
    else
        2d
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
    let b:task_columns += [999]
    setlocal filetype=taskreport
    call setpos('.', pos)

endfunction

function! taskwarrior#buffer_var_init()
    let b:command = exists('b:command')? b:command : g:task_report_name
    let b:filter  = exists('b:filter')?  b:filter  : ''
    let b:type    = exists('b:type')?    b:type    : 'report'
    let b:rc      = exists('b:rc')?      b:rc      : g:task_rc_override
endfunction

function! taskwarrior#init(...)
    if !executable('task')
       echoerr "This plugin depends on taskwarrior(http://taskwarrior.org)."
       return
    endif

    let argstring = substitute(join(a:000, ' '), 'rc\.\S*', '', 'g')
    let [command, filter, type] = taskwarrior#command_type(argstring)
    let rc = g:task_rc_override
    if type == 'interactive'
        if !g:task_readonly
            execute '!task '.argstring
            call taskwarrior#refresh()
        endif
        return
    endif

    if exists('g:task_view')
        if a:0 == 0
            execute g:task_view.'buffer'
            let command = exists('b:command')? b:command : g:task_report_name
            let filter = exists('b:filter')? b:filter : ''
            let type = exists('b:type')? b:type : 'report'
            let rc = exists('b:rc')? b:rc : g:task_rc_override
        endif
        call taskwarrior#quit()
    endif

    execute 'edit task\ '.command
    let g:task_view = bufnr('%')
    setlocal noswapfile
    call taskwarrior#list(filter, command, type, rc)

endfunction

function! taskwarrior#refresh()
    if exists('g:task_view')
        execute g:task_view.'buffer'
        call taskwarrior#list()
    else
        call taskwarrior#init()
    endif
endfunction

function! taskwarrior#hi_field()
    silent! syntax clear taskwarrior_field
    let index = taskwarrior#current_index()
    execute 'syntax match taskwarrior_field /\%>1l\%'.line('.').'l\%'.(b:task_columns[index]+1).'v.*\%<'.(b:task_columns[index+1]+1).'v/'
endfunction

function! taskwarrior#quit()
    silent! execute g:task_view.'bd!'
    unlet g:task_view
endfunction

function! taskwarrior#modify(mode)
    let uuid = taskwarrior#get_uuid()
    if uuid =~ '^\s*$'
        return
    endif
    if a:mode == 'current'
        let field = taskwarrior#current_column()
        if index(['id', 'uuid', 'status', 'urgency'], field) != -1
            return
        elseif field == 'description'
            call taskwarrior#system_call(uuid, 'modify', taskwarrior#get_args(field), 'external')
        else
            call taskwarrior#system_call(uuid, 'modify', taskwarrior#get_args(field), 'silent')
        endif
    else
        call taskwarrior#system_call(uuid, 'modify', taskwarrior#get_args(), 'external')
    endif
endfunction

function! taskwarrior#delete()
    execute "!task ".taskwarrior#get_uuid()." delete"
    call taskwarrior#refresh()
endfunction

function! taskwarrior#annotate(op)
    while line('.') > 1 && taskwarrior#get_uuid() == ''
        normal k
    endwhile
    let annotation = input("annotation:")
    if a:op == 'add'
        call taskwarrior#system_call(taskwarrior#get_uuid(), ' annotate ', annotation, 'silent')
    else
        call taskwarrior#system_call(taskwarrior#get_uuid(), ' denotate ', annotation, 'silent')
    endif
endfunction

function! taskwarrior#sort_by_arg(...)
    let args = substitute(join(a:000, ' '), '\s\+', ',', 'g')
    let args = substitute(args, '\w\zs,', '-,', 'g')
    let args = substitute(args, '\w\zs$', '-', '')
    let b:rc = args == '' ? '' : g:task_rc_override.' rc.report.'.b:command.'.sort:'.args
    call taskwarrior#list()
endfunction

function! taskwarrior#sort_by_column(polarity, column)
    let fromrc   = matchstr(b:rc, 'rc\.report\.'.b:command.'\.sort.\zs\S*')
    let default  = system('task _get -- rc.report.'.b:command.'.sort')[0:-2]
    let colshort = map(deepcopy(b:task_report_columns), 'matchstr(v:val, "^\\w*")')
    let ccol     = index(colshort, a:column) == -1 ? taskwarrior#current_column() : a:column
    let list     = split(fromrc, ',')
    let ind      = index(split(fromrc, '[-+],\='), ccol)
    let dlist    = split(default, ',')
    let dind     = index(split(default, '[-+],\='), ccol)
    if fromrc == ''
        if dind != -1
            if a:polarity == 'm'
                if dind == 0
                    return
                endif
                call insert(dlist, remove(dlist, dind))
            elseif dlist[dind] == ccol.a:polarity
                return
            else
                let dlist[dind] = ccol.a:polarity
            endif
            let b:rc .= ' rc.report.'.b:command.'.sort:'.join(dlist, ',')
        else
            let polarity = a:polarity == 'm' ? '-' : a:polarity
            let b:rc .= ' rc.report.'.b:command.'.sort:'.ccol.polarity.','.default
        endif
    elseif ind != -1
        if a:polarity == 'm'
            if ind == 0
                let list[0] = list[0][0:-2].(list[0][-1:-1] == '+' ? '-' : '+')
            else
                call insert(list, remove(list, ind))
            endif
        elseif list[ind] == ccol.a:polarity
            if a:polarity == '+'
                call insert(list, remove(list, ind), ind > 1 ? ind-1 : 0)
            else
                if ind > len(list)-3
                    call add(list, remove(list, ind))
                else
                    call insert(list, remove(list, ind), ind+1)
                endif
            endif
        else
            let list[ind] = ccol.a:polarity
        endif
        let g:listabc = list
        let b:rc = substitute(b:rc, 'report\.'.b:command.'\.sort.'.fromrc, 'report.'.b:command.'.sort:'.join(list, ','), '')
    else
        let polarity = a:polarity == 'm' ? '-' : a:polarity
        let b:rc = substitute(b:rc, 'report\.'.b:command.'\.sort.', 'report.'.b:command.'.sort:'.ccol.polarity.',', '')
    endif
    call taskwarrior#list()
endfunction

function! taskwarrior#sort_order_list()
    let fromrc = matchstr(b:rc, 'rc\.report\.'.b:command.'\.sort.\zs\S*')
    if fromrc == ''
        return split(system('task _get -- rc.report.'.b:command.'.sort')[0:-2], ',')
    else
        return split(fromrc, ',')
    endif
endfunction

function! taskwarrior#set_done()
    call taskwarrior#system_call(taskwarrior#get_uuid(), ' done', '', 'silent')
endfunction

function! taskwarrior#get_value_by_column(line, column)
    if !exists('b:task_columns') || !exists('b:task_report_columns') || line('.') == 1
        return ''
    endif
    let index = match(b:task_report_columns, a:column.'.*')
    if index != -1
        return taskwarrior#get_value_by_index(a:line, index)
    endif
    return ''
endfunction

function! taskwarrior#get_value_by_index(line, index)
    if !exists('b:task_columns')
        return ''
    endif
    if exists('b:task_columns['.a:index.']')
        return substitute(getline(a:line)[b:task_columns[a:index]:b:task_columns[a:index+1]-1], '\(\s*$\|^\s*\)', '',  'g')
    endif
    return ''
endfunction

function! taskwarrior#get_uuid()
    if !exists('b:task_report_columns') || line('.') == 1
        return ''
    endif
    let vol = taskwarrior#get_value_by_column('.', 'uuid')
    let vol = vol =~ '[0-9a-f]\{8}\(-[0-9a-f]\{4}\)\{3}-[0-9a-f]\{12}' ? vol : taskwarrior#get_value_by_column('.', 'id')
    return vol =~ '^\s*-\s*$' ? '' : vol
endfunction

function! taskwarrior#get_stats(method)
    let dict = {}
    if a:method != 'current'
        let stat = split(system('task '.a:method.' stats'), '\n')
    else
        let uuid = taskwarrior#get_uuid()
        let stat = split(system('task '.taskwarrior#get_uuid().' stats'), '\n')
        if uuid =~ '^\s*$' || len(stat) < 5
            return {}
        endif
    endif
    for line in stat[2:-1]
        if line !~ '^\W*$'
            let dict[split(line, '\s\s')[0]] = substitute(split(line, '\s\s')[-1], '^\s*', '', '')
        endif
    endfor
    return dict
endfunction

function! taskwarrior#get_args(...)
    if a:0 != 0
        let arg = ' '
        for key in a:000
            execute 'let this_'.key.'=input("'.key.':", "'.taskwarrior#get_value_by_column('.', key).'")'
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

function! taskwarrior#system_call(filter, command, args, mode)
    if a:mode == 'silent'
        call system("task ".a:filter.' '.a:command.' '.a:args)
    elseif a:mode == 'echo'
        echo "\n----------------\n"
        echo system("task ".a:filter.' '.a:command.' '.a:args)
    else
        execute '!task '.a:filter.' '.a:command.' '.a:args
    endif
    call taskwarrior#refresh()
endfunction

function! taskwarrior#undo()
    if has("gui_running")
        if executable('xterm')
            silent !xterm -e "task undo"
        endif
    else
        !task undo
    endif
    call taskwarrior#refresh()
endfunction

function! taskwarrior#get_info()
    let ccol = taskwarrior#current_column()
    let command = 'summary'
    if ccol == 'project'
        let command = 'projects'
    elseif ccol == 'tags'
        let command = 'tags'
    elseif ccol == 'id'
        let command = 'stats'.' '.taskwarrior#get_uuid()
    elseif ccol =~ '\v(entry|end|due)'
        let command = 'history.monthly'
    elseif taskwarrior#get_uuid() !~ '^\s*$'
        let command = taskwarrior#get_uuid().' information'
    endif
    echom command
    for line in split(system('task '.command), '\n')
        echo line
    endfor
endfunction

function! taskwarrior#clear_completed()
    !task status:completed delete
    call taskwarrior#refresh()
endfunction

function! taskwarrior#sync(action)
    execute '!task '.a:action.' '
    call taskwarrior#refresh()
endfunction

function! taskwarrior#command_type(string)
    for sub in split(a:string, ' ')
        if index(g:task_report_command, sub) != -1
            return [ sub, substitute(' '.a:string, ' '.sub, '', ''), 'report' ]
        elseif index(g:task_interactive_command, sub) != -1
            return [ sub, substitute(' '.a:string, ' '.sub, '', ''), 'interactive' ]
        elseif index(g:task_all_commands, sub) != -1
            return [ sub, substitute(' '.a:string, ' '.sub, '', ''), 'special' ]
        endif
    endfor

    return [ g:task_report_name, a:string, 'report' ]
endfunction

function! taskwarrior#move_cursor(direction, mode)
    let ci = taskwarrior#current_index()
    if ci == -1 || (ci == 0 && a:direction == 'left') || (ci == len(b:task_columns)-1 && a:direction == 'right')
        return
    endif
    if a:direction == 'left'
        call search('\%'.(b:task_columns[ci-1]+1).'v', 'be')
    else
        call search('\%'.(b:task_columns[ci+1]+1).'v', 'e')
    endif
    if a:mode == 'skip' && getline('.')[getpos('.')[2]-1] == ' '
        call taskwarrior#move_cursor(a:direction, 'skip')
    endif
endfunction

function! taskwarrior#current_index()
    if getline('.') =~ '^\s*$' || !exists('b:task_columns') || !exists('b:task_report_columns')
        return -1
    endif
    let i = 0
    while  i < len(b:task_columns) && virtcol('.') >= b:task_columns[i]
        let i += 1
    endwhile
    return i-1
endfunction

function! taskwarrior#current_column()
    if !exists('b:task_columns') || !exists('b:task_report_columns')
        return ''
    endif
    return matchstr(b:task_report_columns[taskwarrior#current_index()], '^\w\+')
endfunction

function! taskwarrior#status()
    return b:filter.' '.b:rc.' '.b:command
endfunction

function! taskwarrior#global_stats()
    let dict = taskwarrior#get_stats(b:filter)
    return [dict['Pending']]+[dict['Completed']]+[taskwarrior#get_stats('')['Pending']]
endfunction

function! taskwarrior#TW_complete(A,L,P)
    let command = deepcopy(g:task_all_commands)
    let filter  = deepcopy(g:task_filter)
    let config  = deepcopy(g:task_all_configurations)
    let lead = a:A == '' ? '.*' : a:A
    for ph in split(a:L, ' ')[0:-1]
        if ph == 'config' || ph == 'show'
            return filter(config, 'matchstr(v:val,"'.lead.'") != ""')
        elseif index(command, ph) != -1
            return filter(filter, 'matchstr(v:val,"'.lead.'") != ""')
        endif
    endfor
    return filter(command+filter, 'matchstr(v:val,"'.lead.'") != ""')
endfunction

function! taskwarrior#sort_complete(A,L,P)
    if !exists('b:task_report_columns')
        return []
    endif
    let lead = a:A == '' ? '.*' : a:A
    let cols = map(deepcopy(b:task_report_columns), 'matchstr(v:val, "^\\w*")')
    return filter(cols, 'matchstr(v:val,"'.lead.'") != ""')
endfunction
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent
