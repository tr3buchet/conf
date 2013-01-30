# -------- history settings -----------
# store history here
HISTFILE=~/.zhistory

# size of the history file that is read by shell
HISTSIZE=20000

# recent number of lines shell will write to history on exit
SAVEHIST=20000

# append to history file immediately after each command is run
setopt INC_APPEND_HISTORY

# running the same command consecutive times results in 1 history line
setopt HIST_IGNORE_DUPS

# adds date and time_to_run to history
setopt EXTENDED_HISTORY

# causes all shells to share history,
# hitting up will pull most recent command regardless of shell
# this is kindof finicky though, have to hit enter first then up
#setopt SHARE_HISTORY
# -------- end history settings -----------

setopt beep extendedglob nomatch notify
bindkey -e

# prevents clobbering a file with >
# use >! to do it anyway
setopt noclobber

# let files beginning with a . be matched with explicitly specifying .
# ex: "ls *git*" matches .git where it wouldn't before
setopt globdots

# turns on correction prompt for commands
setopt correct

# turns on correction prompt for arguments to commands
setopt correctall

# source completion
. /home/trey/.zshrc_compinit
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/trey/.zsh/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall


# -------- path settings ------------------
export PATH=$PATH:.:~/bin

# ensure no duplicates in path
typeset -U PATH

# set CDPATH to allow for cd (ex: some dir in git) from anywhere
export CDPATH=.:~:~/git

# ensure no duplicates in cdpath
typeset -U CDPATH
# -------- end path settings --------------


# -------- title settings ----------------------
case $TERM in
    xterm|screen)
        precmd () {print -Pn "\e]0;[%n|%m %~]%#\a"}
        ;;
esac
# -------- end title settings ------------------


# -------- directory settings ------------------
# sets the max number of directories to remember
DIRSTACKSIZE=8

# cd auto pushes directories into stack as you move around
setopt autopushd

# uses a - to work down the stack instead of +
setopt pushdminus

# prevent pushd (or cd) from outputting each directory change
setopt pushdsilent

# don't add duplicate directories to stack
setopt pushdignoredups

# pushd (or cd) returns to home directory with no args
setopt pushdtohome

alias dh='dirs -v'
# -------- end directory settings --------------


# -------- prompt settings ---------------------
autoload -U colors && colors

# returns success if git is installed
function git_installed {
    which git 1>/dev/null 2>/dev/null
}

# return success if vpnc is installed
function vpnc_installed {
    which vpnc 1>/dev/null 2>/dev/null
}

# returns success if in a git branch
function on_git_branch {
    git rev-parse --git-dir >/dev/null 2>&1
}

# returns the neame of the current git branch
function parse_git_branch {
    echo $(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
}

# returns success if the current git directory is clean
function git_branch_clean {
    if git status 2>/dev/null | grep "# On branch" -qs; then
        if git status | grep "(working directory clean)" -qs; then
            return 0
        else
            return 1
        fi
    fi
}

# packages the git branch with color for use in prompt
function git_prompt {
    if on_git_branch; then
        echo "%{$fg[yellow]%}($(parse_git_branch))"
    fi
}

# creates an rprompt out of a colored circle
# green is clean working directory
# red is dirty working directory
function git_rprompt {
    if on_git_branch; then
        if git_branch_clean; then
            echo "%{$fg_bold[green]%}●%{$reset_color%}"
        else
            echo "%{$fg[red]%}●%{$reset_color%}"
        fi
    fi
}

# creates a prompt for vpnc
# a green VPN means it's installed
function vpnc_rprompt {
    if vpnc_installed; then
      lines=`sudo route -n | wc -l`
      if [ $lines -gt 4 ]; then
          echo "%{$fg_bold[green]%}VPN%{$reset_color%}"
      fi
    fi
}


setopt promptsubst
if git_installed; then
    PROMPT='%{$fg_bold[green]%}[%n|%m %{$reset_color%}%{$fg[red]%}%~$(git_prompt)%{$fg_bold[green]%}]%#%{$reset_color%} '
    RPROMPT='$(git_rprompt) $(vpnc_rprompt)'
else
    PROMPT='[%{$fg_bold[green]%}%n|%m %{$reset_color%}%{$fg[red]%}%~%{$fg_bold[green]%}]%#%{$reset_color%} '
    RPROMPT='$(vpnc_rprompt)'

fi
# -------- end prompt settings -----------------


# enable color support of ls and grep
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
alias pt='tree -Ch --dirsfirst --charset=ASCII'
alias pta='tree -aCh --dirsfirst --charset=ASCII'
alias diff='diff -y --suppress-common-lines'
alias ps='ps -eo pid,user,cmd'
alias ack='ack-grep --color --color-match=red --group --sort-files'
alias less='less -R'
alias vpnc='sudo vpnc --local-port 0'
alias vpncd='sudo vpnc-disconnect'
alias il='inova-login'
alias sn='supernova'
alias history='history -Di'
alias ta='tmux attach'

alias apti='sudo aptitude install'
alias aptu='sudo aptitude update'
alias aptuu='sudo aptitude update && sudo aptitude safe-upgrade'
alias apts='sudo aptitude search'
alias aptr='sudo aptitude remove'
alias aptc='sudo aptitude clean'

alias ppjson='python -mjson.tool'
alias ppxml='python -c "import sys, xml.dom.minidom; print xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml()"'
alias vv='virtualenv .venv'
alias va='. .venv/bin/activate'
alias vd='deactivate'
