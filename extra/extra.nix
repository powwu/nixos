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
    amazon-q-cli
    android-studio
    blender
    easyeffects
    ghidra
    gimp3-with-plugins
    inkscape
    kicad
    krita
    moonlight-qt
    nurl
    obs-studio
    qbittorrent
    qdirstat
    reaper
    remmina
    ryubing
    scrcpy
    songrec
    steam
    steam-run
    unstable.crc64fast-nvme
    unstable.njq
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
