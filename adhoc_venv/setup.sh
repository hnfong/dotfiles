#!/bin/bash

if [[ ! -d .venv ]]; then
    echo "run 'make setup' first"
    exit 1
fi

function realpath() {
    # implement with python
    python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$1"
}

set -x
my_real_path=$(realpath "$(dirname "$0")")
cd ~/bin
ln -svf "$my_real_path"/bin/* .
