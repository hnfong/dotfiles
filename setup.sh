#!/bin/bash

# makes the symlinks for you

cd ~/
if [[ ! -d dotfiles/.git ]]; then
  echo "Put the dotfiles/ directory in your home directory!" >&2
  exit 1
fi
ln -sf dotfiles/_vimrc .vimrc
ln -sf dotfiles/_vim .vim
ln -sf dotfiles/_screenrc .screenrc
ln -sf dotfiles/_zshenv .zshenv
ln -sf dotfiles/_tmux.conf .tmux.conf
ln -sf dotfiles/_alacritty.yml .alacritty.yml
touch ~/.hnfong.conf

mkdir -p ~/bin/
for file in dotfiles/bin/*; do
    if [ -x "$file" ]; then
        ln -sf ../"$file" ~/bin/
    fi
done
ln -sf ../dotfiles/bin/latest-in-dir ~/bin/lid
for file in dotfiles/rusts/bin/*; do
    if [ -x "$file" ]; then
        ln -sf ../"$file" ~/bin/
    fi
done

# Installing software

if [ ! -d /Applications/iTerm.app/ ]; then
    echo "iTerm"
    open https://www.iterm2.com/
fi

if [ ! -d "dotfiles/zsh/.zprezto" ]; then
    pushd ~/dotfiles/zsh
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "./.zprezto"
    popd
fi

## Python stuff
pip3 install --user -U csvkit
pip3 install --user -U ocrmac

## Install rust/cargo
if [ ! -d ~/.cargo ]; then
    # Ask user for confirmation first
    echo "Planning to run command: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo "This will install rust/cargo. Do you want to proceed? (y/n)"
    read -r CONFIRM

    if [ "$CONFIRM" != "y" ]; then
        echo "Aborting installation."
        exit 1
    fi

    set -ex
    set -o pipefail

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Refresh $PATH after installation
    source "$HOME/.cargo/env"

    cargo install ripgrep
    cargo install zoxide
fi

cd ~/dotfiles
bin/qdinstall qdpackages/htop.qdi
