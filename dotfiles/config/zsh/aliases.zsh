#!/usr/bin/env zsh

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias grep="grep --color=auto"
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias less="less -R"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias view='bat'
alias cat='bat -p'
alias more='bat -p'

# alias ls='ls -l -h -v --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F --tabsize=0 --literal --show-control-chars --color=always --human-readable'
# alias la='ls -a'
alias ls='exa -la -L 3 --git --group-directories-first --ignore-glob="node_modules|.git" --icons'
alias la=ls
alias l=ls

alias path='echo -e ${PATH//:/\\n}'

alias ssh-add-keys='eval "$(ssh-agent -s)" && ssh-add'


alias logout='loginctl terminate-session self'
alias poweroff='systemctl poweroff'

alias words='rg --pretty --with-filename --hidden --follow -g '!.git''
alias files='fd --type f --hidden --follow --exclude .git'

alias startx='startx $XDG_CONFIG_HOME/X11/xinitrc'
alias startw='hyprland'


alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias du=gdu

alias vi=nvim
alias vim=nvim

# alias keepalive-vdi="xdotool key --window $(comm -12 <(xdotool search --name 'FR09540462W' | sort) <(xdotool search --class 'Wfica' | sort)) --delay 300000 --repeat 288 space"

