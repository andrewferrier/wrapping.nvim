let s:VERY_LONG_TEXTWIDTH_FOR_SOFT=999999

function! vim_wrapping_softhard#SoftWrapMode()
    if !(exists('b:wrapmode') && b:wrapmode ==# 'soft')
        " Save prior textwidth
        let b:hard_textwidth=&l:textwidth

        " Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
        let &l:textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
        setlocal wrap

        nmap <buffer> <Up> g<Up>
        nmap <buffer> <Down> g<Down>
        let b:wrapmappingsinitialized = 1

        let b:wrapmode = 'soft'
    endif
endfunction

function! vim_wrapping_softhard#HardWrapMode()
    if !(exists('b:wrapmode') && b:wrapmode ==# 'hard')
        if exists('b:hard_textwidth')
            let &l:textwidth=b:hard_textwidth
            unlet b:hard_textwidth
        endif

        setlocal nowrap

        if exists('b:wrapmappingsinitialized') && b:wrapmappingsinitialized == 1
            nunmap <buffer> <Up>
            nunmap <buffer> <Down>
        endif
        let b:wrapmappingsinitialized = 0

        let b:wrapmode = 'hard'
    endif
endfunction

function s:CountBlankLines()
    let l:svpos = winsaveview()
    let l:count = 0
    g/^\s*$/let l:count += 1
    return l:count
    call winrestview(l:svpos)
endfunction

function vim_wrapping_softhard#SetModeAutomatically()
    let l:size = getfsize(expand('%'))
    let l:average_line_length=l:size / (line('$') - s:CountBlankLines())

    if exists('b:hard_textwidth')
        let l:hard_textwidth_for_comparison = b:hard_textwidth
    else
        let l:hard_textwidth_for_comparison = &l:textwidth
    endif

    if (l:average_line_length * g:wrapping_softhard_line_length_compensator) < l:hard_textwidth_for_comparison
        call vim_wrapping_softhard#HardWrapMode()
    else
        call vim_wrapping_softhard#SoftWrapMode()
    endif
endfunction

function! vim_wrapping_softhard#ToggleWrapMode()
    if vim_wrapping_softhard#GetCurrentMode() ==# 'hard'
        call vim_wrapping_softhard#SoftWrapMode()
    else
        call vim_wrapping_softhard#HardWrapMode()
    endif
endfunction

function vim_wrapping_softhard#GetCurrentMode()
    if exists('b:wrapmode')
        return b:wrapmode
    else
        return 'hard'
    endif
endfunction
