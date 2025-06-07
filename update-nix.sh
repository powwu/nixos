#!/usr/bin/env sh

cp -r /etc/nixos /etc/nixos-bak-$(date --iso-8601)
rm -rf /etc/nixos/
git clone https://github.com/powwu/nixos /etc/nixos/
nixos-generate-config
rm -rf /etc/nixos/.git
rm -rf /etc/nixos/configuration.nix
mv /etc/nixos/hardware-configuration.nix /etc/nixos/nixos/
