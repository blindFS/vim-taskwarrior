vim-taskwarrior
===============

_a vim interface for [taskwarrior](https://taskwarrior.org)_

Taskwarrior is a command-line todo list manager. It helps you manage task lists
with projects, tags, dates, dependencies, annotations, recurrences and apply
complex (or simple) queries with attribute modifiers, boolean, regex filters
and produce any number of reports, built-in or customizable reports, attributes
and color themes. Task keeps data in JSON text files and it's always improving.
Find out more at https://taskwarrior.org and read man task and man taskrc.

vim-taskwarrior is a vim plugin that extends taskwarrior with an interactive
interface. It features a rich set of mappings and commands, is easy to customize,
and makes adding, modifying, sorting, reporting and marking done, fast, easy and fun!
Homepage: https://github.com/farseer90718/vim-taskwarrior, patches welcome!

----

### Prerequisites:

This plugin requires Taskwarrior 2.2.0 or higher, although >2.3.x is required
for taskd sync functions, and recommended in general, and well worth the price;
free :)
see: https://taskwarrior.org/download/

Vim version 7.x is required.

Suggested plugins

* [vim-airline](https://github.com/bling/vim-airline) for [better statusline information](https://github.com/farseer90718/vim-taskwarrior#screenshot).
* [unite.vim](https://github.com/Shougo/unite.vim) for easier bookmark/history operations.

If you experience line-wrapping issues, add the following line to your .vimrc

```
let g:task_rc_override = 'rc.defaultwidth=0'
```

If you experience task truncation (vim-taskwarrior not showing enough tasks), add:

```
let g:task_rc_override = 'rc.defaultheight=0'
```


----

### Screenshot:

![screenshot](https://raw.github.com/farseer90718/vim-taskwarrior/master/screenshot.png)
![vim-taskwarrior animated gif](http://taskextras.org/attachments/download/655/20131110_002753.gif)

### Installing:

Either [download zip file](https://github.com/farseer90718/vim-taskwarrior/archive/master.zip)
and extract in ~/.vim or use your favorite plugin manager.

- [Pathogen](https://github.com/tpope/vim-pathogen)
    - `git clone https://github.com/farseer90718/vim-taskwarrior ~/.vim/bundle/vim-taskwarrior`
- [Vundle](https://github.com/gmarik/vundle)
    1. Add `Bundle 'farseer90718/vim-taskwarrior'` to .vimrc
    2. Run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
    1. Add `NeoBundle 'farseer90718/vim-taskwarrior'` to .vimrc
    2. Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
    1. Add `Plug 'blindFS/vim-taskwarrior'` to .vimrc
    2. Run `:PlugInstall`

----

### Default map:

```vim
nnoremap <buffer> A       ... " add annotation
nnoremap <buffer> x       ... " delete annotation.
nnoremap <buffer> o       ... " open the annotation as a file.
nnoremap <buffer> a       ... " create new task.
nnoremap <buffer> d       ... " set the task in current line done.
nnoremap <buffer> D       ... " delete task
nnoremap <buffer> <Del>   ... " delete field/annotation/task
nnoremap <buffer> <Space> ... " select/remove current task to selected list
nnoremap <buffer> m       ... " modify current field.
nnoremap <buffer> M       ... " modify current task.
nnoremap <buffer> f       ... " change filter
nnoremap <buffer> r       ... " change report type
nnoremap <buffer> c       ... " execute a command for selected tasks/current task
nnoremap <buffer> R       ... " refresh the report/clear selected list
nnoremap <buffer> q       ... " quit buffer.
nnoremap <buffer> X       ... " clear all completed task.
nnoremap <buffer> p       ... " duplicate selected tasks
nnoremap <buffer> u       ... " undo last change.
nnoremap <buffer> +       ... " start task
nnoremap <buffer> -       ... " stop task
nnoremap <buffer> S       ... " sync with taskd server.
nnoremap <buffer> s       ... " sort by this column primarily.(if already of the highest priority then switch the polarity)
nnoremap <buffer> <       ... " sort by this column increasingly.(if already increasingly then increase its priority)
nnoremap <buffer> >       ... " sort by this column decreasingly.(if already decreasingly then decrease its priority)
nnoremap <buffer> H       ... " cycle column format left
nnoremap <buffer> L       ... " cycle column format right
nnoremap <buffer> J       ... " next historical entry
nnoremap <buffer> K       ... " previous historical entry
nnoremap <buffer> B       ... " create a bookmark for current combination
nnoremap <buffer> <F1>    ... " view the documents
nnoremap <buffer> <CR>    ... " show task info.
nnoremap <buffer> <TAB>   ... " jump to the next column
nnoremap <buffer> <S-TAB> ... " jump to the previous column
nnoremap <buffer> <right> ... " jump to the next non-empty column
nnoremap <buffer> <left>  ... " jump to the previous non-empty column
vnoremap <buffer> d       ... " set done to all visual selected tasks
vnoremap <buffer> D       ... " delete all visual selected tasks
vnoremap <buffer> <CR>    ... " show information about visual selected tasks
vnoremap <buffer> <Space> ... " add visual selected tasks to selected list

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
:TWHistory            " list history records using unite.vim
:TWHistoryClear       " clear history
:TWBookmark           " list bookmarks using unite.vim
:TWBookmarkClear      " clear bookmarks

```
----

### Options:

```vim
" default task report type
let g:task_report_name     = 'next'
" custom reports have to be listed explicitly to make them available
let g:task_report_command  = []
" whether the field under the cursor is highlighted
let g:task_highlight_field = 1
" can not make change to task data when set to 1
let g:task_readonly        = 0
" vim built-in term for task undo in gvim
let g:task_gui_term        = 1
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
" directory to store log files defaults to taskwarrior data.location
let g:task_log_directory   = '~/.task'
" max number of historical entries
let g:task_log_max         = '20'
" forward arrow shown on statusline
let g:task_left_arrow      = ' <<'
" backward arrow ...
let g:task_left_arrow      = '>> '

```
----

### Syntax highlightling:

Default scheme:

```vim
highlight default link taskwarrior_tablehead   Tabline
highlight default link taskwarrior_field       IncSearch
highlight default link taskwarrior_selected    Visual
highlight default link taskwarrior_id          VarId
highlight default link taskwarrior_project     String
highlight default link taskwarrior_Status      Include
highlight default link taskwarrior_priority    Class
highlight default link taskwarrior_due         Todo
highlight default link taskwarrior_end         Keyword
highlight default link taskwarrior_description Normal
highlight default link taskwarrior_entry       Special
highlight default link taskwarrior_depends     Todo
highlight default link taskwarrior_tags        Keyword
highlight default link taskwarrior_uuid        VarId
highlight default link taskwarrior_urgency     Todo
```

Feel free to change any of above by something like:

```vim
hi taskwarrior_xxx  guibg = xxx guifg = xxx ctermbg = xxx ctermfg = xxx
```

in your vimrc.

### Acknowledgement:

* [vim-airline](https://github.com/bling/vim-airline) by bling
* [unite.vim](https://github.com/Shougo/unite.vim)   by Shougo
* [webapi-vim](https://github.com/mattn/webapi-vim)  by mattn

### License:

[MIT](https://raw.github.com/farseer90718/vim-taskwarrior/master/LICENSE.txt)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/farseer90718/vim-taskwarrior/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

