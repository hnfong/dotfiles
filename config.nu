# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

use std/util "path add"
path add "~/.cargo/bin/"
path add "~/bin/"
$env.EDITOR = "magic_open"

alias lg = /bin/ls -GAF
alias fg = job unfreeze

alias rm = rm -iv
alias mv = mv -iv
alias cp = cp -iv
alias vi = magic_open
alias ff = fd --hidden --no-ignore --threads=1 --glob -E venv
alias  g = rg -z -N --no-heading --no-ignore -g "!venv"
alias opn = /usr/bin/open

# Should be at the end of config.nu
# See https://github.com/ajeetdsouza/zoxide
source ~/.zoxide.nu

