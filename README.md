vim-taskwarrior
===============

_a vim interface for [taskwarrior](http://taskwarrior.org)_

Taskwarrior is a command-line todo list manager. It helps you manage task lists
with projects, tags, dates, dependencies, annotations, recurrences and apply
complex (or simple) queries with attribute modifiers, boolean, regex filters
and produce any number of reports, built-in or customizable reports, attributes
and color themes. Task keeps data in JSON text files and it's always improving. 
Find out more at http://taskwarrior.org and read man task and man taskrc.

vim-taskwarrior is a vim plugin that extends taskwarrior with an interactive
interface. It extends a rich set of mappings and commands, is easy to customize,
and makes adding, modifying, sorting and marking done, fast, easy and fun!  
Homepage: https://github.com/farseer90718/vim-taskwarrior, patches welcome!

----

### Prerequisites:

This plugin requires Taskwarrior 2.2.0 or higher, although >2.3.x is required
for taskd sync functions, and recommended in general, and well worth the price; 
free :) see: http://taskwarrior.org/projects/taskwarrior/wiki/Download

Vim version 7.x is required.

the vim-airline plugin (https://github.com/bling/vim-airline) is not required
but it greatly enhances the status-bar and takes the guess-work out of reports. 

If you experience line-wrapping issues, add the following line to your .vimrc

```
let g:task_rc_override = 'defaultwidth=999' 
```

----

### Installing:

You can install this [the hard way](http://vimdoc.sourceforge.net/htmldoc/usr_05.html#05.4) like any vim plugin, or the easy way;

Using pathogen (http://www.vim.org/scripts/script.php?script_id=2332)

    cd ~/.vim
    mkdir bundle
    cd bundle
    git clone https://github.com/farseer90718/vim-taskwarrior

Then launch vim and run `:Helptags` then `:help vim-tw` to verify it was installed.

----

### Default map:

```vim
nnoremap <buffer> A       ...  " add annotation
nnoremap <buffer> D       ...  " delete task
nnoremap <buffer> a       ...  " create new task.
nnoremap <buffer> d       ...  " set the task in current line done.
nnoremap <buffer> f       ...  " change filter
nnoremap <buffer> c       ...  " new command
nnoremap <buffer> m       ...  " modify current field.
nnoremap <buffer> M       ...  " modify current task.
nnoremap <buffer> q       ...  " quit buffer.
nnoremap <buffer> r       ...  " clear all completed task.
nnoremap <buffer> u       ...  " undo last change.
nnoremap <buffer> x       ...  " delete annotation.
nnoremap <buffer> +       ...  " start task
nnoremap <buffer> -       ...  " stop task
nnoremap <buffer> S       ...  " sync with taskd server.
nnoremap <buffer> s       ...  " sort by this column primarily.(if already of the highest priority then switch the polarity)
nnoremap <buffer> <       ...  " sort by this column increasingly.(if already increasingly then increase its priority)
nnoremap <buffer> >       ...  " sort by this column decreasingly.(if already decreasingly then decrease its priority)
nnoremap <buffer> H       ...  " cycle column format left
nnoremap <buffer> L       ...  " cycle column format right
nnoremap <buffer> <F1>    ...  " view the documents
nnoremap <buffer> <CR>    ...  " show task info.
nnoremap <buffer> <TAB>   ...  " jump to the next column
nnoremap <buffer> <S-TAB> ...  " jump to the previous column
nnoremap <buffer> <right> ...  " jump to the next non-empty column
nnoremap <buffer> <left>  ...  " jump to the previous non-empty column

```
----

### Commands:

```vim
:TW [args]            " task [filter report arguments]
:TWUndo               " undo the previous modification
:TWEditTaskrc         " edit ~/.taskrc
:TWEditVitrc          " edit ~/.vitrc
:TWDeleteCompleted    " clear all completed tasks
:TWAdd                " add new tasks interactively
:TWAnnotate           " add an annotation
:TWComplete           " mark task done
:TWDelete             " deleta a task
:TWDeleteAnnotation   " delete an annotation
:TWModifyInteractive  " make changes to a task interactively (use with caution!)
:TWReportInfo         " run the info report
:TWReportSort [args]  " overide the sort method, reset to default if no arguments passed
:TWSync               " synchronise with taskd server
:TWToggleReadonly     " toggle readonly option
:TWToggleHLField      " toggle highlight field option

```
----

### Options

```vim
" default task report type
let g:task_report_name     = 'next'
" whether the field under the cursor is highlighted
let g:task_highlight_field = 1
" can not make change to task data when set to 1
let g:task_readonly        = 0
" allows user to override task configurations. Seperated by space. Defaults to ''
let g:task_rc_override     = 'rc.defaultwidth=999'
" default fields to ask when adding a new task
let g:task_default_prompt  = ['due', 'description']
" whether the info window is splited vertically
let g:task_info_vsplit     = 0
" info window size
let g:task_info_size       = 15
" info window position
let g:task_info_position   = 'belowright'
```
----

### License

[MIT](https://raw.github.com/farseer90718/vim-taskwarrior/master/LICENSE.txt)
