#!/bin/bash

# makes the symlinks for you

cd ~/
ln -s skel*/_bashrc .bashrc
ln -s skel*/_bash_profile .bash_profile
ln -s skel*/_vimrc .vimrc
ln -s skel*/_vim .vim
ln -s skel*/_screenrc .screenrc
touch ~/.hnfong.conf

