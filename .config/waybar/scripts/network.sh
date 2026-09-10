#!/bin/bash
# Waybar network script.
# Default: IP wlan0 (wifi). Ganti ke IP VPN kalau VPN beneran aktif (wg/tun).

VPN_ICON=""
WIFI_ICON=""
ETH_ICON=""

# 1) VPN beneran (wireguard wg*, openvpn tun*) — bukan tailscale/zerotier
vpn_ip=$(ip -4 addr show 2>/dev/null | awk '
    /^[0-9]+: (wg|tun)/{in_vpn=1; next}
    /^[0-9]+:/{in_vpn=0}
    in_vpn && /inet /{print $2; exit}
' | cut -d/ -f1)
if [ -n "$vpn_ip" ]; then
    echo "$VPN_ICON $vpn_ip"
    exit 0
fi

# 2) WiFi (wlan0)
wifi_ip=$(ip -4 addr show wlan0 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1 | head -1)
if [ -n "$wifi_ip" ]; then
    echo "$WIFI_ICON $wifi_ip"
    exit 0
fi

# 3) Ethernet fallback (default route)
eth_iface=$(ip route | awk '/^default/{print $5; exit}')
if [ -n "$eth_iface" ]; then
    eth_ip=$(ip -4 addr show "$eth_iface" 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1 | head -1)
    if [ -n "$eth_ip" ]; then
        echo "$ETH_ICON $eth_ip"
        exit 0
    fi
fi

echo "⚠  Offline"
