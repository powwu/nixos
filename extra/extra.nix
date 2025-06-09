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
    easyeffects
    ghidra
    gimp3-with-plugins
    inkscape
    kicad
    krita
    moonlight-qt
    nixpkgs-review
    obs-studio
    qbittorrent
    qdirstat
    ryubing
    scrcpy
    songrec
    steam
    steam-run
    # torzu
    tuxclocker
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
