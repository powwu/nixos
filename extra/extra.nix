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
    amdgpu_top
    android-studio
    ardour
    awscli2
    blender
    calibre
    easyeffects
    flex
    gcc
    gdb
    gh
    ghidra
    gimp3-with-plugins
    go
    gpp
    inkscape
    kicad
    krita
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
    unstable.moonlight-qt
    unstable.njq
    usb-modeswitch
    vagrant
    virt-manager
    vlang
    wowup-cf
    xclicker
    xorg.xeyes
    yt-dlp
    zpaq

    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
  ];
}
