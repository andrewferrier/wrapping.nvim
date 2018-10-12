# vim-wrapping-softhard

**Note**: this plugin has been deprecated as I am replacing my own usage with
that of [vim-pencil](https://github.com/reedes/vim-pencil) which provides
similar functionality.

---

~~This is a Vim plugin designed to make it easy to flip between 'soft' and
'hard' wrapping when editing text-like files. Typically one comes across
various text files which have no hard carriage returns to wrap text - each
paragraph is one long line (e.g. many Markdown files are like this). Other
files use "hard" wrapping (like this README, for example), where each line
ending is "hard" wrapped using the author's preference for line length
(typically in the 78-80 character range).~~

~~This plugin makes it easy to quickly flip between the two when files are open,
setting the relevant vim settings to make it "natural" to edit the file that
way. At the moment, this just changes `textwidth` and `wrap/nowrap`. It will
also re-map the up and down keys depending on the wrapping style, so they
move by screen line in soft mode.~~

## Minimal Configuration

As well as installing the plugin (see 'Installation' below), you will also
likely want to have some keybindings for the `SoftWrapMode` and `HardWrapMode`
commands, which flip between the different types of wrapping. This should
probably look roughly like this in your vim configuration (change the keys
themselves to your preference):

    nnoremap <Leader>ws :SoftWrapMode<CR>
    nnoremap <Leader>wh :HardWrapMode<CR>
    nnoremap <Leader>wt :ToggleWrapMode<CR>

## Settings

* `set g:wrapping_softhard_textwidth_for_hard=NNN` - column at which text is
  wrapped by default in hard wrapping mode. Defaults to 79.

* `set g:wrapping_softhard_default_hard='soft'|'hard'` - set to either 'hard'
  or 'soft', determines which is the default for newly-loaded files. This is
  'hard' by default if not set.

* `set g:wrapping_softhard_autodetermine=0|1` - this determines whether
  softhard will (1) or will not (0) attempt to automatically determine if a
  file, when being opened, should be treated with soft or hard line endings
  and switch modes automatically. Defaults to on.

* `set g:wrapping_softhard_line_length_compensator=N.N` - when determining
  automatic modes, the plugin will calculate the average line length, and
  multiply it by this factor. If that's less than
  g:wrapping_softhard_textwidth_for_hard, hard lines will be used, otherwise
  soft. This factor is 0.6 by default.

* `set g:wrapping_softhard_integrate_airline=0|1` - by default, the plugin
  will integrate with
  [vim-airline](https://github.com/vim-airline/vim-airline/) to automatically
  add an `.H` or `.s` to the status line next to the encoding type. If you
  set this to `0`, or this plugin detects that `vim-airline` is not loaded (it
  should be loaded before `vim-wrapping-softhard`), this will not happen.

## Installation

Like [any vim
plugin](https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi).

## Hacking

There are some [vader tests](https://github.com/junegunn/vader.vim) in the
`tests/` directory.
