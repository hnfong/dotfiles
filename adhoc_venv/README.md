# adhoc venv

Container for ad-hoc virtualenvs (which hopefully don't conflict and lets me avoid setting up too many venvs)

# Contains

- llm (Simon Willison’s)
- mflux-generate
- ocrmac
- huggingface-cli `huggingface_hub[cli]`
- ruff

# Reminder notes:

Example invocation for mflux-generate:

`for ((i=0;i<4;i++)); do mflux-generate --model schnell --width 640 --height 480 --prompt "Young Elon Musk happily building the great wall (of China) together as a sandcastle on a beach. Cartoon style. castle stretch long"; done`


- mflux needs python 3.10+

https://stackoverflow.com/questions/76712720/typeerror-unsupported-operand-types-for-type-and-nonetype
