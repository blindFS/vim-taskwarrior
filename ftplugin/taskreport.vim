setlocal buftype=nofile
setlocal nomodifiable
setlocal cursorline
setlocal startofline
setlocal nowrap

nnoremap <silent> <buffer> <Plug>(taskwarrior_quickref)         :h tw-quickref<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_quit)             :call taskwarrior#quit()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_quit_all)         :call taskwarrior#quit_all()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_skip_left)        :call taskwarrior#action#move_cursor('left', 'skip')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_step_left)        :call taskwarrior#action#move_cursor('left', 'step')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_skip_right)       :call taskwarrior#action#move_cursor('right', 'skip')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_step_right)       :call taskwarrior#action#move_cursor('right', 'step')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_sort_increase)    :call taskwarrior#sort#by_column('+', '')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_sort_decrease)    :call taskwarrior#sort#by_column('-', '')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_sort_inverse)     :call taskwarrior#sort#by_column('m', '')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_show_info)        :call taskwarrior#action#show_info()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_filter)           :call taskwarrior#action#filter()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_next_format)      :call taskwarrior#action#columns_format_change('left')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_previous_format)  :call taskwarrior#action#columns_format_change('right')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_next_history)     :call taskwarrior#log#history('next')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_previous_history) :call taskwarrior#log#history('previous')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_new_bookmark)     :call taskwarrior#log#bookmark('new')<CR>
vnoremap <silent> <buffer> <Plug>(taskwarrior_visual_show_info) :call taskwarrior#action#visual('info')<CR>

nnoremap <silent> <buffer> <Plug>(taskwarrior_annotate)        :call taskwarrior#action#annotate('add')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_denotate)        :call taskwarrior#action#annotate('del')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_open_annotate)   :call taskwarrior#action#annotate('open')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_remove)          :call taskwarrior#action#remove()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_delete)          :call taskwarrior#action#delete()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_new)             :call taskwarrior#action#new()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_command)         :call taskwarrior#action#command()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_done)            :call taskwarrior#action#set_done()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_report)          :call taskwarrior#action#report()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_refresh)         :call taskwarrior#list()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_clear_completed) :call taskwarrior#action#clear_completed()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_undo)            :call taskwarrior#action#undo()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_urgency)         :call taskwarrior#action#urgency()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_sync)            :call taskwarrior#action#sync('sync')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_modify_field)    :call taskwarrior#action#modify('current')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_modify_task)     :call taskwarrior#action#modify('')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_paste)           :call taskwarrior#action#paste()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_start_task)      :call taskwarrior#system_call(taskwarrior#data#get_uuid(), 'start', '', 'silent')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_stop_task)       :call taskwarrior#system_call(taskwarrior#data#get_uuid(), 'stop', '', 'silent')<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_select)          :call taskwarrior#action#select()<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_increase)        :<C-U>call taskwarrior#action#date(v:count1)<CR>
nnoremap <silent> <buffer> <Plug>(taskwarrior_decrease)        :<C-U>call taskwarrior#action#date(-v:count1)<CR>
vnoremap <silent> <buffer> <Plug>(taskwarrior_visual_done)     :call taskwarrior#action#visual('done')<CR>
vnoremap <silent> <buffer> <Plug>(taskwarrior_visual_delete)   :call taskwarrior#action#visual('delete')<CR>
vnoremap <silent> <buffer> <Plug>(taskwarrior_visual_select)   :call taskwarrior#action#visual('select')<CR>

nmap <buffer> <F1>    <Plug>(taskwarrior_quickref)
nmap <buffer> Q       <Plug>(taskwarrior_quit_all)
nmap <buffer> q       <Plug>(taskwarrior_quit)
nmap <buffer> <left>  <Plug>(taskwarrior_skip_left)
nmap <buffer> <S-tab> <Plug>(taskwarrior_step_left)
nmap <buffer> <right> <Plug>(taskwarrior_skip_right)
nmap <buffer> <tab>   <Plug>(taskwarrior_step_right)
nmap <buffer> <       <Plug>(taskwarrior_sort_increase)
nmap <buffer> >       <Plug>(taskwarrior_sort_decrease)
nmap <buffer> s       <Plug>(taskwarrior_sort_inverse)
nmap <buffer> <CR>    <Plug>(taskwarrior_show_info)
nmap <buffer> f       <Plug>(taskwarrior_filter)
nmap <buffer> H       <Plug>(taskwarrior_next_format)
nmap <buffer> L       <Plug>(taskwarrior_previous_format)
nmap <buffer> J       <Plug>(taskwarrior_next_history)
nmap <buffer> K       <Plug>(taskwarrior_previous_history)
nmap <buffer> B       <Plug>(taskwarrior_new_bookmark)
vmap <buffer> <CR>    <Plug>(taskwarrior_visual_show_info)

