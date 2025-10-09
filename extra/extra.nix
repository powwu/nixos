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
    alsa-lib
    amazon-q-cli
    amdgpu_top
    android-studio
    anki-bin
    ardour
    awscli2
    blender
    bottles
    custom.calibre
    easyeffects
    flex
    gcc
    gdb
    gh
    ghidra
    gimp3-with-plugins
    go
    gpp
    gpt4all
    helm
    inkscape
    kicad
    krita
    nurl
    obs-studio
    odin2
    openscad
    openvr
    qbittorrent
    qdirstat
    reaper
    remmina
    ryubing
    scrcpy
    songrec
    steam
    steam-run
    surge-XT
    texliveTeTeX
    unstable.crc64fast-nvme
    unstable.moonlight-qt
    unstable.njq
    usb-modeswitch
    vagrant
    virt-manager
    vital
    vlang
    wlx-overlay-s
    wowup-cf
    xclicker
    xorg.xeyes
    yabridge
    yabridgectl
    yt-dlp
    zpaq

    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
  ];
}
