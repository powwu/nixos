#!/usr/bin/env sh

[ "$(pwd)" = "/etc/nixos" ] && cd /tmp

(
  cp -r /etc/nixos "/etc/nixos-bak-$(date --iso-8601)"
  rm -rf /etc/nixos/
  git clone https://github.com/powwu/nixos /etc/nixos/
  nixos-generate-config
  rm -rf /etc/nixos/.git
  rm -f /etc/nixos/configuration.nix
  mv /etc/nixos/hardware-configuration.nix /etc/nixos/nixos/
)

exec env -i HOME="$HOME" PATH="$PATH" /bin/sh -c 'cd /etc/nixos && exec "$SHELL"'
