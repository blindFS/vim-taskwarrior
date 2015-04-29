function! taskwarrior#action#new()
    call taskwarrior#system_call('', 'add', taskwarrior#data#get_args('add'), 'echo')
endfunction

function! taskwarrior#action#set_done()
    call taskwarrior#system_call(taskwarrior#data#get_uuid(), ' done', '', 'silent')
endfunction

function! taskwarrior#action#urgency() abort
    let cc   = taskwarrior#data#current_column()
    let udas = split(system('task _udas'), '\n')
    let cmap = { 'start' : 'active',
                \ 'entry' : 'age',
                \ 'depends' : 'blocked',
                \ 'parent' : 'blocking',
                \ 'wait' : 'waiting',
                \ 'description' : 'annotations'
                \ }
    let isuda = 0
    if has_key(cmap, cc)
        let cc = cmap[cc]
    elseif index(['due', 'priority', 'project', 'tags', 'scheduled']
                \ , cc) == -1
        if index(udas, cc) == -1
            call taskwarrior#sort#by_arg('urgency-')
            return
        else
            let isuda = 1
        endif
    endif
    let rcfile = $HOME.'/.taskrc'
    if filereadable(rcfile)
        let cv = taskwarrior#data#get_value_by_column(line('.'), cc)
        let option = isuda ? 'urgency.uda.'.cc.'.coefficient' :
                    \ 'urgency.'.cc.'.coefficient'
        if len(cv)
            let ctag = expand('<cword>')
            if cc == 'tags' && index(split(cv), ctag) != -1
                let option = 'urgency.user.tag.'.ctag.'.coefficient'
            elseif cc == 'project' && cv =~ '^[^ \t%\\*]\+$'
                let pl = split(cv, '\.')
                let idx = index(pl, expand('<cword>'))
                let option = 'urgency.user.project.'.
                            \ join(pl[0:idx], '.').'.coefficient'
            elseif isuda && cv =~ '^\w\+$'
                let option = 'urgency.uda.'.cc.'.'.cv.'.coefficient'
            endif
        endif
        let default_raw = split(system('task _get rc.'.option), '\n')
        let default     = len(default_raw) ? default_raw[0] : '0'
        let new         = input(option.' : ', default)
        let lines       = readfile(rcfile)
        let index       = match(lines, option)
        if str2float(new) == str2float(default)
        elseif str2float(new) == 0
            call filter(lines, 'v:val !~ option')
        elseif index == -1
            call add(lines, option.'='.new)
        else
            let lines[index] = option.'='.new
        endif
        call writefile(lines, rcfile)
    endif
    call taskwarrior#sort#by_arg('urgency-')
    execute 'normal! :\<Esc>'
endfunction

function! taskwarrior#action#modify(mode)
    let uuid = taskwarrior#data#get_uuid()
    if uuid == ''
        return
    endif
    if a:mode == 'current'
        let field = taskwarrior#data#current_column()
        if index(['id', 'uuid', 'status', 'urgency'], field) != -1
            return
        elseif field == 'description'
            call taskwarrior#system_call(uuid, 'modify', taskwarrior#data#get_args('modify', [field]), 'external')
        else
            call taskwarrior#system_call(uuid, 'modify', taskwarrior#data#get_args('modify', [field]), 'silent')
        endif
    else
        call taskwarrior#system_call(uuid, 'modify', taskwarrior#data#get_args('modify'), 'external')
    endif
endfunction

function! taskwarrior#action#delete()
    let uuid = taskwarrior#data#get_uuid()
    if uuid == ''
        call taskwarrior#action#annotate('del')
    else
        let ccol = taskwarrior#data#current_column()
        if index(['project', 'tags', 'due', 'priority', 'start', 'depends'], ccol) != -1
            call taskwarrior#system_call(uuid, 'modify', ccol.':', 'silent')
        else
            execute '!task '.uuid.' delete'
        endif
    endif
    call taskwarrior#refresh()
endfunction

function! taskwarrior#action#remove()
    execute '!task '.taskwarrior#data#get_uuid().' delete'
    call taskwarrior#list()
endfunction

