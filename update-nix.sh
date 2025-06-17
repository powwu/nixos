#!/usr/bin/env sh

[ $(whoami) = "root" ] || { echo "need root"; exit 1; }

[ "$(pwd)" = "/etc/nixos" ] && cd /tmp


ls /etc/nixos-bak > /dev/null 2> /dev/null || mkdir /etc/nixos-bak
cp -r /etc/nixos "/etc/nixos-bak/nixos-bak-$(date --iso-8601=s)"
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
if ls /etc/.sunshine-enable > /dev/null 2> /dev/null; then
    echo "/etc/.sunshine-enable exists, uncommenting ./extra/sunshine.nix in flake.nix"
    sed -i 's|^\([[:space:]]*\)#\([[:space:]]*./extra/sunshine.nix[[:space:]]*\)|\1\2|' /etc/nixos/flake.nix
else
    echo "Sunshine is not enabled by default. To enable temporarily, uncomment the line in /etc/nixos/flake.nix and rebuild. To make enabling permanent, run \`touch /etc/.sunshine-enable\`"
fi
if ls /etc/.zerotier-enable > /dev/null 2> /dev/null; then
    echo "/etc/.zerotier-enable exists, uncommenting ./extra/zerotier.nix in flake.nix"
    sed -i 's|^\([[:space:]]*\)#\([[:space:]]*./extra/zerotier.nix[[:space:]]*\)|\1\2|' /etc/nixos/flake.nix
else
    echo "Zerotier is not enabled by default. To enable temporarily, uncomment the line in /etc/nixos/flake.nix and rebuild. To make enabling permanent, run \`touch /etc/.zerotier-enable\`"
fi

cd /tmp
cd /etc/nixos
nix fmt . > /dev/null 2> /dev/null

