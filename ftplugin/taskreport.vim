setlocal buftype=nofile
setlocal nomodifiable
setlocal cursorline
setlocal nowrap

nnoremap <silent> <buffer> q       :call taskwarrior#quit()<CR>
nnoremap <silent> <buffer> <left>  :call taskwarrior#move_cursor('left', 'skip')<CR>
nnoremap <silent> <buffer> <S-tab> :call taskwarrior#move_cursor('left', 'step')<CR>
nnoremap <silent> <buffer> <right> :call taskwarrior#move_cursor('right', 'skip')<CR>
nnoremap <silent> <buffer> <tab>   :call taskwarrior#move_cursor('right', 'step')<CR>

if g:task_highlight_field
    autocmd CursorMoved <buffer> :call taskwarrior#hi_field()
else
    autocmd! CursorMoved <buffer>
endif

if g:task_readonly
    setlocal readonly
else
    nnoremap <buffer> A                :call taskwarrior#annotate('add')<CR>
    nnoremap <buffer> D                :call taskwarrior#delete()<CR>
    nnoremap <buffer> a                :call taskwarrior#system_call('', 'add', taskwarrior#get_args(), 'echo')<CR>
    nnoremap <buffer> d                :call taskwarrior#set_done()<CR>
    nnoremap <buffer> r                :call taskwarrior#clear_completed()<CR>
    nnoremap <buffer> u                :call taskwarrior#undo()<CR>
    nnoremap <buffer> x                :call taskwarrior#annotate('del')<CR>
    nnoremap <buffer> s                :call taskwarrior#sync('sync')<CR>
    nnoremap <buffer> <CR>             :call taskwarrior#info(taskwarrior#get_uuid().' info')<CR>
    nnoremap <silent> <buffer> m       :call taskwarrior#modify()<CR>
    nnoremap <silent> <buffer> M       :call taskwarrior#system_call(taskwarrior#get_uuid(), 'modify', taskwarrior#get_args(), 'external')<CR>
endif
