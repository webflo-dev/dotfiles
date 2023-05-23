#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
#  Paths
#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath path

# Set the list of directories that Zsh searches for programs.
path+=(
  $HOME/.local/bin
  $CARGO_HOME/bin
  $VOLTA_HOME/bin
  $GOPATH/bin
)



# Set the list of directories that cd searches.
cdpath+=(
#  $XDG_CONFIG_HOME
)


[ ! -e "$HISTFILE" ] && mkdir -p $(dirname $HISTFILE)

#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
#  Options
#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
unsetopt  beep
setopt    extended_glob
# directories
setopt    auto_cd
setopt    auto_pushd
setopt    pushd_ignore_dups
setopt    pushd_minus
# completion
unsetopt  menu_complete   # do not autoselect the first completion entry
unsetopt  flowcontrol
setopt    auto_menu         # show completion menu on successive tab press
setopt    complete_in_word
setopt    always_to_end
setopt    hash_list_all      # Whenever a command completion is attempted,
setopt    complete_aliases
setopt    list_types
setopt    list_packed
setopt    auto_list
setopt    auto_param_slash
setopt    glob_complete
setopt    glob_dots
setopt    correct_all        # Correct the spelling of all arguments in a line.
#history
setopt    bang_hist
setopt    extended_history       # record timestamp of command in HISTFILE
setopt    hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt    hist_ignore_dups       # ignore duplicated commands history list
setopt    hist_ignore_space      # ignore commands that start with space
setopt    inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt    hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt    hist_save_no_dups      # Don't write duplicate entries in the history file.
setopt    hist_find_no_dups      # Do not display a line previously found.
setopt    hist_reduce_blanks     # Remove superfluous blanks before recording entry.
setopt    hist_verify            # Don't execute immediately upon history expansion.
setopt    share_history          # share command history data
# misc
setopt    multios              # enable redirect to multiple streams: echo >file1 >file2
setopt    long_list_jobs       # show long list format job notifications
setopt    interactivecomments  # recognize comments
#setopt rc_quotes          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.


autoload -U compaudit compinit zrecompile
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
zmodload -i zsh/complist


# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic



source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/key-bindings.zsh"
source "$ZDOTDIR/aliases.zsh"
[ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"
[ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"

eval "$(starship init zsh)"


[[ -e $ZDOTDIR/private.zsh ]] && source $ZDOTDIR/private.zsh

autoload -Uz compinit
compinit


# # Plugin manager invocation
# declare -A ZNAP 
# ZNAP[PLUGINS]="$XDG_DATA_HOME/zsh/plugins"
# ZNAP[SELF]="$ZNAP[PLUGINS]/zsh-snap"
# ZNAP[BIN]="$ZNAP[SELF]/znap.zsh"
#
# if [[ ! -s $ZNAP[BIN] ]]; then
#   git clone --depth 1 'https://github.com/marlonrichert/zsh-snap.git' $ZNAP[SELF]
# fi
# source $ZNAP[BIN]
#
# [ ! -e "$HISTFILE" ] && mkdir $(dirname $HISTFILE)
#
# source "$ZDOTDIR/completion.zsh"
# source "$ZDOTDIR/key-bindings.zsh"
# source "$ZDOTDIR/aliases.zsh"
# [ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"
# [ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"




