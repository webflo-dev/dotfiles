# znap eval starship 'starship init zsh --print-full-init'
# znap prompt
#
#
# #znap source marlonrichert/zsh-autocomplete
# znap source zsh-users/zsh-completions
#
# zsh_autosuggest_strategy=(history completion)
# zsh_autosuggest_buffer_max_size=50
# # zsh_autosuggest_highlight_style="fg=#808080"
# zsh_autosuggest_highlight_style="fg=#626861"
#
# znap source zsh-users/zsh-autosuggestions
#
# znap source zsh-users/zsh-syntax-highlighting
# # znap source unixorn/fzf-zsh-plugin
# znap source Aloxaf/fzf-tab
#
# if [ -e "$bun_install" ]; then 
#   path+=($bun_install/bin)
#   source "$bun_install/_bun"
# fi
#
# [[ -e $HOME/dev/castor/__castor/.zsh ]] && source $HOME/dev/castor/__castor.zsh
#
# fpath+=("$HOME/.dotfiles/dotdrop/completion")


# autoload -U compinit
# compinit



[ -f "${XDG_DATA_HOME}/zap/zap.zsh" ] && source "${XDG_DATA_HOME}/zap/zap.zsh"

plug "zsh-users/zsh-completions"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#626861"
plug "zsh-users/zsh-autosuggestions"

plug "zsh-users/zsh-syntax-highlighting"

plug "/usr/share/fzf/completion.zsh"
plug "/usr/share/fzf/key-bindings.zsh"
plug "Aloxaf/fzf-tab"

fpath+=("$HOME/.dotfiles/dotdrop/completion")

[[ -e $HOME/dev/castor/__castor/.zsh ]] && source $HOME/dev/castor/__castor.zsh

if [ -e "$BUN_INSTALL" ]; then
  path+=($BUN_INSTALL/bin)
  source "$BUN_INSTALL/_bun"
fi

