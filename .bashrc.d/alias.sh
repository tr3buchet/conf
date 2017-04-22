alias vi='vim'
alias ls='ls -F --color=auto'
alias ll='ls -hl'
alias lla='ls -Ahl'
alias la='ls -A'
alias rgrep='rgrep --color=always -n'
alias lt='tree -Ch --dirsfirst'
alias lta='tree -aCh --dirsfirst'
alias pt='tree -Ch --dirsfirst --charset=ASCII'
alias pta='tree -aCh --dirsfirst --charset=ASCII'
alias diff='diff -y --suppress-common-lines'
alias ps='ps -e f'
alias less='less -R'
alias ta='tmux attach'

alias dnfi='sudo dnf install'
alias dnfu='sudo dnf update'
alias dnfs='sudo dnf search'
alias dnfl='sudo dnf list'

alias ppjson='python -mjson.tool'
alias ppxml='python -c "import sys, xml.dom.minidom; print xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml()"'

alias cdru='cd ~/git/rsdn/unicorn/unicorn'
alias cdrb='cd ~/git/rsdn/bison/bison'
alias cdrc='cd ~/git/rsdn/rsdn_common/rsdn_common'
alias cdrt='cd ~/git/rsdn/tatonka/tatonka'
alias cdryu='cd ~/git/ryu/ryu'


function do_git {
  cmd=$1
  shift
  extra=""
  case "$cmd" in
    log)
      extra="--graph"
      ;;
    clean)
      extra="-dxi"
      ;;
  esac

  # both $@ and $extra are defined
  if [ ! -z "$@" ] && [ ! -z "$extra" ]; then
    "/usr/bin/git" "$cmd" "$@" "$extra"

  # $@ is defined, but $extra is not
  elif [[ ! -z "$@" ]]; then
    "/usr/bin/git" "$cmd" "$@"

  # $extra is defined but $@ is not
  elif [[ ! -z "$extra" ]]; then
    "/usr/bin/git" "$cmd" "$extra"

  # both $@ and $extra are empty
  else
    "/usr/bin/git" "$cmd"
  fi
}

alias git='do_git'
