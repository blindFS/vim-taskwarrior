setlocal buftype=nofile
setlocal nomodifiable
setlocal cursorline
setlocal nowrap

nnoremap <silent> <buffer> <F1>    :h tw-quickref<CR>
nnoremap <silent> <buffer> q       :call taskwarrior#quit()<CR>
nnoremap <silent> <buffer> <left>  :call taskwarrior#action#move_cursor('left', 'skip')<CR>
nnoremap <silent> <buffer> <S-tab> :call taskwarrior#action#move_cursor('left', 'step')<CR>
nnoremap <silent> <buffer> <right> :call taskwarrior#action#move_cursor('right', 'skip')<CR>
nnoremap <silent> <buffer> <tab>   :call taskwarrior#action#move_cursor('right', 'step')<CR>
nnoremap <silent> <buffer> <       :call taskwarrior#sort#by_column('+', '')<CR>
nnoremap <silent> <buffer> >       :call taskwarrior#sort#by_column('-', '')<CR>
nnoremap <silent> <buffer> s       :call taskwarrior#sort#by_column('m', '')<CR>
nnoremap <silent> <buffer> <CR>    :call taskwarrior#action#show_info()<CR>
nnoremap <silent> <buffer> f       :call taskwarrior#action#filter()<CR>
nnoremap <silent> <buffer> H       :call taskwarrior#action#columns_format_change('left')<CR>
nnoremap <silent> <buffer> L       :call taskwarrior#action#columns_format_change('right')<CR>
nnoremap <silent> <buffer> J       :call taskwarrior#log#history('next')<CR>
nnoremap <silent> <buffer> K       :call taskwarrior#log#history('previous')<CR>
vnoremap <silent> <buffer> <CR>    :call taskwarrior#action#visual('info')<CR>

if g:task_highlight_field
    autocmd CursorMoved <buffer> :call taskwarrior#hi_field()
else
    autocmd! CursorMoved <buffer>
endif

if g:task_readonly
    setlocal readonly
else
    nnoremap <silent> <buffer> A         :call taskwarrior#action#annotate('add')<CR>
    nnoremap <silent> <buffer> D         :call taskwarrior#action#remove()<CR>
    nnoremap <silent> <buffer> <Del>     :call taskwarrior#action#delete()<CR>
    nnoremap <silent> <buffer> a         :call taskwarrior#action#new()<CR>
    nnoremap <silent> <buffer> c         :call taskwarrior#action#command()<CR>
    nnoremap <silent> <buffer> d         :call taskwarrior#action#set_done()<CR>
    nnoremap <silent> <buffer> r         :call taskwarrior#action#report()<CR>
    nnoremap <silent> <buffer> R         :call taskwarrior#list()<CR>
    nnoremap <silent> <buffer> X         :call taskwarrior#action#clear_completed()<CR>
    nnoremap <silent> <buffer> u         :call taskwarrior#action#undo()<CR>
    nnoremap <silent> <buffer> x         :call taskwarrior#action#annotate('del')<CR>
    nnoremap <silent> <buffer> S         :call taskwarrior#action#sync('sync')<CR>
    nnoremap <silent> <buffer> m         :call taskwarrior#action#modify('current')<CR>
    nnoremap <silent> <buffer> M         :call taskwarrior#action#modify('')<CR>
    nnoremap <silent> <buffer> p         :call taskwarrior#action#paste()<CR>
    nnoremap <silent> <buffer> +         :call taskwarrior#system_call(taskwarrior#data#get_uuid(), 'start', '', 'silent')<CR>
    nnoremap <silent> <buffer> -         :call taskwarrior#system_call(taskwarrior#data#get_uuid(), 'stop', '', 'silent')<CR>
    nnoremap <silent> <buffer> <Space>   :call taskwarrior#action#select()<CR>
    vnoremap <silent> <buffer> d         :call taskwarrior#action#visual('done')<CR>
    vnoremap <silent> <buffer> D         :call taskwarrior#action#visual('delete')<CR>
    vnoremap <silent> <buffer> <Del>     :call taskwarrior#action#visual('delete')<CR>
    vnoremap <silent> <buffer> <Space>   :call taskwarrior#action#visual('select')<CR>
    command! -buffer TWAdd               :call taskwarrior#action#new()
    command! -buffer TWAnnotate          :call taskwarrior#action#annotate('add')
    command! -buffer TWComplete          :call taskwarrior#action#set_done()
    command! -buffer TWDelete            :call taskwarrior#action#delete()
    command! -buffer TWDeleteAnnotation  :call taskwarrior#action#annotate('del')
    command! -buffer TWModifyInteractive :call taskwarrior#modify('')
    command! -buffer TWSync              :call taskwarrior#action#sync('sync')
endif

command! -buffer TWReportInfo        :call taskwarrior#action#show_info()
command! -buffer TWToggleReadonly    :let g:task_readonly = (g:task_readonly ? 0 : 1) | call taskwarrior#init()
command! -buffer TWToggleHLField     :let g:task_highlight_field = (g:task_highlight_field ? 0 : 1) | call taskwarrior#refresh()
command! -buffer -nargs=? -complete=customlist,taskwarrior#complete#sort TWReportSort :call taskwarrior#action#sort_by_arg(<q-args>)
