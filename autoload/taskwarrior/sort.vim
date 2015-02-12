function! taskwarrior#sort#by_arg(...)
    let args = substitute(join(a:000, ' '), '\s\+', ',', 'g')
    let args = substitute(args, '\w\zs,', '-,', 'g')
    let args = substitute(args, '\w\zs$', '-', '')
    if args =~ '^\s*$'
        let b:rc = substitute(b:rc, 'rc.report.'.b:command.'.sort[:=]\S*', '', 'g')
    else
        let b:rc .= args == '' ? '' : ' rc.report.'.b:command.'.sort:'.args
    endif
    let b:hist = 1
    call taskwarrior#list()
endfunction

function! taskwarrior#sort#by_column(polarity, column)
    let fromrc   = matchstr(b:rc, 'rc\.report\.'.b:command.'\.sort.\zs\S*')
    " let default  = system('task _get -- rc.report.'.b:command.'.sort')[0:-2]
    let default  = matchstr(system('task show | grep report.'.b:command.'.sort')[0:-2], '\S*$')
    let colshort = map(copy(b:task_report_columns), 'matchstr(v:val, "^\\w*")')
    let ccol     = index(colshort, a:column) == -1 ?
                \ taskwarrior#data#current_column() :
                \ a:column
    let list     = split(fromrc, ',')
    let ind      = index(split(fromrc, '[-+],\='), ccol)
    let dlist    = split(default, ',')
    let dind     = index(split(default, '[-+],\='), ccol)
    if fromrc == ''
        if dind != -1
            if a:polarity == 'm'
                if dind == 0
                    let dlist[0] = dlist[0][0:-2].(dlist[0][-1:-1] == '+' ? '-' : '+')
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
    let b:hist = 1
    call taskwarrior#list()
endfunction

function! taskwarrior#sort#order_list()
    let fromrc = matchstr(b:rc, 'rc\.report\.'.b:command.'\.sort.\zs\S*')
    if fromrc == ''
        " let list = split(system('task _get -- rc.report.'.b:command.'.sort')[0:-2], ',')
        let list = split(matchstr(system('task show | grep report.'.b:command.'.sort')[0:-2], '\S*$'), ',')
    else
        let list = split(fromrc, ',')
    endif
    while exists('list[0]') && match(b:task_report_columns, list[0][0:-2]) == -1 && system('task count '.list[0][0:-2].'.any:')[0] == '0'
        call remove(list, 0)
    endwhile
    if len(list) == 0
        let list = ['status-']
    endif
    return list
endfunction
