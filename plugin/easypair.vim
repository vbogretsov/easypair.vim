" -------------------------- Surround -----------------------------------------
function! s:ispaired_double_quote(char)
    return a:char == '"'
endfunction

function! s:ispaired_single_quote(char)
    return a:char == "'"
endfunction

function! s:ispaired_angle_quote(char)
    return a:char == '`'
endfunction

function! s:ispaired_bracket(char)
    return a:char == ')'
endfunction

function! s:ispaired_square_bracket(char)
    return a:char == ']'
endfunction

function! s:ispaired_curly_bracket(char)
    return a:char == '}'
endfunction

let s:paired = {
    \ '"': function('s:ispaired_double_quote'),
    \ "'": function('s:ispaired_single_quote'),
    \ '`': function('s:ispaired_angle_quote'),
    \ '[': function('s:ispaired_square_bracket'),
    \ '{': function('s:ispaired_square_bracket'),
    \ '(': function('s:ispaired_bracket')
    \}

function! s:reselect()
    let v = getpos("'<")
    call cursor(l:v[1], l:v[2] + 1)
    exec 'normal 1v'
endfunction

function! s:findchar(x, y, step, pred)
    let nlines = line('$')

    let i = a:x
    let j = a:y

    let line = getline(l:j)
    let len = strlen(l:line)

    while l:j >= 1 && l:j <= l:nlines

        while l:i >= 0 && l:i < l:len
            if a:pred(l:line[l:i])
                return [l:line[l:i], l:j, l:i]
            endif
            let i = l:i + a:step
        endwhile

        let j = l:j + a:step
        let line = getline(l:j)
        let len = strlen(l:line)
        let i = a:step > 0 ? 0  : l:len - 1
    endwhile

    return []
endfunction

function! s:ispaired(char)
    return has_key(s:paired, a:char)
endfunction

function! Unpair()
    let x = col('.')
    let y = line('.')

    let Lpred = function('s:ispaired')

    let l = s:findchar(l:x, l:y, -1, Lpred)
    if l:l == []
        return
    endif

    let Rpred = s:paired[l:l[0]]

    let r = s:findchar(l:x, l:y, 1, Rpred)
    if l:r == []
        return
    endif

    call cursor(l:l[1], l:l[2] + 1)
    execute 'normal x'

    call cursor(l:r[1], l:r[2] + (l:l[1] == l:r[1] ? 0 : 1))
    execute 'normal x'

    call cursor(l:y, l:x)
endfunction


xnoremap <buffer> <silent> " c""<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
xnoremap <buffer> <silent> ' c''<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
xnoremap <buffer> <silent> ` c``<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
xnoremap <buffer> <silent> [ c[]<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
xnoremap <buffer> <silent> ( c()<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
xnoremap <buffer> <silent> { c{}<c-o>h<c-r>"<esc>:call <SID>reselect()<cr>
