#!/bin/bash

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
cd $REPO_ROOT

if [[ ! -d vader.vim/ ]]; then
    git clone https://github.com/junegunn/vader.vim.git
fi

cd $REPO_ROOT/tests

vim -Nu <(cat << EOF
filetype off
set rtp+=../vader.vim
set rtp+=..
filetype plugin indent on
syntax enable
EOF) -c 'Vader! *.vader' > /dev/null
