if exists('g:loaded_wrapping_softhard') || &cp
    finish
endif
let g:loaded_wrapping_softhard = 1

if !exists('g:wrapping_softhard_textwidth_for_hard')
    let g:wrapping_softhard_textwidth_for_hard=79
endif

set linebreak " Only relevant when wrapping is turned on

function! s:SoftWrapMode()
    " Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
    setlocal textwidth=999999
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

let &textwidth=g:wrapping_softhard_textwidth_for_hard
set nowrap
