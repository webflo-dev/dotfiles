#!/usr/bin/env bash

declare cpu_last_sum
declare -a cpu_last
function cpu() {
	# Get the first line with aggregate of all CPUs
	cpu_now=($(head -n1 /proc/stat))
	# Get all columns but skip the first (which is the "cpu" string)
	cpu_sum="${cpu_now[@]:1}"
	# Replace the column seperator (space) with +
	cpu_sum=$((${cpu_sum// /+}))
	# Get the delta between two reads
	cpu_delta=$((cpu_sum - cpu_last_sum))
	# Get the idle time Delta
	cpu_idle=$((cpu_now[4] - cpu_last[4]))
	# Calc time spent working
	cpu_used=$((cpu_delta - cpu_idle))
	# Calc percentage
	cpu_usage=$((100 * cpu_used / cpu_delta))

	# Keep this as last for our next read
	cpu_last=("${cpu_now[@]}")
	cpu_last_sum=$cpu_sum

	echo "CPU usage=$cpu_usage"
}

function memory() {
	awk '{
    if (/MemAvailable:/) {mem_available=$2};
    if (/MemTotal:/) {mem_total=$2};
    if (mem_available && mem_total)
    {print "MEMORY total=" int(mem_total/1024) " free=" int(mem_available/1024) " used=" int((mem_total-mem_available)/1024) ;exit}
  }' /proc/meminfo
}

function gpu() {
	if command -v nvidia-smi &>/dev/null; then
		usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
		echo "GPU usage=$usage"
	fi
}

while :; do

	cpu
	memory
	gpu

	sleep 1
done
