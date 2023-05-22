#!/usr/bin/env bash

sudo gpasswd -a $USER input
install -Dm 644 /etc/libinput-gestures.conf $XDG_CONFIG_HOME
libinput-gestures-setup start
