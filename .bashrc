# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions if ~/.bashrc.d and interactive
#if [[ -d ~/.bashrc.d ]] && [[ $- == *i* ]]; then
if [[ -d ~/.bashrc.d ]] && [ -n "$PS1" ]; then
    for i in ~/.bashrc.d/*.sh; do
        . $i
    done
fi
