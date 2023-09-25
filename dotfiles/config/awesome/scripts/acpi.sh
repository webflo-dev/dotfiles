#!/usr/bin/env bash

function battery() {
	acpi_listen | grep --line-buffered ac_adapter | while read -r; do
		awk -F'=' '{
    if (/POWER_SUPPLY_NAME/) {name=$2};
    if (/POWER_SUPPLY_CAPACITY/) {capacity=$2};
    if (/POWER_SUPPLY_STATUS/) {status=$2};
    if (/POWER_SUPPLY_MODEL_NAME/) {model=$2};
    if (name && capacity && status && model)
    {print "BATTERY name=" name " capacity=" capacity " status=" status " model=" model ;exit}
  }' /sys/class/power_supply/BAT0/uevent
	done
}

function brightness() {
	while output=$(inotifywait -e modify /sys/class/backlight/?*/brightness -q); do
		read -r -a info <<<"$output"
		file=${info[0]}
		brightness_dir="$(dirname "$file")"
		device="$(basename "$brightness_dir")"
		value=$(cat "$file")
		max=$(cat "$brightness_dir"/max_brightness)
		percentage=$((value * 100 / max))
		echo "BRIGHTNESS device=$device value=$value max=$max percentage=$percentage"
	done
}

battery &
brightness &

wait
