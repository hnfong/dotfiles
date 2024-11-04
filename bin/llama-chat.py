#!/bin/bash

FFFF=$(find ~/Downloads/ -name "*$1*" | head -n 1)
shift
set -x
exec ~/projects/llama.gguf/llama-cli --log-disable -cnv -mli -c 4096 -m "$FFFF" "$@"
exit 1

#!/usr/bin/env python3

"""
A simple wrapper to pass the correct template strings for llama-cli

"""
import os
import getopt
import glob
# import subprocess

COMMON_ARGS = "--log-disable -c 4096 --conversation -mli".split()
MODEL_DIR = os.path.expanduser("~/Downloads")
LLAMA_CPP_CLI = os.path.expanduser("~/projects/llama.gguf/llama-cli")

# Prefix and suffix for each model
MODEL_XFIXES = {
    "gemma-2-":
        (None,
        '<start_of_turn>user\n',
        '<end_of_turn>\n<start_of_turn>model\n'),
    "Meta-Llama-3-":
        ('<|begin_of_text|>',
        '<|start_header_id|>user<|end_header_id|>\n',
        '<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n'),
    "phi3":
        (None,
        '<|user|>\n',
        '<|end|><|assistant|>\n'),
    "glm-4-":
        ("[gMASK]<sop>",
        "<|user|>\n",
        "<|assistant|>\n"),
    None: # Fallback to chatml
        (None,
        '<|im_start|>user\n',
        '<|im_end|><|im_start|>assistant\n')
}

def get_model_args(model_path):
    """
    Get the correct template strings for the given model
    """
    model_name = os.path.basename(model_path)
    for substring in MODEL_XFIXES:
        if substring is not None and substring in model_name:
            xfixes = MODEL_XFIXES[substring]
            break
    else:
        xfixes = MODEL_XFIXES[None]

    args = []
    if xfixes[0] is not None:
        args.append("-p")
        args.append(xfixes[0])
    args.append("--in-prefix")
    args.append(xfixes[1])
    args.append("--in-suffix")
    args.append(xfixes[2])
    args.append("-r") # Reverse prompt
    args.append(xfixes[1].strip())

    return args + COMMON_ARGS

def main():
    opt_list, args = getopt.getopt(os.sys.argv[1:], "m:h",)
    opts = dict(opt_list)
    if "-h" in opts:
        print(f"Usage: {os.sys.argv[0]} [-m model] prompt")
        os.sys.exit(0)

    model = opts.get("-m")
    if model is None:
        print("No model specified")
        os.sys.exit(1)

    # Try to find the models in ~/Downloads or MODEL_DIR
    globbed = glob.glob(MODEL_DIR + f"/*{model}*.gguf")
    if not globbed:
        print(f"Model {model} not found")
        os.sys.exit(1)
    model_path = next(iter(globbed))
    cmd = ["llama-cli", "-m", model_path] + get_model_args(model_path)
    print(cmd)

    # We should just exec instead of subprocess here
    executable_path = LLAMA_CPP_CLI

    # Before we exec, we should mute stderr.
    # with open(os.devnull, "w") as devnull:
        # os.dup2(devnull.fileno(), 2)

    os.execv(executable_path, cmd)


if __name__ == "__main__":
    main()