function! taskwarrior#action#annotate(op)
    let ln = line('.')
    let offset = -1
    while ln > 1 && taskwarrior#data#get_uuid(ln) == ''
        let ln -= 1
        let offset += 1
    endwhile
    let uuid = taskwarrior#data#get_uuid(ln)
    if uuid == ''
        return
    endif
    if a:op == 'add'
        let annotation = input('new annotation:', '', 'file')
        call taskwarrior#system_call(uuid, ' annotate ', annotation, 'silent')
    elseif a:op == 'del'
        let annotation = input('annotation pattern to delete:')
        call taskwarrior#system_call(uuid, ' denotate ', annotation, 'silent')
    elseif offset >= 0
        let taskobj = taskwarrior#data#get_query(uuid)
        if exists('taskobj.annotations[offset].description')
            let file = substitute(taskobj.annotations[offset].description, '\s*\/\s*', '/', 'g')
            let file = escape(file, ' ')
            let ft = 'text'
            if executable('file')
                let ft = system('file '.file)[:-2]
            endif
            if ft =~ 'text$'
                execute 'e '.file
            elseif ft !~ '(No such file or directory)' || file =~ '[a-z]*:\/\/[^ >,;]*'
                if executable('xdg-open')
                    call system('xdg-open '.file.'&')
                elseif executable('open')
                    call system('open '.file.'&')
                endif
            endif
        endif
    endif
endfunction

