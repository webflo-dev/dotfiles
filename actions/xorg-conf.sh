#!/usr/bin/env bash

DESTDIR=/etc/X11/xorg.conf.d/
sudo mkdir -p $DESTDIR

cp ./X11/10-monitor.conf ./X11/20-nvidia.conf $DESTDIR
