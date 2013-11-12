setlocal buftype=nofile
setlocal nomodifiable
setlocal cursorline
setlocal nowrap

nnoremap <silent> <buffer> <F1>    :h tw-quickref<CR>
nnoremap <silent> <buffer> q       :call taskwarrior#quit()<CR>
nnoremap <silent> <buffer> <left>  :call taskwarrior#move_cursor('left', 'skip')<CR>
nnoremap <silent> <buffer> <S-tab> :call taskwarrior#move_cursor('left', 'step')<CR>
nnoremap <silent> <buffer> <right> :call taskwarrior#move_cursor('right', 'skip')<CR>
nnoremap <silent> <buffer> <tab>   :call taskwarrior#move_cursor('right', 'step')<CR>
nnoremap <silent> <buffer> <       :call taskwarrior#sort_by_column('+', '')<CR>
nnoremap <silent> <buffer> >       :call taskwarrior#sort_by_column('-', '')<CR>
nnoremap <silent> <buffer> s       :call taskwarrior#sort_by_column('m', '')<CR>
nnoremap <silent> <buffer> <CR>    :call taskwarrior#get_info()<CR>
nnoremap <silent> <buffer> f       :call taskwarrior#filter('')<CR>
nnoremap <silent> <buffer> H       :call taskwarrior#columns_format_change('left')<CR>
nnoremap <silent> <buffer> L       :call taskwarrior#columns_format_change('right')<CR>
vnoremap <silent> <buffer> <CR>    :call taskwarrior#visual_action('info')<CR>

if g:task_highlight_field
    autocmd CursorMoved <buffer> :call taskwarrior#hi_field()
else
    autocmd! CursorMoved <buffer>
endif

if g:task_readonly
    setlocal readonly
else
    nnoremap <silent> <buffer> A         :call taskwarrior#annotate('add')<CR>
    nnoremap <silent> <buffer> D         :call taskwarrior#remove()<CR>
    nnoremap <silent> <buffer> <Del>     :call taskwarrior#delete()<CR>
    nnoremap <silent> <buffer> a         :call taskwarrior#system_call('', 'add', taskwarrior#get_args(), 'echo')<CR>
    nnoremap <silent> <buffer> c         :call taskwarrior#command()<CR>
    nnoremap <silent> <buffer> d         :call taskwarrior#set_done()<CR>
    nnoremap <silent> <buffer> r         :call taskwarrior#report()<CR>
    nnoremap <silent> <buffer> R         :call taskwarrior#list()<CR>
    nnoremap <silent> <buffer> X         :call taskwarrior#clear_completed()<CR>
    nnoremap <silent> <buffer> u         :call taskwarrior#undo()<CR>
    nnoremap <silent> <buffer> x         :call taskwarrior#annotate('del')<CR>
    nnoremap <silent> <buffer> S         :call taskwarrior#sync('sync')<CR>
    nnoremap <silent> <buffer> m         :call taskwarrior#modify('current')<CR>
    nnoremap <silent> <buffer> M         :call taskwarrior#modify('')<CR>
    nnoremap <silent> <buffer> p         :call taskwarrior#paste()<CR>
    nnoremap <silent> <buffer> +         :call taskwarrior#system_call(taskwarrior#get_uuid(), 'start', '', 'silent')<CR>
    nnoremap <silent> <buffer> -         :call taskwarrior#system_call(taskwarrior#get_uuid(), 'stop', '', 'silent')<CR>
    nnoremap <silent> <buffer> <Space>   :call taskwarrior#select()<CR>
    vnoremap <silent> <buffer> d         :call taskwarrior#visual_action('done')<CR>
    vnoremap <silent> <buffer> D         :call taskwarrior#visual_action('delete')<CR>
    vnoremap <silent> <buffer> <Del>     :call taskwarrior#visual_action('delete')<CR>
    vnoremap <silent> <buffer> <Space>   :call taskwarrior#visual_action('select')<CR>
    command! -buffer TWAdd               :call taskwarrior#system_call('', 'add', taskwarrior#get_args(), 'interactive')
    command! -buffer TWAnnotate          :call taskwarrior#annotate('add')
    command! -buffer TWComplete          :call taskwarrior#set_done()
    command! -buffer TWDelete            :call taskwarrior#delete()
    command! -buffer TWDeleteAnnotation  :call taskwarrior#annotate('del')
    command! -buffer TWModifyInteractive :call taskwarrior#modify('')
    command! -buffer TWSync              :call taskwarrior#sync('sync')
endif

command! -buffer TWReportInfo        :call taskwarrior#get_info()
command! -buffer TWToggleReadonly    :let g:task_readonly = (g:task_readonly ? 0 : 1) | call taskwarrior#init()
command! -buffer TWToggleHLField     :let g:task_highlight_field = (g:task_highlight_field ? 0 : 1) | call taskwarrior#refresh()
command! -buffer -nargs=? -complete=customlist,taskwarrior#sort_complete TWReportSort :call taskwarrior#sort_by_arg(<q-args>)
