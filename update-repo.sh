#!/usr/bin/env sh

rm -rf ./*
cp -r /etc/nixos/* .
git add -u .
git commit -m "$(date --iso-8601)"
git push
