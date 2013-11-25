function! taskwarrior#data#get_uuid(...)
    let line = a:0 == 0 ? '.' : a:1
    let vol = taskwarrior#data#get_value_by_column(line, 'uuid')
    let vol = vol =~ '[0-9a-f]\{8}\(-[0-9a-f]\{4}\)\{3}-[0-9a-f]\{12}' ? vol : taskwarrior#data#get_value_by_column(line, 'id')
    return vol =~ '^\s*-\s*$' ? '' : vol
endfunction

function! taskwarrior#data#get_args(...)
    if a:0 != 0
        let arg = ' '
        for key in a:1
            execute 'let this_'.key.'=input("'.key.':", "'.taskwarrior#data#get_value_by_column('.', key).'")'
            if key == 'description'
                execute "let arg = arg.' '.this_".key
            else
                execute "let arg = arg.' '.key.':'.this_".key
            endif
        endfor
        return arg
    else
        return taskwarrior#data#get_args(g:task_default_prompt)
    endif
endfunction

function! taskwarrior#data#get_value_by_column(line, column, ...)
    if line('.') == 1
        return ''
    endif
    if a:column == 'id' || a:column == 'uuid' || exists('a:1')
        let index = match(b:task_report_columns, '^'.a:column.'.*')
        return taskwarrior#data#get_value_by_index(a:line, index(b:task_report_columns, a:column))
    else
        let ilist = split(system('task all '.taskwarrior#data#get_uuid().' rc.report.all.columns='.a:column.' rc.report.all.labels=cc'), '\n')
        if len(ilist) > 2 && ilist[1] =~ '^[ -]\+$'
            return substitute(ilist[2],  '\(\s*$\|^\s*\)', '',  'g')
        endif
        return ''
    endif
endfunction

function! taskwarrior#data#get_value_by_index(line, index)
    if exists('b:task_columns[a:index]')
        return substitute(getline(a:line)[b:task_columns[a:index]:b:task_columns[a:index+1]-1], '\(\s*$\|^\s*\)', '',  'g')
    endif
    return ''
endfunction

function! taskwarrior#data#current_index()
    let i = 0
    while  i < len(b:task_columns) && virtcol('.') >= b:task_columns[i]
        let i += 1
    endwhile
    return i-1
endfunction

function! taskwarrior#data#current_column()
    return matchstr(b:task_report_columns[taskwarrior#data#current_index()], '^\w\+')
endfunction

function! taskwarrior#data#get_stats(method)
    let dict = {}
    if a:method != 'current'
        let stat = split(system('task '.a:method.' stats'), '\n')
    else
        let uuid = taskwarrior#data#get_uuid()
        let stat = split(system('task '.taskwarrior#data#get_uuid().' stats'), '\n')
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

function! taskwarrior#data#global_stats()
    let dict = taskwarrior#data#get_stats(b:filter)
    if !exists('dict["Pending"]') || !exists('dict["Completed"]')
        return ['0', '0', taskwarrior#data#get_stats('')['Pending']]
    endif
    return [dict['Pending'], dict['Completed'], taskwarrior#data#get_stats('')['Pending']]
endfunction

function! taskwarrior#data#category()
    let dict              = {}
    let dict['Pending']   = []
    let dict['Waiting']   = []
    let dict['Recurring'] = []
    let dict['Completed'] = []
    for i in range(2, line('$'))
        let uuid = taskwarrior#data#get_uuid(i)
        if uuid =~ '^\s*$'
            continue
        endif
        let subdict = taskwarrior#data#get_stats(uuid)
        if subdict['Pending']       == '1'
            let dict['Pending'] += [i]
        elseif subdict['Waiting']   == '1'
            let dict['Waiting'] += [i]
        elseif subdict['Recurring'] == '1'
            let dict['Recurring'] += [i]
        elseif subdict['Completed'] == '1'
            let dict['Completed'] += [i]
        endif
    endfor
    return dict
endfunction
