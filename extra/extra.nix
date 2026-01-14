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
    ffmpeg
    flex
    gcc
    gdb
    gh
    ghidra
    gimp3-with-plugins
    go
    gpp
    # gpt4all
    helm
    inkscape
    kicad
    krita
    nix-search-cli
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
    slimevr
    slimevr-server
    songrec
    steam
    steam-run
    surge-XT
    texliveTeTeX
    crc64fast-nvme
    unstable.moonlight-qt
    njq
    usb-modeswitch
    vagrant
    vial
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
