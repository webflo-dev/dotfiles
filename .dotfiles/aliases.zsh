#!/usr/bin/env bash

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias man=cheat

#alias ls='ls -l -h -v --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F --tabsize=0 --literal --show-control-chars --color=always --human-readable'
#alias la='ls -a'

alias grep="grep --color=auto"
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias less="less -R"

alias dud='du -d 1 -h'
alias duf='du -sh *'

#alias fd='find . -type d -name'
#alias ff='find . -type f -name'
alias fd=fdfind

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

alias path='echo -e ${PATH//:/\\n}'

alias auto-update="sudo apt -y update && sudo apt -y full-upgrade && sudo apt -y autoremove"

alias ip-local="ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias ssh-add='eval "$(ssh-agent -s)" && ssh-add'

alias lazydocker='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v /home/florent/docker/lazydocker//config:/.config/jesseduffield/lazydocker lazyteam/lazydocker'

alias dive='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest'


alias dotfiles='git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME'

alias cat='bat'
alias vi=vim
#alias nano=vim

alias ls='exa -la -L 3 --git --group-directories-first --ignore-glob="node_modules|.git"'
alias la=ls

alias keepalive-vdi='xdotool key --window $(xdotool search --name FR09540462W) --delay 300000 --repeat 288 space'
