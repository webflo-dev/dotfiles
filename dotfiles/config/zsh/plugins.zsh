znap eval starship 'starship init zsh --print-full-init'
znap prompt


#znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-completions

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#626861"

znap source zsh-users/zsh-autosuggestions

znap source zsh-users/zsh-syntax-highlighting
# znap source unixorn/fzf-zsh-plugin
znap source Aloxaf/fzf-tab

if [ -e "$BUN_INSTALL" ]; then 
  path+=($BUN_INSTALL/bin)
  source "$BUN_INSTALL/_bun"
fi

source ~/dev/castor/__castor.zsh

fpath+=("$HOME/.dotfiles/dotdrop/completion")
autoload -U compinit
compinit
