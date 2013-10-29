function! airline#extensions#taskwarrior#apply(...)
    if &ft == 'taskreport'
        call a:1.add_section('airline_a', ' taskwarrior ')
        call a:1.add_section('airline_b', ' %{b:command} '.'%{&readonly ? g:airline_readonly_symbol : ""}')
        call a:1.add_section('airline_c', ' %{b:filter} ')
        call a:1.split()
        call a:1.add_section('airline_x', ' %{taskwarrior#current_column()} ')
        call a:1.add_section('airline_y', ' %{taskwarrior#sort_list()[0]} ')
        call a:1.add_section('airline_z', ' %{b:summary} ')
        return 1
    endif
endfunction

function! airline#extensions#taskwarrior#init(ext)
    call a:ext.add_statusline_func('airline#extensions#taskwarrior#apply')
endfunction
