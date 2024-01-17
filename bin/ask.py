#!/usr/bin/env python3

# Ask an AI a question

# Use llama.cpp

import getopt
import glob
import os
import random
import re
import subprocess
import sys
import time

LLAMA_CPP_PATH = os.path.expanduser("~/projects/llama.gguf/")
MODELS_PATH = os.path.expanduser("~/Downloads/")

# Presets

class Preset:
    def __init__(self, name, user_prompt):
        self.name = name
        self.user_prompt = user_prompt

    def prompt(self):
        raise NotImplementedError("Please implement this method in a subclass")

    def system_message(self):
        return "You are a helpful assistant. You will answer questions in a helpful and concise manner."

    def templated_prompt(self):
        # Implemented by mixins if needed
        return self.prompt()

class ExplainPreset(Preset):
    def __init__(self, user_prompt, context):
        super().__init__("what_is", user_prompt)
        self.context = context

    def prompt(self):
        if self.context:
            return f"In the context of " + self.context + ", please explain the following. Be concise in your answer.\n```{self.user_prompt}```\n"
        else:
            return f"Please explain the following. Be concise in your answer.\n```{self.user_prompt}```\n"


class ChatMLTemplateMixin:
    def templated_prompt(self):
        return f"""
<|im_start|>system
{self.system_message()}<|im_end|>
<|im_start|>user
{self.prompt()}<|im_end|>
<|im_start|>assistant
        """.strip() + "\n"

class InstructionTemplateMixin:
    def templated_prompt(self):
        return f"""

### Instruction:

{self.prompt()}

### Response:

"""


class LlamaTemplateMixin:
    def templated_prompt(self):
        return f"""<s>[INST] <<SYS>>\n{self.system_message()}\n<</SYS>>\n\n{self.prompt()} [/INST]"""

if __name__ == "__main__":
    opt_list, args = getopt.getopt(sys.argv[1:], "hc:t:f:")
    opts = dict(opt_list)

    user_prompt = None
    if args:
        user_prompt = args[0]
    elif opts.get("-f"):
        user_prompt = open(opts.get("-f")).read()
    else:
        user_prompt = input("What is your question?\n")

    template = opts.get("-t") or "chatml"
    context = opts.get("-c") or ""
    model_name = opts.get("-m") or "dolphin-2_6-phi-2"
    cmd_args = []
    is_mac = "Darwin" in subprocess.run(["uname"], capture_output=True).stdout.decode("utf-8").strip()
    if opts.get("-g") or is_mac:
        cmd_args.append("-ngl")
        cmd_args.append("99")

    templateMixIn = None
    if template == "chatml":
        templateMixIn = ChatMLTemplateMixin
    elif template == "llama":
        templateMixIn = LlamaTemplateMixin
    else:
        templateMixIn = InstructionTemplateMixin

    class CurrentPrompt(templateMixIn, ExplainPreset):
        pass

    prompt = CurrentPrompt(user_prompt, context).templated_prompt()

    cmd = [f"{LLAMA_CPP_PATH}/patched_main"] + cmd_args + ["-m", glob.glob(f"{MODELS_PATH}/*{model_name}*.gguf")[0], "-p", prompt]

    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    while dat := p.stdout.read(1):
        sys.stdout.buffer.write(dat)
        sys.stdout.flush()

    outs = p.communicate()

    # Check exit code
    if p.returncode != 0:
        print("Error: " + outs[1].decode("utf-8"))
        sys.exit(1)
    else:
        outs_s = outs[0].decode("utf-8")
        if outs_s.startswith(prompt):
            outs_s = outs_s[len(prompt):]
            # This doesn't work at least in some models because <|im_end|>
            # seems to be tokenized and stringified back to an empty string.
            # Instead I just modified the llama.cpp code to just output the
            # results.

        print(outs_s)
