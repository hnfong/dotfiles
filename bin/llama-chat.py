#!/bin/bash

if [[ -n "$1" ]]; then
FFFF=$(find ~/Downloads/ -name "*$1*.gguf" | sort | head -n 1)
if [[ -z "$FFFF" ]]; then
    FFFF="$1"
fi
else
FFFF=$(find ~/Downloads/ -name "*gemma-3-27b-it*" | sort | head -n 1)
fi
shift
set -x
exec ~/projects/llama.gguf/llama-cli --no-escape -cnv -mli -c 16000 -m "$FFFF" "$@"
exit 1

