#!/bin/bash
#
# Prints a system report to stdout.
# Report includes:
# - Uptime
# - Load
# - CPU usage
# - Mem usage
# - Swap usage
# - Disk usage
#

top="$(top -bn1)"

uptime="$(echo "$top" | head -n 1 | sed -E 's/top -//')"
load="$(echo "$uptime" | cut -d ':' -f5)"

load_15m="$(echo $load | cut -d, -f3 | xargs)"

#load
echo "$uptime"
if [[ $(echo "$load_15m > 1" | bc) -eq 1 ]]; then
  echo "warning: HIGH LOAD DETECTED $load"
fi

# tasks
echo "$top" | sed -n 2p

# cpu
echo "$top" | sed -n 3p

# mem
mem="$(echo "$top" | sed -n 4p)"
mem_used="$(free | grep Mem | awk '{print $3/$2 * 100.0}')"
mem_percent="$(printf "%+16s " "$mem_used used%")"
echo "$mem,$mem_percent"
if [[ $(echo "$mem_used > 80" | bc) -eq 1 ]]; then
  echo "warning: HIGH MEMORY USAGE DETECTED $mem_used%"
fi

# swap
swap="$(echo "$top" | sed -n 5p)"
swap_used="$(free | grep Swap | awk '{print $3/$2 * 100.0}')"
swap_percent="$(printf "%+16s " "$swap_used used%")"
echo "$swap,$swap_percent"

# disk
disk="$(df -h | grep '/dev/vda1 ')"
fs="$(echo $disk | cut -d ' ' -f1)"
total="$(echo $disk | cut -d ' ' -f2)"
used="$(echo $disk | cut -d ' ' -f3)"
avail="$(echo $disk | cut -d ' ' -f4)"
use="$(echo $disk | cut -d ' ' -f5)"
echo "filesystem: $fs    size: $total    used: $used    avail: $avail    use%: $use"
