#!/bin/bash
set -ex

# Save the path to ./download_check script
script_path=$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$0")
download_check_path=$(dirname "$script_path")/download_check

function download_and_check() {
    set -e
    curl -C - -O -L "$1"
    local my_filename=$(basename "$1")
    "$download_check_path" "$my_filename"
}

# This is a script to build and install tmux on macOS without homebrew.
prefix=$HOME/apps/gpg
mkdir -p "$prefix"
cd "$prefix"

# Download and build pkg-config
download_and_check 'https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz'
tar zxvf pkg-config-0.29.2.tar.gz
pushd pkg-config-0.29.2
CFLAGS="-Wno-int-conversion" ./configure --prefix="$prefix" --with-internal-glib
make -j 10
make install
popd ..

# Download and install dependencies

# Need this for pkg-config path, otherwise need to specify the PKG_CONFIG env var.
export PATH="$PATH:$prefix/bin"

for dep_url in \
    "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.55.tar.bz2" \
    "https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.1.tar.bz2" \
    "https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2" \
    "https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2" \
    "https://www.gnupg.org/ftp/gcrypt/npth/npth-1.8.tar.bz2"; do

    download_and_check "$dep_url"
    dep_filename=$(basename "$dep_url")
    dep_dir=$(basename "$dep_filename" ".tar.bz2")

    tar jxvf "$dep_filename"

    [[ -d "$dep_dir" ]]

    pushd "$dep_dir"
    ./configure --prefix="$prefix"
    make -j 10
    make install
    popd
done


download_and_check 'https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.8.tar.bz2'
tar zxvf gnupg-2.4.8.tar.bz2
pushd gnupg-2.4.8
./configure --prefix="$prefix"
make -j 10
make install
popd ..

ln -sf "$prefix"/bin/gpg ~/bin/gpg

echo "**************************************************************************"
echo "Note: You may need to use gpg --pinentry-mode loopback to enter passwords."
echo "**************************************************************************"
