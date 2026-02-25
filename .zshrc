export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git extract sudo)

source $ZSH/oh-my-zsh.sh

# --- Aliases ---
alias grep='grep --color=auto'

alias ls='eza -lh --git --icons --time-style=long-iso -a'
alias mkdir='mkdir -p'
alias cmatrix='cmatrix -C cyan'

alias sv='sudo -E nvim'
alias nv='nvim'

alias chypr='nvim ~/.config/hypr/'
alias upddot='sync.sh; cd ~/Documents/dotfiles; git add .'

# --- Keybindings ---
bindkey -s '^f' 'fastfetch^M'

# --- Path & Environment ---
export PATH="$PATH:$HOME/.local/bin"
export EDITOR='nvim'

# --- Prompt & Startup ---
fastfetch
