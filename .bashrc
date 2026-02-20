#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias grep='grep --color=auto'
alias ls='eza --icons --group-directories-first -a'
alias ll='eza -lh --git --icons --time-style=long-iso -a'
alias cl='clear && fastfetch'
alias mkdir='mkdir -p'
alias nv='nvim'
alias sv='sudo -E nvim'

PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
# fastfetch

# Created by `pipx` on 2026-02-12 20:14:12
export PATH="$PATH:$HOME/.local/bin"
