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

nnoremap <Leader>ws :call <SID>SoftWrapMode()<CR>
nnoremap <Leader>wh :call <SID>HardWrapMode()<CR>

if g:wrapping_softhard_default_hard == 'hard'
    let &textwidth=g:wrapping_softhard_textwidth_for_hard
    set nowrap
else
    let &textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
    set wrap
endif
