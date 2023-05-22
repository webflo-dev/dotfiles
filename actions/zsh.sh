#!/usr/bin/env bash

sudo mkdir -p /etc/zsh
echo 'export ZDOTDIR=$HOME/.config/zsh' | sudo tee -a /etc/zsh/zshenv >/dev/null
