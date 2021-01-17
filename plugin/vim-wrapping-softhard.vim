if exists('g:loaded_wrapping_softhard') || &compatible
    finish
endif
let g:loaded_wrapping_softhard=1

if !exists('g:wrapping_softhard_line_length_compensator')
    let g:wrapping_softhard_line_length_compensator=1.0
endif

command! -bar SoftWrapMode call vim_wrapping_softhard#SoftWrapMode()
command! -bar HardWrapMode call vim_wrapping_softhard#HardWrapMode()
command! -bar ToggleWrapMode call vim_wrapping_softhard#ToggleWrapMode()

set linebreak " Only relevant when wrapping is turned on
set nowrap

if exists('g:loaded_unimpaired')
    nnoremap [ow :SoftWrapMode<CR>
    nnoremap ]ow :HardWrapMode<CR>
    nnoremap yow :ToggleWrapMode<CR>
endif
