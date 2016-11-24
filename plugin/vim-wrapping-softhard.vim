if exists('g:loaded_wrapping_softhard') || &cp
    finish
endif
let g:loaded_wrapping_softhard=1

let s:VERY_LONG_TEXTWIDTH_FOR_SOFT=999999

if !exists('g:wrapping_softhard_textwidth_for_hard')
    let g:wrapping_softhard_textwidth_for_hard=79
endif

if !exists('g:wrapping_softhard_default_hard')
    let g:wrapping_softhard_default_hard='hard'
endif

" TODO: Assert that g:wrapping_softhard_default_hard is either 'hard' or 'soft'

set linebreak " Only relevant when wrapping is turned on

function! s:SoftWrapMode()
    " Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
    let &l:textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
    setlocal wrap
    echo "Soft wrapping options enabled."
endfunction

function! s:HardWrapMode()
    let &l:textwidth=g:wrapping_softhard_textwidth_for_hard
    setlocal nowrap
    echo "Hard wrapping options enabled."
endfunction

function! s:ToggleWrapMode()
    if exists('b:wrapmode')
        if b:wrapmode == 'hard'
            let b:wrapmode = 'soft'
        else
            let b:wrapmode = 'hard'
        endif
    else
        " This seems the wrong way round, but we are toggling away from what
        " *was* the default.
        if g:wrapping_softhard_default_hard == 'hard'
            let b:wrapmode = 'soft'
        else
            let b:wrapmode = 'hard'
        endif
    endif

    if b:wrapmode == 'hard'
        call <SID>HardWrapMode()
    else
        call <SID>SoftWrapMode()
    endif
endfunction

command! -bar SoftWrapMode call <SID>SoftWrapMode()
command! -bar HardWrapMode call <SID>HardWrapMode()
command! -bar ToggleWrapMode call <SID>ToggleWrapMode()

if g:wrapping_softhard_default_hard == 'hard'
    let &textwidth=g:wrapping_softhard_textwidth_for_hard
    set nowrap
else
    let &textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
    set wrap
endif
