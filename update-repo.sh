#!/usr/bin/env sh

rm -rf /tmp/nixos
git clone https://github.com/powwu/nixos /tmp/nixos || exit
cd /tmp/nixos
rm -rf ./*
cp -r /etc/nixos/* .
sed -i 's|^\([[:space:]]*\)\([^#][[:space:]]*./extra/laptop.nix[[:space:]]*\)|\1# \2|' flake.nix
git add -u .
git commit -m "$(date --iso-8601=s)"
git push
