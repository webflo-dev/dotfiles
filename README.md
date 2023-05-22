# dotfiles

## Requirements

```shell
yay -S dotdrop pacdef paru zsh
```

## Dotdrop

Before installing dotfiles, we need to change the current shell and install zsh configuration to load all env variables.

```shell
alias dotdrop="DOTDROP_CONFIG=\$HOME/.dotfiles/config.yaml dotdrop"
chsh -s /usr/bin/zsh
dotdrop
```

## Pacdef
