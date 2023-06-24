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
ln -s skel/_tmux.conf .tmux.conf
ln -s skel/_alacritty.yml .alacritty.yml
touch ~/.hnfong.conf

mkdir -p ~/bin/
for file in skel/bin/*; do
    if [ -x "$file" ]; then
        ln -s ../"$file" ~/bin/
    fi
done

# Installing software

if [ ! -d /Applications/iTerm.app/ ]; then
    echo "iTerm"
    open https://www.iterm2.com/
fi

if [ ! -d "skel/zsh/.zprezto" ]; then
    pushd ~/skel/zsh
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "./.zprezto"
    popd
fi
