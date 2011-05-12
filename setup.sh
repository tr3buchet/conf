#!/bin/bash

function update {
  if [ -d "$1" ]; then
    # what we are updating is a directory
    # cp directory over from repo, overwriting any existing files
    # old leftover files may need to be cleaned up
    cp -r "$1" ~
  elif [ -f "$1" ]; then
    # not a directory, cp file over overwriting if necessary
    cp "$1" ~
  else
    # not a file or a directory: problem
    exit
  fi
}

# check for update otherwise install
if [ $1 == "update" ]; then
  for ARG in "$@"; do
    echo $ARG
    if [ "$ARG" != "update" ]; then
      update "$ARG"
    fi
  done
elif [ $1 == "install" ]; then
  # install! this will overwrite, any existing files
  # .bash_colors
    cp .bash_colors ~/.bash_colors
  # .bashrc
    cp .bashrc ~/.bashrc
  # .screenrc
    cp .screenrc ~/.screenrc
  # .vimrc
    cp .vimrc ~/.vimrc
  # .vim
    cp -r .vim ~/.vim
  # .ctags
    mkdir ~/.ctags
fi
