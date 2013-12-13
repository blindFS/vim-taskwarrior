function! taskwarrior#list(...) abort
    setlocal noreadonly
    setlocal modifiable
    let pos = getpos('.')
    %delete
    call taskwarrior#buffer_var_init()
    let b:command = get(a:, 1, b:command)
    let b:filter  = get(a:, 2, b:filter)
    let b:type    = get(a:, 3, b:type)
    let b:rc      = get(a:, 4, b:rc)

    let b:rc     .= ' '.join(filter(split(b:filter, ' '), "v:val =~ '^rc\..*'"))
    let b:filter  = join(filter(split(b:filter, ' '), "v:val !~ '^rc\..*'"))
    let rcs       = split(b:rc, ' ')
    let b:rc      = join(filter(copy(rcs), "match(rcs, matchstr(v:val, '^[^=:]*'), v:key+1) == -1"), ' ')

    if b:type == 'special'
        setlocal buftype=nofile
        call append(0, split((system('task '.b:rc.' '.b:filter.' '.b:command)), '\n'))
        execute 'setlocal filetype=task'.b:command
        nnoremap <buffer> q :call taskwarrior#quit()<CR>
        call setpos('.', pos)
        return
    endif

    let b:hist = get(b:, 'hist', 1)
    call taskwarrior#log#history('write')

    let rcc                   = matchstr(b:rc, 'rc\.report\.'.b:command.'\.columns.\zs\S*')
    let rcl                   = matchstr(b:rc, 'rc\.report\.'.b:command.'\.labels.\zs\S*')
    " let b:task_report_columns = rcc == '' ? split(system("task _get -- rc.report.".b:command.".columns")[0:-2], ',') : split(rcc, ',')
    " let b:task_report_labels  = rcl == '' ? split(system("task _get -- rc.report.".b:command.".labels")[0:-2], ',') : split(rcl, ',')
    let b:task_report_columns = rcc == '' ? split(matchstr(system("task show |grep report.".b:command.".columns")[0:-2], '\S*$'), ',') : split(rcc, ',')
    let b:task_report_labels  = rcl == '' ? split(matchstr(system("task show |grep report.".b:command.".labels")[0:-2], '\S*$'), ',') : split(rcl, ',')
    let line1                 = join(b:task_report_labels, ' ')

    let context = split(system("task ".b:rc.' '.b:filter.' '.b:command), '\n')
    if len(context) < 2 || context[1] !~ '^[ -]\+$'
        call append(0, line1)
    else
        let index = match(context, '^$')
        call append(0, context[0:index])
        global/^\s*$/delete
        2d
    endif

    call filter(b:task_report_columns, "index(split(getline(1), ' '), b:task_report_labels[v:key]) != -1")
    call filter(b:task_report_labels, "index(split(getline(1), ' '), v:val) != -1")

    let b:task_columns = []
    let ci = 0
    1
    while ci != -1
        let b:task_columns += [ci]
        let ci = search('\s\S', 'W', 1)
        let ci = ci > 0 ? virtcol('.') : -1
    endwhile

    let b:task_columns += [999]
    let b:summary       = taskwarrior#data#global_stats()
    let b:sort          = taskwarrior#sort#order_list()[0]
    let b:now           = system('task active limit:1 rc.verbose:nothing rc.report.active.sort=start- rc.report.active.columns=start.active,start.age,id,description.desc rc.report.active.labels=A,Age,ID,Description')[0:-2]
    let b:active        = split(system('task start.any: count'), '\n')[0]
    let b:selected      = []
    let b:sline         = []
    let b:sstring       = ''

    setlocal filetype=taskreport
    if exists('b:ct')
        for l in range(line('$'))
            if taskwarrior#data#get_uuid(l) == b:ct
                let pos[1] = l
                break
            endif
        endfor
    endif
    call setpos('.', pos)
endfunction

function! taskwarrior#buffer_var_init()
    let b:command = get(b:, 'command', g:task_report_name)
    let b:filter  = get(b:, 'filter', '')
    let b:type    = get(b:, 'type', 'report')
    let b:rc      = get(b:, 'rc', g:task_rc_override)
endfunction

function! taskwarrior#init(...)
    let argstring = join(a:000, ' ')
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
            let command = get(b:, 'command', g:task_report_name)
            let filter  = get(b:, 'filter', '')
            let type    = get(b:, 'type', 'report')
            let rc      = get(b:, 'rc', g:task_rc_override)
        endif
        call taskwarrior#quit()
    endif

    execute 'edit task\ '.command
    let g:task_view = bufnr('%')
    setlocal noswapfile
    call taskwarrior#list(command, filter, type, rc)

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
    let index = taskwarrior#data#current_index()
    execute 'syntax match taskwarrior_field /\%>1l\%'.line('.').'l\%'.(b:task_columns[index]+1).'v.*\%<'.(b:task_columns[index+1]+1).'v/'
endfunction

function! taskwarrior#quit()
    silent! execute g:task_view.'bd!'
    unlet g:task_view
endfunction

function! taskwarrior#system_call(filter, command, args, mode)
    if a:mode == 'silent'
        call system('task '.a:filter.' '.a:command.' '.a:args)
    elseif a:mode == 'echo'
        echo "\n----------------\n"
        echo system('task '.a:filter.' '.a:command.' '.a:args)
    else
        execute '!task '.a:filter.' '.a:command.' '.a:args
    endif
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
