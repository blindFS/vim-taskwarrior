vim-taskwarrior
===============

vim interface for [taskwarrior](http://taskwarrior.org)

----

Add this line to .taskrc, or wrapping may be mangled :)

    defaultwidth=999

----

Default map:

```vim
nnoremap <buffer> A ... " add annotation
nnoremap <buffer> D ... " delete task
nnoremap <buffer> a ... " create new task.
nnoremap <buffer> d ... " set the task in current line done.
nnoremap <buffer> <CR>. " show task info.
nnoremap <buffer> m ... " modify current task.
nnoremap <buffer> q ... " quit buffer.
nnoremap <buffer> r ... " clear all completed task.
nnoremap <buffer> u ... " undo last change.
nnoremap <buffer> x ... " delete annotation.
nnoremap <buffer> s ... " sync with taskd server.
```

Commands:
```vim
:TW [args]     " task [filter report arguments]
:TWEditTaskrc  " edit ~/.taskrc
:TWEditVitrc   " edit ~/.vitrc
:TWSync        " Synchronise with taskd server

```