function! taskwarrior#action#filter()
    let column = taskwarrior#data#current_column()
    if index(['project', 'tags', 'status', 'priority'], column) != -1 && line('.') > 1
        let filter = substitute(substitute(taskwarrior#data#get_args('modify', [column]), 'tags:', '+', ''), '\v^\s*\+(\s|$)', '', '')
    elseif column =~ '\v^(entry|end|due)$'
        let filter = column.'.before:'.input(column.'.before:', taskwarrior#data#get_value_by_column('.', column))
    elseif column == 'description'
        let filter = 'description:'.input('description:', taskwarrior#data#get_value_by_column('.', column) )
    else
        let filter = input('new filter:', b:filter, 'customlist,taskwarrior#complete#filter')
    endif
    let filter = substitute(filter, 'status:\(\s\|$\)', 'status.any: ', 'g')
    if filter != b:filter
        let b:filter = filter
        let b:hist = 1
        call taskwarrior#list()
    endif
endfunction

function! taskwarrior#action#command()
    if len(b:selected) == 0
        let filter = taskwarrior#data#get_uuid()
    else
        let filter = join(b:selected, ',')
    endif
    let command = input('task '.filter.':', '', 'customlist,taskwarrior#complete#command')
    if index(g:task_all_commands, b:command) == -1
        return
    endif
    call taskwarrior#system_call(filter, command, '', 'interactive')
endfunction

function! taskwarrior#action#report()
    let command = input('new report:', g:task_report_name, 'customlist,taskwarrior#complete#report')
    if index(g:task_report_command, command) != -1 && command != b:command
        let b:command = command
        let b:hist = 1
        call taskwarrior#list()
    endif
endfunction

function! taskwarrior#action#paste()
    if len(b:selected) == 0
        return
    elseif len(b:selected) < 3
        call taskwarrior#system_call(join(b:selected, ','), 'duplicate', '', 'echo')
    else
        call taskwarrior#system_call(join(b:selected, ','), 'duplicate', '', 'interactive')
    endif
endfunction

function! taskwarrior#action#columns_format_change(direction)
    let ccol     = taskwarrior#data#current_column()
    if !exists('g:task_columns_format[ccol]')
        return
    endif
    let clist    = g:task_columns_format[ccol]
    if len(clist) == 1
        return
    endif
    let ccol_ful = b:task_report_columns[taskwarrior#data#current_index()]
    let ccol_sub = matchstr(ccol_ful, '\.\zs.*')
    let rcl      = matchstr(b:rc, 'rc\.report\.'.b:command.'\.columns.\zs\S*')
    " let dfl      = system('task _get -- rc.report.'.b:command.'.columns')[0:-2]
    let dfl      = matchstr(system('task show | grep report.'.b:command.'.columns')[0:-2], '\S*$')
    let index    = index(clist, ccol_sub)
    let index    = index == -1 ? 0 : index
    if a:direction == 'left'
        let index -= 1
    else
        let index += 1
        if index == len(clist)
            let index = 0
        endif
    endif
    let newsub = index == 0 ? '' : '.'.clist[index]
    let b:rc .= ' rc.report.'.b:command.'.columns:'.
                \ substitute(
                \   rcl == '' ? dfl : rcl,
                \   '[=:,]\zs'.ccol_ful.'\ze\(,\|$\)',
                \   ccol.newsub, ''
                \ )
    let b:hist = 1
    call taskwarrior#list()
endfunction

function! taskwarrior#action#date(count)
    let ccol = taskwarrior#data#current_column()
    if index(['due', 'end', 'entry'], ccol) == -1
        return
    endif
    setlocal modifiable
    if exists('g:loaded_speeddating')
        call speeddating#increment(a:count)
    elseif a:count > 0
        execute 'normal! '.a:count.''
    else
        execute 'normal! '.-a:count.''
    endif
    let b:ct = taskwarrior#data#get_uuid()
    call taskwarrior#system_call(b:ct, 'modify', ccol.':'.taskwarrior#data#get_value_by_column('.', ccol, 'temp'), 'silent')
endfunction

function! taskwarrior#action#visual(action) range
    let line1 = getpos("'<")[1]
    let line2 = getpos("'>")[1]
    let fil = []
    let lin = []
    for l in range(line1, line2)
        let uuid = taskwarrior#data#get_uuid(l)
        if uuid !~ '^\s*$'
            let fil += [uuid]
            let lin += [l]
        endif
    endfor
    let filter = join(fil, ',')
    if a:action == 'done'
        call taskwarrior#system_call(filter, 'done', '', 'interactive')
    elseif a:action == 'delete'
        call taskwarrior#system_call(filter, 'delete', '', 'interactive')
    elseif a:action == 'info'
        call taskinfo#init('information', filter, split(system('task rc.color=no information '.filter), '\n'))
    elseif a:action == 'select'
        for var in fil
            let index = index(b:selected, var)
            if index == -1
                let b:selected += [var]
                let b:sline += [lin[index(fil, var)]]
            else
                call remove(b:selected, index)
                call remove(b:sline, index)
            endif
        endfor
        let b:sstring = join(b:selected, ' ')
        setlocal syntax=taskreport
    endif
endfunction

function! taskwarrior#action#move_cursor(direction, mode)
    let ci = taskwarrior#data#current_index()
    if ci == -1 || (ci == 0 && a:direction == 'left') || (ci == len(b:task_columns)-1 && a:direction == 'right')
        return
    endif
    if a:direction == 'left'
        call search('\%'.(b:task_columns[ci-1]+1).'v', 'be')
    else
        call search('\%'.(b:task_columns[ci+1]+1).'v', 'e')
    endif
    if a:mode == 'skip' && taskwarrior#data#get_value_by_index('.', taskwarrior#data#current_index()) =~ '^\s*$'
        call taskwarrior#action#move_cursor(a:direction, 'skip')
    endif
endfunction

function! taskwarrior#action#undo()
    if has("gui_running")
        if exists('g:task_gui_term') && g:task_gui_term == 1
            !task rc.color=off undo
        elseif executable('xterm')
            silent !xterm -e 'task undo'
        elseif executable('urxvt')
            silent !urxvt -e task undo
        elseif executable('gnome-terminal')
            silent !gnome-terminal -e 'task undo'
        endif
    else
        sil !clear
        !task undo
    endif
    call taskwarrior#refresh()
endfunction

function! taskwarrior#action#clear_completed()
    !task status:completed delete
    call taskwarrior#refresh()
endfunction

function! taskwarrior#action#sync(action)
    execute '!task '.a:action.' '
    call taskwarrior#refresh()
endfunction

function! taskwarrior#action#select()
    let uuid = taskwarrior#data#get_uuid()
    if uuid == ''
        return
    endif
    let index = index(b:selected, uuid)
    if index == -1
        let b:selected += [uuid]
        let b:sline += [line('.')]
    else
        call remove(b:selected, index)
        call remove(b:sline, index)
    endif
    let b:sstring = join(b:selected, ' ')
    setlocal syntax=taskreport
endfunction

function! taskwarrior#action#show_info(...)
    if a:0 > 0
        let command = 'info'
        let filter = a:1
    else
        let ccol = taskwarrior#data#current_column()
        let dict = { 'project': 'projects',
                    \ 'tags': 'tags',
                    \ 'id': 'stats',
                    \ 'depends': 'blocking',
                    \ 'recur': 'recurring',
                    \ 'due': 'overdue',
                    \ 'wait': 'waiting',
                    \ 'urgency': 'ready',
                    \ 'entry': 'history.monthly',
                    \ 'end': 'history.monthly'}
        let command = get(dict, ccol, 'summary')
        let uuid = taskwarrior#data#get_uuid()
        if uuid !~ '^\s*$'
            let command = substitute(command, '\v(summary|stats)', 'information', '')
            let filter = taskwarrior#data#get_uuid()
        else
            let filter = b:filter
        endif
    endif
    call taskinfo#init(command, filter, split(system('task rc.color=no '.command.' '.filter), '\n'))
endfunction
