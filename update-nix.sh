#!/usr/bin/env sh

[ $(whoami) = "root" ] || { echo "need root"; exit 1; }

[ "$(pwd)" = "/etc/nixos" ] && cd /tmp

cp -r /etc/nixos "/etc/nixos-bak-$(date --iso-8601=s)"
rm -rf /etc/nixos/
git clone https://github.com/powwu/nixos /etc/nixos/
nixos-generate-config
rm -rf /etc/nixos/.git
rm -f /etc/nixos/configuration.nix
mv /etc/nixos/hardware-configuration.nix /etc/nixos/nixos/

if find /sys/class/power_supply/ -name 'BAT*' | grep -q .; then
  echo "Battery detected, uncommenting ./extra/laptop.nix in flake.nix"
  sed -i 's|^\([[:space:]]*\)#\([[:space:]]*./extra/laptop.nix[[:space:]]*\)|\1\2|' /etc/nixos/flake.nix
fi
