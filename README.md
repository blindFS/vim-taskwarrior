vim-taskwarrior
===============

vim interface for [taskwarrior](http://taskwarrior.org)

Should add this line to .taskrc

    defaultwidth=999

Or lines may be awfully wrapped.

And **uuid** field is recommanded in **report.all.columns** to get the exact filter for current task.

Default map:

```vim
nnoremap <buffer> a ... " add annotation
nnoremap <buffer> n ... " delete annotation
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

Commands:
```vim
:TaskList       " Show all tasks
:TaskPush       " Synchronising with remote server
:TaskPull
:TaskMerge
:TaskEditConfig " Edit your .taskrc
```
