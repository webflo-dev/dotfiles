#!/usr/bin/env bash

SOURCEDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DESTDIR=/etc/X11/xorg.conf.d/

sudo mkdir -p $DESTDIR

conf_files=()

libinput list-devices &>/dev/null | rg -S "touchpad" &>/dev/null && conf_files+=("00-touchpad.conf")
inxi --edid | rg "Dell G3223Q" &>/dev/null && conf_files+=("10-monitor.conf")
inxi --graphics | rg "RTX 3080" &>/dev/null && conf_files+=("20-nvidia.conf")
inxi --edid | rg "eDP(-?)1" &>/dev/null && conf_files+=("20-intel.conf")

[[ ${#conf_files[@]} -ge 0 ]] && cp "${conf_files[@]/#/$SOURCEDIR/}" $DESTDIR
