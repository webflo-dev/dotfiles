#!/usr/bin/env bash

sudo gpasswd -a $USER input
install -Dm 644 /etc/libinput-gestures.conf $HOME/.config
libinput-gestures-setup start
