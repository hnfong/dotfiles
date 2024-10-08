#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if [[ -z "$PS1" ]]; then
    return 0
fi

# Customize to your needs...
#
setopt CHECK_JOBS

# XXX(sidney_fong): This one is weird. Setting this causes AUTO_CD to trigger
# on invalid commands, and eventually the wrong command, let's call it
# "foobar", becomes "cd ~foobar". This isn't a problem unless your machine is
# configured with ldap or similar directory services, where it takes precious
# time to look up all the possible users on the network.
unsetopt CDABLE_VARS

# enable color support of ls and also add handy aliases
if [[ "$OSTYPE" =~ "linux" ]]; then
    eval `dircolors`
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
else
    alias ls='ls -GAF'
fi

alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias vi='magic_open'
alias ff='find . -name'
alias vigl='VIGLTMP="`mktemp /tmp/vigl-XXXXX`.gitlog"; git log -n 100 > "$VIGLTMP" && vi "$VIGLTMP"'
alias vigll='VIGLTMP="`mktemp /tmp/vigl-XXXXX`.gitlog"; git lll -n 100 > "$VIGLTMP" && vi "$VIGLTMP"'
alias h='helper'
alias gpr='git pull --rebase'
alias sw='swift'
alias brew='HOMEBREW_NO_AUTO_UPDATE=1 brew'
alias g='rg -z -N --no-heading --no-ignore -g "!venv"'

# Inspired by https://github.com/Debian/wcurl/blob/main/wcurl https://samueloph.dev/blog/announcing-wcurl-a-curl-wrapper-to-download-files/
alias wcurl='curl --progress-bar -L --remote-name-all --retry 3 --retry-max-time 10'

HISTSIZE=999999
HISTORY_IGNORE='(ls|exit|ps auxf)'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

export PATH="$HOME/bin:$HOME/Library/Python/3.9/bin:$PATH:/opt/homebrew/bin"

if [[ "$TERM" = "screen" ]]; then
    export TERM=xterm-256color
    export IS_RUNNING_SCREEN=1
else
    export TERM=$TERM
    export IS_RUNNING_SCREEN=
fi

# Rust initialization
source "$HOME/.cargo/env"


# Show something when Ctrl+C is pressed (mainly to avoid confusion by
# spectators, since I use this key often and they'd think I pressed enter
trap 'echo -n \(Ctrl+C\); return 1' SIGINT

# Bind F1 to show recent commands (see fc built-in)
bindkey -s '^[OP' 'fc -d -l -50^M'

function j {
    if [ -z "$1" ]; then
        cd `cat /tmp/last_go`
    elif [ -d "$1" ]; then
        if [ "${1:0:1}" = "/" ]; then
            cd "$1"
        elif [ "$PWD"/"$1" ]; then
            cd "$PWD"/$1
        else
            cd "$1"
        fi
    else
        cd "`expandgo $1`"
    fi
}

function gg {
    if [ -z "$1" ]; then
        cd "`cat /tmp/last_go`"
    elif [ -d "$1" ]; then
        if [ "${1:0:1}" = "/" ]; then
            echo "$1" > /tmp/last_go
        elif [ "$PWD"/"$1" ]; then
            echo "$PWD"/"$1" > /tmp/last_go
        else
            echo "$1" > /tmp/last_go
        fi
        gg
    else
        echo `expandgo "$1"` > /tmp/last_go
        gg
    fi
}

function mk {
    # This function invokes make in the current directory or in the nearest
    # ancestor directory that contains a Makefile. This is useful when you're
    # in a subdirectory of a project and you want to run make.
    local PWDBEFOREMK="`pwd`"
    local MK__RET=1
    while [[ "$PWD" != "/" ]]; do
        echo "Trying make in $PWD ..."
        if [[ -f Makefile ]]; then
            make "$@"
            MK__RET="$?"
            if [[ "$MK__RET" = "0" ]]; then
                true # noop
            fi
            break
        fi
        if [[ -f gradlew ]]; then
            ./gradlew "$@"
            break
        fi
        cd ..
    done
    cd "$PWDBEFOREMK"
    [ "$MK__RET"  = "0" ];
}

local _last_git_branch=

function _compute_git_branch() {
    # Originally this was done using "cd", but somehow MacOS's Terminal
    # didn't like it and printed a bunch of weird messages that look like
    # the terminal was going to exit...
    local _pwd=$PWD
    while [[ ! -f "$_pwd/".git/HEAD && "$_pwd" != "/" ]]; do
        _pwd=${_pwd:h}

        # Failsafe
        if [[ $_pwd = "" ]]; then
            _pwd=/
        fi
    done

    _last_git_branch=
    if [[ "$_pwd" != "/" ]]; then
        local mybranch=$(< "$_pwd"/.git/HEAD)
        if [[ "$mybranch" =~ "heads/" ]]; then
            _last_git_branch='['"${mybranch//*heads\//}"']'
        else
            _last_git_branch='[(unknown)]'
        fi
    fi
}

function precmd() {
    # This should go ASAP in precmd() to capture the time properly
    if [[ -n "$_TIME_BEFORE_COMMAND" ]]; then
        local _TIME_AFTER_COMMAND="`date +%s`"
        if [[ $(($_TIME_AFTER_COMMAND - $_TIME_BEFORE_COMMAND)) -gt 120 ]]; then
            lastcmd=`history | tail -n 1 | awk '{print $2}'`
            if [[ "$lastcmd" != "screen" && "$lastcmd" != "vi" && "$lastcmd" != "vim" ]]; then
                beep_in_background "$lastcmd"
            fi
        fi
    fi
    unset _TIME_BEFORE_COMMAND

    _compute_git_branch  # saves it to _last_git_branch for speed
    if [ "$IS_RUNNING_SCREEN" ]; then
        printf "\ek$(print -rD $PWD)$_last_git_branch\e\\"
    fi
}

function preexec() {
    # echo "I will notify you when this finishes, if it takes a long time"
    _TIME_BEFORE_COMMAND="`date +%s`"

    if [ "$IS_RUNNING_SCREEN" ]; then
        printf "\ek%s $(print -rD $PWD)$_git_branch_guess\e\\" "$1"
    fi
}

# set prompt
function _hnfong_set_ps1() {
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
    local T_USERNAME='%n'
    local T_HOST='%m';  T_HOST="%F{red}$T_HOST%f"
    local T_PROMPT='%#'; T_PROMPT="%F{blue}$T_PROMPT%f"
    local T_CWD='%~'; T_CWD="%F{green}$T_CWD%f"
    local T_LVL='%L';  T_LVL="%F{blue}$T_LVL%f"

    local T_GIT='%b%F{green}$_last_git_branch%f%B'

    if [ "$SI_CONFIG_FANCY_PROMPT" = "1" ] && [ "$TERM" != "dumb" ]; then
        setopt PROMPT_SUBST
        PROMPT="%B$T_LVL%F{yellow}.%f$T_HOST%F{black}:$f$T_CWD$T_GIT${T_PROMPT}%b "
    else
        PROMPT="%# "
    fi

    # Make things very red for root user
    if [[ "$USER" = "root" || "`whoami`" = "root" ]]; then
        PROMPT=${PROMPT//blue/red}
        PROMPT=${PROMPT//green/red}
        PROMPT=${PROMPT//yellow/red}
    fi
}

SI_CONFIG_FANCY_PROMPT=1
_hnfong_set_ps1

# Disable git completion (slow)
compdef -d git

eval "$(zoxide init zsh)"

