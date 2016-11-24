## vim-wrapping-softhard

This is a Vim plugin designed to make it easy to flip between 'soft' and
'hard' wrapping when editing text-like files. Typically one comes across
various text files which have no hard carriage returns to wrap text - each
paragraph is one long line (e.g. many Markdown files are like this). Other
files use "hard" wrapping (like this README, for example), where each line
ending is "hard" wrapped using the author's preference for line length
(typically in the 78-80 character range).

This plugin makes it easy to quickly flip between the two when files are open,
setting the relevant vim settings to make it "natural" to edit the file that
way.

## Installation

Use a vim package manager. If you don't have one,
[pathogen.vim](https://github.com/tpope/vim-pathogen) is a good place to
start. Once you've installed it, run:

    cd ~/.vim/bundle
    git clone git://github.com/andrewferrier/vim-wrapping-softhard.git
