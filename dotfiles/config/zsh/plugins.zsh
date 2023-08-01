### zsh-completions
plug "zsh-users/zsh-completions"

### zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#626861"
plug "zsh-users/zsh-autosuggestions"

### zsh-syntax-highlighting
plug "zsh-users/zsh-syntax-highlighting"

plug "/usr/share/fzf/completion.zsh"
plug "/usr/share/fzf/key-bindings.zsh"
plug "Aloxaf/fzf-tab"


# if [ -e "$BUN_INSTALL" ]; then
#   path+=($BUN_INSTALL/bin)
#   source "$BUN_INSTALL/_bun"
# fi

# source "$INTELLI_HOME/bin/intelli-shell.sh"
eval "$(navi widget zsh)"
eval "$(zoxide init zsh)"

plug "anyakichi/fzf-utils"

eval "$(fnm env --use-on-cd)"
