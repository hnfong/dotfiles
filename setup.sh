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
touch ~/.hnfong.conf

mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config

mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/_ghostty_config ~/.config/ghostty/config

pushd "~/Library/Application Support/nushell/"
ln -sf ~/dotfiles/config.nu .
popd

mkdir -p ~/bin/
for zfile in dotfiles/bin/*.bz2; do
    bzcat -k "$zfile" > ~/bin/"$(basename $zfile .bz2)"
    chmod 755 ~/bin/"$(basename $zfile .bz2)"
done
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

if [ ! -d /Applications/Ghostty.app/ ]; then
    echo "Ghostty"
    open 'https://ghostty.org/download'
fi

if [ ! -d "dotfiles/zsh/.zprezto" ]; then
    pushd ~/dotfiles/zsh
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "./.zprezto"
    popd
fi

## Python stuff
## XXX: Keep this list short. For others, just do it in ./adhoc_venv/setup.sh
if ! which uv; then
    pip3 install --user -U uv
    pushd adhoc_venv/
    make setup
    popd
fi

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
    cargo install fd-find
fi

cd ~/dotfiles
if ! which htop; then
    bin/qdinstall qdpackages/htop.qdi
fi

if ! ls ~/apps/node-*; then
    bin/qdinstall qdpackages/node.qdi
fi

NEW_NPM_DIR=`ls -rt ~/apps | grep node- | tail -n 1`
~/apps/"$NEW_NPM_DIR"/bin/npm config set prefix "$HOME/apps/$NEW_NPM_DIR"
~/apps/"$NEW_NPM_DIR"/bin/npm install -g bash-language-server htmx-lsp pyright typescript-language-server
