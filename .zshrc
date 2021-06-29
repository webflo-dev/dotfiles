export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="spaceship"

ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	direnv
	fzf
	h
	k
	dnote
	git
	docker
	docker-compose
	npm
	pip
	yarn
	pass
	nvm
)



ZSH_AUTOSUGGEST_USE_ASYNC="true"

SPACESHIP_DOCKER_SHOW=false
SPACESHIP_TIME_SHOW=true
SPACESHIP_DIR_TRUNC_REPO=true

# User configuration
path=($HOME/.local/bin $HOME/bin /snap/bin /usr/local/go/bin $HOME/go/bin $path)
fpath=($HOME/.zsh/completions $fpath)


for file in $HOME/.dotfiles/{exports,functions}.{zsh,sh}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

source $ZSH/oh-my-zsh.sh

for file in $HOME/.dotfiles/{options,aliases}.{zsh,sh}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
  unset file
done

if [[ -d $HOME/.zsh ]]; then
  for file in $HOME/.zsh/*.{zsh,sh}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
    unset file
  done
fi

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

source /home/florent/.config/broot/launcher/bash/br
