#!/usr/bin/env bash

mkdir -p $HOME/.config/systemd/user 
cp ./pipewire/pipewire-filter-chain.service $HOME/.config/systemd/user/

mkdir -p $HOME/.config/pipewire/filter-chain.conf.d 
cp ./pipewire/10-echo-cancellation.conf ./pipewire/99-input-denoising.conf $HOME/.config/pipewire/filter-chain.conf.d/
