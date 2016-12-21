#!/bin/bash

vim -Nu <(cat << EOF
filetype off
set rtp+=~/.vim/plugged/vader.vim
set rtp+=.
filetype plugin indent on
syntax enable
EOF) -c 'Vader! *.vader' > /dev/null
