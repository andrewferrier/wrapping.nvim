if exists('g:loaded_wrapping_softhard') || &compatible
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

if !exists('g:wrapping_softhard_line_length_compensator')
    let g:wrapping_softhard_line_length_compensator=1.4
endif

if !exists('g:wrapping_softhard_autodetermine')
    let g:wrapping_softhard_autodetermine=1
endif

if !exists('g:wrapping_softhard_integrate_airline')
    let g:wrapping_softhard_integrate_airline=1
endif

if g:wrapping_softhard_default_hard !=# 'hard' && g:wrapping_softhard_default_hard !=# 'soft'
    :echoerr g:wrapping_softhard_default_hard . ' is not a valid value for g:wrapping_softhard_default_hard'
    finish
endif

set linebreak " Only relevant when wrapping is turned on

function! s:SoftWrapModeInternal()
    " Effectively disable textwidth (setting it to 0 makes it act like 79 for gqxx)
    let &l:textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
    setlocal wrap

    nmap <buffer> <Up> g<Up>
    nmap <buffer> <Down> g<Down>
    let b:wrapmappingsinitialized = 1

    let b:wrapmode = 'soft'
endfunction

function! s:HardWrapModeInternal()
    let &l:textwidth=g:wrapping_softhard_textwidth_for_hard
    setlocal nowrap

    if exists('b:wrapmappingsinitialized') && b:wrapmappingsinitialized == 1
        nunmap <buffer> <Up>
        nunmap <buffer> <Down>
    endif
    let b:wrapmappingsinitialized = 0

    let b:wrapmode = 'hard'
endfunction

function! s:SoftWrapMode()
    call <SID>SoftWrapModeInternal()
    echomsg 'Soft wrapping options enabled.'
endfunction

function! s:HardWrapMode()
    call <SID>HardWrapModeInternal()
    echomsg 'Hard wrapping options enabled.'
endfunction

function! s:ToggleWrapMode()
    let s:currentmode = <SID>GetCurrentMode()

    if s:currentmode ==# 'hard'
        let b:wrapmode = 'soft'
    else
        let b:wrapmode = 'hard'
    endif

    if b:wrapmode ==# 'hard'
        call <SID>HardWrapMode()
    else
        call <SID>SoftWrapMode()
    endif
endfunction

function s:GetCurrentMode()
    if exists('b:wrapmode')
        return b:wrapmode
    else
        return g:wrapping_softhard_default_hard
    endif
endfunction

function s:SetHardOrSoftModeAuto()
    let s:size = getfsize(expand('%'))
    let s:average_length=s:size / line('$')
    if (s:average_length * g:wrapping_softhard_line_length_compensator) < g:wrapping_softhard_textwidth_for_hard
        call <SID>HardWrapModeInternal()
    else
        call <SID>SoftWrapModeInternal()
    endif
endfunction

command! -bar SoftWrapMode call <SID>SoftWrapMode()
command! -bar HardWrapMode call <SID>HardWrapMode()
command! -bar ToggleWrapMode call <SID>ToggleWrapMode()

if g:wrapping_softhard_autodetermine
    augroup softhard_init
        autocmd BufRead * call <SID>SetHardOrSoftModeAuto()
    augroup END
endif

if g:wrapping_softhard_default_hard ==# 'hard'
    let &textwidth=g:wrapping_softhard_textwidth_for_hard
    set nowrap
else
    let &textwidth=s:VERY_LONG_TEXTWIDTH_FOR_SOFT
    set wrap
endif

if exists('g:loaded_airline') && g:loaded_airline && g:wrapping_softhard_integrate_airline
    function! SoftHardApply(...)
        let w:airline_section_y = get(w:, 'airline_section_y', g:airline_section_y)
        let w:airline_section_y .= ' %{GetHardSoftAirline()}'
    endfunction

    function! GetHardSoftAirline()
        let s:currentmode = <SID>GetCurrentMode()

        if s:currentmode ==# 'hard'
            return '(H)'
        else
            return '(s)'
        endif
    endfunction

    call airline#parts#define_raw('GHSA', '%{GetHardSoftAirline()}')
    call airline#add_statusline_func('SoftHardApply')
endif

if exists('g:loaded_unimpaired')
    nnoremap [ow :call <SID>SoftWrapMode()<CR>
    nnoremap ]ow :call <SID>HardWrapMode()<CR>
    nnoremap yow :call <SID>ToggleWrapMode()<CR>
endif
