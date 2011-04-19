# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to history after each command
export PROMPT_COMMAND='history -a'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


export PATH=$PATH:.:~/bin
#export CDPATH=:$HOME/nova

if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi

parse_git_branch() {
  if git rev-parse --git-dir >/dev/null 2>&1
  then
          gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  else
          return 0
  fi
  echo -e "($gitver)"
}
git_branch_color() {
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    color=""
    if git status 2>/dev/null | grep "# On branch" -qs
    then
      if git status | grep "(working directory clean)" -qs
      then
        color=$txtylw
      else
        color=$undylw
      fi
    else
      color=$txtylw
    fi
  else
    return 0
  fi
  echo -ne $color
}

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

git_prompt=no
# set title and prompt
if [ "$color_prompt" = yes ]; then
    if [ "$git_prompt" = yes ]; then
        PS1="\[\033]0;(\u|\h)\w>\007\]\[$bldgrn\](\u|\h)\[$txtred\]\w\[\$(git_branch_color)\]\$(parse_git_branch)\[$txtrst\]\[$bldgrn\]>\[$txtrst\] "
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1="\[\033]0;(\u|\h)\w>\007\]\[$bldgrn\](\u|\h)\[$txtred\]\w\[$txtrst\]\[$bldgrn\]>\[$txtrst\] "
    fi
else
    PS1="\[\033]0;(\u|\h)\w>\007\](\u|\h)\w> "
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# some more aliases
alias lls='ls -hlF'
alias lla='ls -AhlF'
alias la='ls -AF'
alias rgrep='rgrep --color=always -n'
alias lt='tree -Ch --dirsfirst'
alias lta='tree -aCh --dirsfirst'
alias diff='diff -y --suppress-common-lines'
alias ps='ps -eo pid,user,cmd'
alias ack='ack-grep --color --color-match=red --group'
alias less='less -R'
#alias vpnc='sudo vpnc --local-port 0'
#alias sudo='sudo env PATH=$PATH'
#alias touch='ttouch'


#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

