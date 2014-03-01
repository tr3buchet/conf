# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions if ~/.bashrc.d and interactive
#if [[ -d ~/.bashrc.d ]] && [[ $- == *i* ]]; then
if [[ -d ~/.bashrc.d ]] && [ -n "$PS1" ]; then
    for i in ~/.bashrc.d/*.sh; do
        . $i
    done
fi
