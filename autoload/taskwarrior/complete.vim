function! taskwarrior#complete#TW(A, L, P)
    let command     = copy(g:task_all_commands)
    let filter      = copy(g:task_filter)
    let config      = copy(g:task_all_configurations)
    let contexts    = split(system('task _context'), '\n')
    let context_cmd = ['define', 'show', 'list', 'delete']
    let words = split(a:L, ' ')
    if len(words) > 1 && words[1] == 'context'
        if len(words) == 2 || index(context_cmd, words[2]) == -1
            return filter(context_cmd + contexts + ['none'],
                        \ 'match(v:val, a:A) != -1')
        elseif words[2] == 'delete'
            return filter(contexts, 'match(v:val, a:A) != -1')
        else
            return []
        endif
    endif
    for ph in words
        if ph == 'config' || ph == 'show'
            return filter(config, 'match(v:val, a:A) != -1')
        elseif ph =~ '^rc\..*'
            return map(filter(config, 'match(v:val, a:A[3:]) != -1'),
                        \ "'rc.'.v:val")
        elseif index(command, ph) != -1
            return filter(filter, 'match(v:val, a:A) != -1')
        endif
    endfor
    return filter(command+filter, 'match(v:val, a:A) != -1')
endfunction

function! taskwarrior#complete#sort(A, L, P)
    let cols = map(split(system('task _columns'), '\n'),
                \ 'matchstr(v:val, "^\\w*")')
    return filter(cols, 'match(v:val, a:A) != -1')
endfunction

function! taskwarrior#complete#filter(A, L, P)
    let lead = matchstr(a:A, '\S*$')
    let lead = lead == '' ? '.*' : lead
    let dict = copy(g:task_filter)
    for ph in split(a:L, ' ')
        call remove(dict, index(dict, matchstr(ph, '.*:\ze')))
    endfor
    return map(filter(dict, 'match(v:val, lead) != -1'),
                \ "matchstr(a:L, '.*\\ze\\s\\+\\S*').' '.v:val")
endfunction

function! taskwarrior#complete#command(A, L, P)
    return filter(copy(g:task_all_commands), 'match(v:val, a:A) != -1')
endfunction

function! taskwarrior#complete#report(A, L, P)
    return filter(copy(g:task_report_command), 'match(v:val, a:A) != -1')
endfunction
