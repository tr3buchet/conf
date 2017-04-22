#!/bin/bash
# ------------------- misc settings ------------------------------------ #
# If not running interactively, don't do anything
# unnecessary since .bashrc only sources if interactive
#[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# if not included in /etc/bashrc
#shopt -s checkwinsize
export EDITOR=vim
# ------------------- end misc settings -------------------------------- #



# ------------------- history settings --------------------------------- #
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000

# append to history after each command
# if not included in /etc/bashrc
# history -a

# append to the history file, don't overwrite it
# if not included in /etc/bashrc
shopt -s histappend
# ------------------- end history settings ----------------------------- #



# ------------------- virtualenv settings ------------------------------ #
if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    source ~/.local/bin/virtualenvwrapper.sh
fi
# ------------------- end virtualenv settings -------------------------- #


# ------------------- heroku tools if installed ------------------------ #
if [ -d "$HOME/.heroku-client/bin" ] ; then
    PATH=$PATH:$HOME/.heroku-client/bin
fi
# ------------------- end heroku tools if installed -------------------- #



# ------------------- path settings ------------------------------------ #
export PATH=$PATH:.:~/bin
#if [ -n "$PS1" ]; then
#    # $PS1 is not null so this is interactive shell
#    # do not export because we don't want CDPATH set in subprocesses
#    CDPATH=.:~:~/git
#fi

# ------------------- end path settings -------------------------------- #



# ------------------- TERM settings ------------------------------------ #
#case $TERM in
#    screen)
#        export TERM=screen-256color
#        ;;
#esac
# ------------------- end TERM settings -------------------------------- #



# ------------------- prompt settings ---------------------------------- #
# returns the name of the current git branch
parse_git_branch() {
    echo $(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
}
# check for git status
git_prompt() {
    status=`git status -s 2>&1`
    if [ $? -eq 0 ]; then
        if [ -z "$status" ]; then
            # clean branch
            echo "\[$Yellow\]($(parse_git_branch))"
        else
            # dirty branch
            # echo "\[$Yellow\](\[$UYellow\]$(parse_git_branch)\[$Yellow\])"
            echo "\[$Yellow\]($(parse_git_branch)\[$Red\]++\[$Yellow\])"
        fi
    else
        # not a branch or no git installed
        echo ""
    fi
}

virtual_env_prompt() {
    if [ -z "$VIRTUAL_ENV" ]; then
        # no virtual env enabled
        echo ""
    else
        # virtual env enabled
        echo "(${VIRTUAL_ENV##*/})"
    fi
}

force_color_prompt=yes
if [ "$force_color_prompt" = yes ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

get_prompt() {
    history -a
    PS1="\[\033]0;[\u|\h \w]\007\]$(virtual_env_prompt)\[$BGreen\][\u|\h \[$Red\]\w$(git_prompt)\[$BGreen\]]%\[$Color_Off\] "
    # NOTE add term title with something like this "\[\033]0;[\u|\h \w]\007\]"
}
#PROMPT_COMMAND="get_prompt;$PROMPT_COMMAND"
PROMPT_COMMAND=get_prompt

unset color_prompt force_color_prompt
# ------------------- end prompt settings ------------------------------ #
