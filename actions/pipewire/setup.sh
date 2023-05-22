#!/usr/bin/env bash

SOURCEDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

mkdir -p $XDG_CONFIG_HOME/pipewire
cp $SOURCEDIR/filter-chain.conf.d $XDG_CONFIG_HOME/pipewire/

mkdir -p $XDG_CONFIG_HOME/systemd/user
cp -R $SOURCEDIR/systemd-user/* $XDG_CONFIG_HOME/systemd/user/
