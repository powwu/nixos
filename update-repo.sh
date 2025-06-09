#!/usr/bin/env sh

git clone https://github.com/powwu/nixos /tmp/nixos
cd /tmp/nixos
rm -rf ./*
cp -r /etc/nixos/* .
git add -u .
git commit -m "$(date --iso-8601)"
git push
