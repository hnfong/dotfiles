#!/bin/bash

# makes the symlinks for you

cd ~/
if [[ ! -d skel/.git ]]; then
  echo "Put the skel/ directory in your home directory!" >&2
  exit 1
fi
ln -s skel/_bashrc .bashrc
ln -s skel/_bash_profile .bash_profile
ln -s skel/_vimrc .vimrc
ln -s skel/_vim .vim
ln -s skel/_screenrc .screenrc
ln -s skel/_zshenv .zshenv
touch ~/.hnfong.conf

mkdir -p ~/bin/
ln -s ../skel/bin/charcount ~/bin/
