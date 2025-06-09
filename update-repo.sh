#!/usr/bin/env sh

rm -rf /tmp/nixos
git clone https://github.com/powwu/nixos /tmp/nixos || exit
cd /tmp/nixos
rm -rf ./*
cp -r /etc/nixos/* .
git add -u .
git commit -m "$(date --iso-8601)"
git push
