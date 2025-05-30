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
    cinnamon-common
    easyeffects
    gimp3-with-plugins
    moonlight-qt
    obs-studio
    songrec
    steam
    tuxclocker
    vagrant
    virt-manager
    wowup-cf
    krita
    inkscape
    ghidra
    qbittorrent
    kicad
    ryubing
    # torzu
    android-studio
    steam-run
    scrcpy
    nixpkgs-review

    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
  ];
}
