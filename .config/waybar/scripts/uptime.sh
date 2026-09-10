#!/usr/bin/env bash
# Waybar uptime — omit zero-valued units (no "0d" spam)
read -r s _ < /proc/uptime
s=${s%.*}
d=$((s / 86400)); h=$(((s % 86400) / 3600)); m=$(((s % 3600) / 60))
out=""
(( d > 0 )) && out+="${d}d "
(( h > 0 )) && out+="${h}h "
out+="${m}m"
echo "${out}"
