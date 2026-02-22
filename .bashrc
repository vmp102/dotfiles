#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias grep='grep --color=auto'
alias ls='eza -lh --git --icons --time-style=long-iso -a'
alias mkdir='mkdir -p'
alias sv='sudo -E nvim'
alias nv='nvim'

bind '"\C-f": "fastfetch\n"'

PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
fastfetch

# Created by `pipx` on 2026-02-12 20:14:12
export PATH="$PATH:$HOME/.local/bin"
