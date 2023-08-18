#!/usr/bin/env bash

# Get general status and hardware info ( "-t" for easy output parsing )
# nmcli -t general status
#
# Get networking state (enabled/disabled)
# nmcli networking
#
# Get only connectivity
# nmcli networking connectivity
#
# Enable networking
# nmcli networking on
#
# Disable networking
# nmcli networking off
#

# available statuses
# connected, connecting, disconnected, unmanaged, unavailable
#
# available connectivity
# full, limited, none
#
# available global state
# connected, connected (site only), connecting, disconnected, asleep

function get_default_device() {
  echo $(ip -4 route ls  |awk '/^default/{print $5}')
}
function is_default_device() {
  declare device=${1}
  declare default_device=$(ip -4 route ls  |awk '/^default/{print $5}')
  [[ "$device" == "$default_device" ]] && return 0 || return -1
}

function device_state() {
  declare device=${1:-$default_device}
  state=$(cat /sys/class/net/$device/operstate)

  data="state=$state"

  echo "STATE::$device $data"
  is_default_device $device && echo "STATE::default $data"
}

declare default_device
default_device=$(get_default_device)

declare -A connection_names
function network_monitoring() {
nmcli --colors=no monitor | while read -r line; do
  if [[ "$line" =~ ^(.+)": disconnected"$ ]]; then
    device=${BASH_REMATCH[1]}
    echo "UPDATE device=$device state=disconnected"
  elif [[ "$line" =~ ^(.+)": connecting "(.*)$ ]]; then
    device=${BASH_REMATCH[1]}
    reason=${BASH_REMATCH[2]}
    reason=${reason:1:-1} # remove parentheses
    reason=${reason// /_} # replace spaces with underscores
reason="${reason//unix/linux}"
    echo "UPDATE device=$device state=connecting reason=$reason"
  elif [[ "$line" =~ ^(.+)": connected"$ ]]; then
    device=${BASH_REMATCH[1]}
    echo "UPDATE device=$device state=connected"
  elif [[ "$line" =~ ^(.+)": using connection "(.*)$ ]]; then
    device=${BASH_REMATCH[1]}
    connection=${BASH_REMATCH[2]}
    connection=${connection:1:-1} # remove quotes
    connection=${connection// /_} # replace spaces with underscores
    connection_names[$connection]=$device
    echo "UPDATE device=$device state=using_connection connection=$connection"
  elif [[ "$line" =~ ^(.*)" is now the primary connection"$  ]]; then
    connection=${BASH_REMATCH[1]}
    connection=${connection:1:-1} # remove quotes
    connection=${connection// /_} # replace spaces with underscores
    device=${connection_names[$connection]}
    default_device=$device
    echo "DEFAULT_CONNECTION device=$device connection=$connection"
  elif [[ "$line" =~ ^"Networkmanager is now in the "(.*)" state"$ ]]; then
    state=${BASH_REMATCH[1]}
    state=${state:1:-1} # remove quotes
    echo "STATE state=$state"
  elif [[ "$line" =~ ^"Connectivity is now "(.*)$ ]]; then
    connectivity=${BASH_REMATCH[1]}
    connectivity=${connectivity:1:-1} # remove quotes
    echo "CONNECTIVITY connectivity=$connectivity"
  fi

done
}


function activity() {
  declare download_bytes_last
  declare upload_bytes_last
  while :; do
    download_bytes=$(cat /sys/class/net/$default_device/statistics/rx_bytes)
    download_delta=$((download_bytes - download_bytes_last))
    download_bytes_last=$download_bytes

    upload_bytes=$(cat /sys/class/net/$default_device/statistics/tx_bytes)
    upload_delta=$((upload_bytes - upload_bytes_last))
    upload_bytes_last=$upload_bytes

    data="download=$download_delta upload=$upload_delta"

    echo "ACTIVITY $data"

    sleep 1
  done
}


network_monitoring &
activity &
wait