if g:task_highlight_field
    autocmd CursorMoved <buffer> :call taskwarrior#hi_field()
else
    autocmd! CursorMoved <buffer>
endif

if g:task_readonly
    setlocal readonly
    if hasmapto('<Plug>(taskwarrior_undo)')
        nunmap <silent> <buffer> A
        nunmap <silent> <buffer> x
        nunmap <silent> <buffer> o
        nunmap <silent> <buffer> D
        nunmap <silent> <buffer> <Del>
        nunmap <silent> <buffer> a
        nunmap <silent> <buffer> c
        nunmap <silent> <buffer> d
        nunmap <silent> <buffer> r
        nunmap <silent> <buffer> R
        nunmap <silent> <buffer> X
        nunmap <silent> <buffer> u
        nunmap <silent> <buffer> S
        nunmap <silent> <buffer> m
        nunmap <silent> <buffer> M
        nunmap <silent> <buffer> p
        nunmap <silent> <buffer> +
        nunmap <silent> <buffer> -
        nunmap <silent> <buffer> <Space>
        nunmap <silent> <buffer> <C-A>
        nunmap <silent> <buffer> <C-X>
        vunmap <silent> <buffer> d
        vunmap <silent> <buffer> D
        vunmap <silent> <buffer> <Del>
        vunmap <silent> <buffer> <Space>
    endif
else
    nmap <silent> <buffer> A        <Plug>(taskwarrior_annotate)
    nmap <silent> <buffer> x        <Plug>(taskwarrior_denotate)
    nmap <silent> <buffer> o        <Plug>(taskwarrior_open_annotate)
    nmap <silent> <buffer> D        <Plug>(taskwarrior_remove)
    nmap <silent> <buffer> <Del>    <Plug>(taskwarrior_delete)
    nmap <silent> <buffer> a        <Plug>(taskwarrior_new)
    nmap <silent> <buffer> c        <Plug>(taskwarrior_command)
    nmap <silent> <buffer> d        <Plug>(taskwarrior_done)
    nmap <silent> <buffer> r        <Plug>(taskwarrior_report)
    nmap <silent> <buffer> R        <Plug>(taskwarrior_refresh)
    nmap <silent> <buffer> X        <Plug>(taskwarrior_clear_completed)
    nmap <silent> <buffer> u        <Plug>(taskwarrior_undo)
    nmap <silent> <buffer> U        <Plug>(taskwarrior_urgency)
    nmap <silent> <buffer> S        <Plug>(taskwarrior_sync)
    nmap <silent> <buffer> m        <Plug>(taskwarrior_modify_field)
    nmap <silent> <buffer> M        <Plug>(taskwarrior_modify_task)
    nmap <silent> <buffer> p        <Plug>(taskwarrior_paste)
    nmap <silent> <buffer> +        <Plug>(taskwarrior_start_task)
    nmap <silent> <buffer> -        <Plug>(taskwarrior_stop_task)
    nmap <silent> <buffer> <Space>  <Plug>(taskwarrior_select)
    nmap <silent> <buffer> <C-A>    <Plug>(taskwarrior_increase)
    nmap <silent> <buffer> <C-X>    <Plug>(taskwarrior_decrease)
    vmap <silent> <buffer> d        <Plug>(taskwarrior_visual_done)
    vmap <silent> <buffer> D        <Plug>(taskwarrior_visual_delete)
    vmap <silent> <buffer> <Del>    <Plug>(taskwarrior_visual_delete)
    vmap <silent> <buffer> <Space>  <Plug>(taskwarrior_visual_select)

    command! -buffer TWAdd               :call taskwarrior#action#new()
    command! -buffer TWAnnotate          :call taskwarrior#action#annotate('add')
    command! -buffer TWComplete          :call taskwarrior#action#set_done()
    command! -buffer TWDelete            :call taskwarrior#action#delete()
    command! -buffer TWDeleteAnnotation  :call taskwarrior#action#annotate('del')
    command! -buffer TWModifyInteractive :call taskwarrior#modify('')
    command! -buffer TWSync              :call taskwarrior#action#sync('sync')
endif

command! -buffer TWToggleReadonly    :let g:task_readonly = (g:task_readonly ? 0 : 1) | call taskwarrior#refresh()
command! -buffer TWToggleHLField     :let g:task_highlight_field = (g:task_highlight_field ? 0 : 1) | call taskwarrior#refresh()
command! -buffer -nargs=? -complete=customlist,taskwarrior#complete#sort TWReportSort :call taskwarrior#action#sort_by_arg(<q-args>)
