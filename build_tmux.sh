#!/bin/bash
set -ex

# This is a script to build and install tmux on macOS without homebrew.
prefix=$HOME/apps/tmux
mkdir -p "$prefix"
cd "$prefix"

# Download and build pkg-config
curl -O -L 'https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz'
tar zxvf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2
CFLAGS="-Wno-int-conversion" ./configure --prefix="$prefix" --with-internal-glib
make -j 10
make install
cd ..

# Download and build ncurses
curl -O -L 'https://invisible-island.net/datafiles/release/ncurses.tar.gz'
tar zxvf ncurses.tar.gz
cd ncurses-6.*  # We don't know which one we're downloading...
./configure --prefix="$prefix"
make -j 10
make install
cd ..

# Download and build libevent
curl -O -L 'https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz'
tar zxvf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure --disable-openssl --prefix="$prefix"
make -j 10
make install
cd ..


# Download and build utf8proc
curl -O -L 'https://github.com/JuliaStrings/utf8proc/releases/download/v2.9.0/utf8proc-2.9.0.tar.gz'
tar zxvf utf8proc-2.9.0.tar.gz
cd utf8proc-2.9.0
make prefix="$prefix"
make install prefix="$prefix"
cd ..

# Download and build tmux
curl -O -L 'https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz'
tar zxvf tmux-3.5a.tar.gz
cd tmux-3.5a
PKG_CONFIG="$prefix"/bin/pkg-config ./configure --enable-utf8proc --prefix="$prefix"
make -j 10
make install
cd ..

ln -sf "$prefix"/bin/tmux ~/bin/tmux
