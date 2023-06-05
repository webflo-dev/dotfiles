#--- XDG ----------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"
#------------------------------------------------------------------------------


#--- APP HOME -----------------------------------------------------------------
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

export VOLTA_HOME="$XDG_DATA_HOME/volta"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export INTELLI_HOME="$XDG_DATA_HOME/intelli-shell"

# export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export DOCKER_CONFIG=
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
export DOCKER_BUILDKIT=0
#------------------------------------------------------------------------------


#--- EXPORT -------------------------------------------------------------------
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_COLLATE="C"
export TZ="Europe/Paris"

# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER='nvim +Man!'
export PAGER='bat -p'
export LESS='-g -i -M -R -S -w -z-4'

export TERMINAL="kitty"
export BROWSER="microsoft-edge-stable"
export VISUAL="nvim"
export EDITOR="nvim"

export GPG_TTY=$(tty)

#--- LESS -------------------------------------------------------------------
#  -F    Exit if the content fits on one screen
#  -g    Highlights just the current match of any searched string.
#  -i    Case-insensitive searches.
#  -M    Shows more detailed prompt, including file position.
#  -N    Shows line numbers (useful for source code viewing).
#  -R / --RAW-CONTROL-CHARS
#  -S    Disables line wrap ("chop long lines"). Long
#        lines can be seen by side scrolling.
#  -X    Leave file contents on screen when less exits.
#  -?    Shows help.
#  +F    Follow mode for log.
#  -w / --hilite-unread
#        Temporarily highlights the first "new" line
#        after a forward movement of a full page.
#  -z-4  Move page not on the full high of the screen
#        but on high minus 4 lines

# export LESS='-F -i -M -R -S -w -z-3'
# export LESS='-F -i -M -R -S -z-3'
export LESS='-i -M -R -S -z-4'
export LESSHISTFILE=/dev/null
export LESS_TERMCAP_md=$'\e[01;97m'     # Begins bold.
export LESS_TERMCAP_so=$'\e[00;47;30m'  # Begins standout-mode.
export LESS_TERMCAP_us=$'\e[04;97m'     # Begins underline.
export LESS_TERMCAP_me=$'\e[0m'         # Ends mode.
export LESS_TERMCAP_se=$'\e[0m'         # Ends standout-mode.
export LESS_TERMCAP_ue=$'\e[0m'         # Ends underline.


# WORDCHARS (non-alphanumeric chars treated as part of a word)
# You can also tweak this if you'd prefer ^w to break on dot, underscore, etc.
export WORDCHARS='*?[]~=&;!#$%^(){}<>'


export HISTSIZE=5000
export SAVEHIST=5000
export HISTORY_IGNORE="(cd|ranger|r|exit|:q|kill|nvim)"

export DOTDROP_CONFIG=$HOME/.dotfiles/config.yaml

