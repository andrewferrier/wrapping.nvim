if exists('g:loaded_wrapping_softhard') || &cp
    finish
endif
let g:loaded_wrapping_softhard = 1

set linebreak " Only relevant when wrapping is turned on

function! s:SoftWrapMode(displaymessage)
    " Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
    setlocal textwidth=999999
    setlocal wrap
    if a:displaymessage
        echo "Soft wrapping options enabled."
    endif
endfunction

function! s:HardWrapMode(displaymessage)
    setlocal textwidth=78
    setlocal nowrap
    if a:displaymessage
        echo "Hard wrapping options enabled."
    endif
endfunction

nnoremap <Leader>ws :call <SID>SoftWrapMode(1)<CR>
nnoremap <Leader>wh :call <SID>HardWrapMode(1)<CR>

:call <SID>HardWrapMode(0)
