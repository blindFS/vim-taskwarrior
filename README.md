vim-taskwarrior
===============

vim interface for taskwarrior

Should add these lines to .taskrc

    report.all.labels=ID,Project,Status,Pri,Due,Complete,Description,UUID
    report.all.columns=id,project,status,priority,due,end,description,uuid

    defaultwidth=999

Or this plugin may not work correctly.

default map

```vim
nnoremap <buffer> c ... " create new task.
nnoremap <buffer> d ... " set the task in current line done.
nnoremap <buffer> i ... " show task info.
nnoremap <buffer> m ... " modify current task.
nnoremap <buffer> q ... " quit buffer.
nnoremap <buffer> r ... " clear all completed task.
nnoremap <buffer> u ... " undo last change.
nnoremap <buffer> x ... " delete the task in current line.
nnoremap <buffer> s ... " show summary info.
```
