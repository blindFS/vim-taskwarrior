taskwarrior.vim
===============
_a vim interface for [Taskwarrior](https://taskwarrior.org)_

![screenshot](https://raw.githubusercontent.com/xarthurx/taskwarrior.vim/master/screenshot.png)

**This repo is forked from [blindFS/vim-taskwarrior](https://github.com/blindFS/vim-taskwarrior) for maintenance and development.**

----
[taskwarrior.vim](https://github.com/xarthurx/taskwarrior.vim) is a vim plugin that extends Taskwarrior with an interactive
interface. It features a rich set of mappings and commands, is easy to customize,
and makes adding, modifying, sorting, reporting and marking done, fast, easy and fun!

## Things added since forked

* Support for native Windows 10 by calling *TaskWarrior* from *WSL* (*TaskWarrior* need to be installed inside *WSL*).
* Fix `del` and `undo` bug by ignoring confirmation from shell.
* Various small bugs has been fixed by browsing the issue list from the original repo.
* Fix an issue that treat multiple tags connected with `<space>` as a single tag.
* Fix an issue that not be able to cancel modification process.
* Merge multiple calls of shell cmd to improve performance in *WSL* environment.


## Prerequisites:

This plugin requires Taskwarrior 2.3.0 or higher. see: https://taskwarrior.org/download/

Vim version 8.x is suggested. (7.x might still be fine, but will not be supported.)

Suggested plugins

* [vim-airline](https://github.com/bling/vim-airline) for [better statusline information](https://github.com/farseer90718/vim-taskwarrior#screenshot).
* [unite.vim](https://github.com/Shougo/unite.vim) for easier bookmark/history operations.


## Installation:

Either [download zip file](https://github.com/farseer90718/vim-taskwarrior/archive/master.zip)
and extract in ~/.vim or use your favorite plugin manager.

- [Pathogen](https://github.com/tpope/vim-pathogen)
    - `git clone https://github.com/xarthurx/taskwarrior.vim ~/.vim/bundle/taskwarrior.vim`
- [Vundle](https://github.com/gmarik/vundle)
    1. Add `Plugin 'xarthurx/taskwarrior.vim'` to .vimrc
    2. Run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
    1. Add `NeoBundle 'xarthurx/taskwarrior.vim'` to .vimrc
    2. Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
    1. Add `Plug 'xarthurx/taskwarrior.vim'` to .vimrc
    2. Run `:PlugInstall`


### Native Windows Support with WSL

Since TaskWarrior does not provide a [native Windows version](https://github.com/GothenburgBitFactory/taskwarrior/issues/2159), native Windows VIM users need to install it inside *WSL* environment. The plugin will take care of the rest.

## Options

### Default map:

```vim
nnoremap <buffer> A       ... " add annotation
nnoremap <buffer> x       ... " delete annotation.
nnoremap <buffer> o       ... " open the annotation as a file.
nnoremap <buffer> a       ... " create new task.
nnoremap <buffer> d       ... " set the task in current line done.
nnoremap <buffer> D       ... " delete field/annotation/task
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
### User options:

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


" for native windows, the following two commands are used

```vim
let g:taskwarrior_cmd      = 'wsl task'
let g:task_grep            = 'findstr'
```

If you experience line-wrapping issues, add the following line to your .vimrc
```
let g:task_rc_override = 'rc.defaultwidth=0'
```
If you experience task truncation (taskwarrior.vim not showing enough tasks) add the following line to your .vimrc
```vim
let g:task_rc_override = 'rc.defaultheight=0'
```


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

Feel free to change any of above by something like below in your `vimrc`.

```vim
hi taskwarrior_xxx  guibg = xxx guifg = xxx ctermbg = xxx ctermfg = xxx
```


## Acknowledgement:

* [vim-airline](https://github.com/bling/vim-airline) by bling
* [unite.vim](https://github.com/Shougo/unite.vim)   by Shougo
* [webapi-vim](https://github.com/mattn/webapi-vim)  by mattn

## License:

[MIT](https://raw.github.com/xarthurx/taskwarrior.vim/master/LICENSE.txt)

