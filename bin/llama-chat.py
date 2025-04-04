#!/bin/bash

if [[ -n "$1" ]]; then
FFFF=$(find ~/Downloads/ -name "*$1*.gguf" | head -n 1)
else
FFFF=$(find ~/Downloads/ -name "*gemma-3-27b-it*" | head -n 1)
fi
shift
set -x
exec ~/projects/llama.gguf/llama-cli --no-escape -cnv -mli -c 16000 -m "$FFFF" "$@"
exit 1

