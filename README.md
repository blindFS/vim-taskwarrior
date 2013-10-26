vim-taskwarrior
===============

A vim interface for [taskwarrior](http://taskwarrior.org)

----

(add this line to .taskrc, or wrapping may be mangled :)

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
:TW [args]            " task [filter report arguments]
:TWAdd                " add new tasks interactively
:TWAnnotation         " add an annotation
:TWComplete           " mark task done
:TWDelete             " deleta a task
:TWDeleteAnnotation   " delete an annotation
:TWDeleteCompleted    " clear all completed tasks 
:TWEditTaskrc         " edit ~/.taskrc
:TWEditVitrc          " edit ~/.vitrc
:TWModifyInteractive  " make changes to a task interactively (use with caution!)
:TWReportInfo         " run the info report
:TWSync               " synchronise with taskd server
:TWUndo               " undo the previous modification

```
