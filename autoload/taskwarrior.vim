function! taskwarrior#list(...) abort
    setlocal noreadonly
    setlocal modifiable
    let pos = getpos('.')
    %delete
    call taskwarrior#buffer_var_init()
    let b:command = get(a:, 1, b:command)
    let b:filter  = get(a:, 2, b:filter)
    let b:type    = get(a:, 3, b:type)
    let b:rc      = get(a:, 4, b:rc). ' rc.defaultheight=0'

    let b:rc     .= ' '.join(filter(split(b:filter, ' '), "v:val =~ '^rc\..*'"))
    let b:filter  = join(filter(split(b:filter, ' '), "v:val !~ '^rc\..*'"))
    let rcs       = split(b:rc, ' ')
    let b:rc      = join(filter(copy(rcs), "match(rcs, matchstr(v:val, '^[^=:]*'), v:key+1) == -1"), ' ')

    if b:type == 'special'
        setlocal buftype=nofile
        call append(0, split(system('task '.b:rc.' '.b:filter.' '.b:command), '\n'))
        silent global/^[\t ]*$/delete
        execute 'setlocal filetype=task_'.b:command
        nnoremap <buffer> q :call taskwarrior#Bclose(bufnr('%'))<CR>
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

    let context = split(substitute(
                \   system('task '.b:rc.' '.b:filter.' '.b:command),
                \   '\[[0-9;]\+m',
                \   '', 'g'),
                \ '\n')
    let split_lineno = match(context, '^[ -]\+$')
    if split_lineno == -1
        call append(0, line1)
    else
        let end = len(context)-match(reverse(copy(context)), '^$')
        call append(0, context[split_lineno-1:end-1])
        silent global/^[\t ]*$/delete
        silent global/^[ -]\+$/delete
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
    let a_tasks         = split(system('task active limit:1 rc.verbose:nothing
                \ rc.report.active.sort=start-
                \ rc.report.active.columns=start.active,start.age,id,description.desc
                \ rc.report.active.labels=A,Age,ID,Description'), '\n')
    let b:now           = len(a_tasks) > 0 ? a_tasks[-1] : ''
    let b:active        = split(system('task start.any: count'), '\n')[0]
    let b:selected      = []
    let b:sline         = []
    let b:sstring       = ''
    let con             = split(system('task context show'), '\n')[0]
    let b:context       = con =~ 'No context' ? 'none' :
                \ matchstr(con, 'Context .\zs\S*\ze. ')

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
    if exists(':TagbarClose')
        TagbarClose
    endif
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

    execute 'edit task\ '.command.'\ '.type

    if exists('g:task_view')
        let g:task_view += [bufnr('%')]
    else
        let g:task_view = [bufnr('%')]
    endif

    setlocal noswapfile
    call taskwarrior#list(command, filter, type, rc)

endfunction

function! taskwarrior#refresh()
    if exists('g:task_view')
        for bufn in g:task_view
            execute bufn.'buffer'
            call taskwarrior#list()
        endfor
    else
        call taskwarrior#init()
    endif
endfunction

function! taskwarrior#Bclose(buffer)
    if a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if bufname(btarget) == ''
        bdelete
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                enew
            endif
        endif
    endfor
    execute 'silent! bdelete '.btarget
    execute wcurrent.'wincmd w'
endfunction


function! taskwarrior#hi_field()
    silent! syntax clear taskwarrior_field
    let index = taskwarrior#data#current_index()
    execute 'syntax match taskwarrior_field /\%>1l\%'.line('.').'l\%'.(b:task_columns[index]+1).'v.*\%<'.(b:task_columns[index+1]+1).'v/'
endfunction

function! taskwarrior#quit()
    call taskwarrior#Bclose(bufnr('%'))
    call remove(g:task_view, index(g:task_view, bufnr('%')))
endfunction

function! taskwarrior#quit_all()
    for bufn in g:task_view
        call taskwarrior#Bclose(bufn)
    endfor
    let g:task_view = []
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
