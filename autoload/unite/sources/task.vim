let s:save_cpo = &cpo
set cpo&vim

let s:template = {
            \ 'name' : 'task/',
            \ 'description' : 'vim-taskwarrior ',
            \ 'filters' : ['matcher_regexp'],
            \ 'action_table': {},
            \ 'hooks' : {},
            \ }

let s:bookmark = {
            \ 'name' : 'bookmark',
            \ 'logfile' : expand(g:task_log_directory.'/.vim_tw.bookmark')
            \ }

let s:history = {
            \ 'name' : 'history',
            \ 'logfile' : expand(g:task_log_directory.'/.vim_tw.history')
            \ }

function! s:make_source(dict)
    let source = deepcopy(s:template)
    let source.name .= a:dict.name
    let source.description .= a:dict.name
    let source.logfile = a:dict.logfile

    function! source.hooks.on_syntax(args, context)
        syntax match uniteSource__task_rc /rc.*/ contained containedin=ALL contains=uniteCandidateInputKeyword
        syntax match uniteSource__task_report /\w\+\ze[ \t]\+/ contained containedin=ALL
        highlight default link uniteSource__task_rc String
        highlight default link uniteSource__task_report Keyword
    endfunction

    function! source.gather_candidates(args, context)
        if findfile(self.logfile) == ''
            call writefile([], self.logfile)
        endif
        return map(reverse(readfile(self.logfile)),
                    \ '{"word": v:val,
                    \ "kind": "task",
                    \ "source": "task/" . self.name,
                    \ }')
    endfunction

    let source.action_table.delete = {
                \ 'description' : 'remove the item',
                \ }

    function! source.action_table.delete.func(candidate)
        let current = substitute(a:candidate.word, '\s', '', 'g')
        let lfile = g:task_log_directory.'/.vim_tw.bookmark'
        let all = readfile(lfile)
        let allns = map(copy(all), "substitute(v:val, '[ \t]', '', 'g')")
        call remove(all, index(allns, current))
        call writefile(all, lfile)
    endfunction

    return source
endfunction

function! unite#sources#task#define()
    return map([s:bookmark, s:history], 's:make_source(v:val)')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
