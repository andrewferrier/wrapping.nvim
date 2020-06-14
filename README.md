# vim-wrapping-softhard

**Note**: I have de-deprecated and simplified this plugin, as I was finding
[vim-pencil](https://github.com/reedes/vim-pencil) too complex for my needs.

This is a Vim plugin designed to make it easy to flip between 'soft' and 'hard'
wrapping when editing text-like files. Typically one comes across various text
files which have no hard carriage returns to wrap text - each paragraph is one
long line (e.g. many Markdown files are like this). Other files use "hard"
wrapping (like this README, for example), where each line ending is "hard"
wrapped using the author's preference for line length (typically in the 78-80
character range).

This plugin makes it easy to quickly flip between the two when files are open,
setting the relevant vim settings to make it "natural" to edit the file that
way. At the moment, this just changes `textwidth` and `wrap/nowrap`. It will
also re-map the up and down keys depending on the wrapping style, so they move
by screen line in soft mode. The default mode for files is 'hard' wrapping.

## Minimal Configuration

As well as installing the plugin (see 'Installation' below), you will also
likely want to have some key mappings for the `SoftWrapMode` and `HardWrapMode`
commands, which flip between the different types of wrapping. This should
probably look roughly like this in your vim configuration (change the keys
themselves to your preference):

    nnoremap <Leader>ws :SoftWrapMode<CR>
    nnoremap <Leader>wh :HardWrapMode<CR>
    nnoremap <Leader>wt :ToggleWrapMode<CR>

You must also call `vim_wrapping_softhard#SetModeAutomatically()` when setting
up any filetype where you wish the wrap mode to be automatically detected (e.g.,
put a call in `~/.vim/after/ftplugin/yourfiletype.vim`).

## Settings

* `let g:wrapping_softhard_line_length_compensator=N.N` - when determining
  automatic modes, the plugin will calculate the average line length, and
  multiply it by this factor. If that's less than the existing textwidth, hard
  lines will be used, otherwise soft. This factor is 1.4 by default. Setting to
  higher values makes it more likely that soft mode will be selected.

## Installation

Like [any vim
plugin](https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi).
