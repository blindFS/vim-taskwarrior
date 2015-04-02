function! airline#extensions#taskwarrior#apply(...)
    if &ft == 'taskreport'
        call a:1.add_section('airline_a', ' Taskwarrior ')
        call a:1.add_section('airline_b', ' %{b:command} %{&readonly ? g:airline_symbols.readonly : ""}')
        call a:1.add_section('airline_b', ' @%{b:context} ')
        call a:1.add_section('airline_b', g:task_left_arrow.' %{b:hist > 1 ? g:task_right_arrow : ""}')
        call a:1.add_section('airline_c', ' %{b:filter} ')
        call a:1.add_section('airline_c', ' %{b:sstring} ')
        call a:1.split()
        call a:1.add_section('airline_x', ' %{b:now} ')
        call a:1.add_section('airline_x', ' %{b:task_report_columns[taskwarrior#data#current_index()]} ')
        call a:1.add_section('airline_y', ' %{b:sort} ')
        if b:active != '0'
            call airline#parts#define_text('active', ' '.b:active.' ')
            call airline#parts#define_accent('active', 'orange')
            call a:1.add_section('airline_z', airline#section#create(['active']))
        endif
        call a:1.add_section('airline_z', ' %{b:summary[0]} ')
        call airline#parts#define_text('completed', ' '.b:summary[1].' ')
        call airline#parts#define_accent('completed', 'green')
        call a:1.add_section('airline_z', airline#section#create(['completed']))
        call a:1.add_section('airline_z', ' %{b:summary[2]} ')
        return 1
    elseif &ft == 'taskinfo'
        call a:1.add_section('airline_a', ' Taskinfo ')
        call a:1.add_section('airline_b', ' %{b:command." ".g:airline_symbols.readonly }')
        call a:1.add_section('airline_c', ' %{b:filter} ')
        call a:1.split()
        return 1
    endif
endfunction

function s:context()
    let con = split(system('task context show'), '\n')
    let con = con =~ 'No context' ? 'none' : con
    return con
endfunction

function! airline#extensions#taskwarrior#init(ext)
    call a:ext.add_statusline_func('airline#extensions#taskwarrior#apply')
endfunction
