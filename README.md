vim-taskwarrior
===============

A vim interface for [taskwarrior](http://taskwarrior.org)

----

(add this line to .taskrc, or wrapping may be mangled :)

    defaultwidth=999

----

Default map:

```vim
nnoremap <buffer> A       ...  " add annotation
nnoremap <buffer> D       ...  " delete task
nnoremap <buffer> a       ...  " create new task.
nnoremap <buffer> d       ...  " set the task in current line done.
nnoremap <buffer> m       ...  " modify current field.
nnoremap <buffer> M       ...  " modify current task.
nnoremap <buffer> q       ...  " quit buffer.
nnoremap <buffer> r       ...  " clear all completed task.
nnoremap <buffer> u       ...  " undo last change.
nnoremap <buffer> x       ...  " delete annotation.
nnoremap <buffer> s       ...  " sort by this column primarily.(if already of the highest priority then switch the polarity)
nnoremap <buffer> S       ...  " sync with taskd server.
nnoremap <buffer> +       ...  " sort by this column increasingly.(if already increasingly then increase its priority)
nnoremap <buffer> -       ...  " sort by this column decreasingly.(if already decreasingly then decrease its priority)
nnoremap <buffer> <F1>    ...  " view the documents
nnoremap <buffer> <CR>    ...  " show task info.
nnoremap <buffer> <TAB>   ...  " jump to the next column
nnoremap <buffer> <S-TAB> ...  " jump to the previous column
nnoremap <buffer> <right> ...  " jump to the next non-empty column
nnoremap <buffer> <left>  ...  " jump to the previous non-empty column

```

Commands:
```vim
:TW [args]            " task [filter report arguments]
:TWAdd                " add new tasks interactively
:TWAnnotate           " add an annotation
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
