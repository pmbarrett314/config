#put these in a file on each PC.
export MYROS=false
export MYANDROID=false
export MYSTACK=true
export MYPROMPT=true


export STUFFDIR="$HOME/Code/stuff"

if [ -f $STUFFDIR/program/bash/.bashrc ]; then
    . $STUFFDIR/program/bash/.bashrc
fi

if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi