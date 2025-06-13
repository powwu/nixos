# This file contains extra packages that may take a while to compile and are not appropriate to automatically install for a smaller system.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    android-studio
    custom.not-torzu
    easyeffects
    ghidra
    gimp3-with-plugins
    inkscape
    kicad
    krita
    moonlight-qt
    nurl
    # unstable.njq
    obs-studio
    qbittorrent
    qdirstat
    remmina
    ryubing
    scrcpy
    songrec
    steam
    steam-run
    usb-modeswitch
    vagrant
    virt-manager
    whatsie
    wowup-cf
    yt-dlp
    zpaq

    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
  ];
}
