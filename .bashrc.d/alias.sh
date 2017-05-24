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
alias tack='ack --noignore-dir=tests --noignore-dir=integration_tests'

alias dnfi='sudo dnf install'
alias dnfu='sudo dnf update'
alias dnfs='sudo dnf search'
alias dnfl='sudo dnf list'

alias ppjson='python -mjson.tool'
alias ppxml='python -c "import sys, xml.dom.minidom; print xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml()"'
