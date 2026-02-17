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
    # unstable.gpt4all
    alsa-lib
    amazon-q-cli
    amdgpu_top
    android-studio
    anki-bin
    ardour
    awscli2
    blender
    bottles
    calibre
    crc64fast-nvme
    custom.archlinux-logout
    custom.toonmux
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
    helm
    inkscape
    inputs.themecord.packages.x86_64-linux.default
    kicad
    krita
    nix-index
    nix-search-cli
    njq
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
    shticker-book-unwritten
    songrec
    steam
    steam-run
    surge-XT
    telegram-desktop
    texliveTeTeX
    unstable.crossmacro
    unstable.moonlight-qt
    unstable.pince
    unstable.slimevr
    unstable.slimevr-server
    unstable.spicetify-cli
    unstable.wowup-cf
    usb-modeswitch
    vagrant
    vesktop
    vial
    virt-manager
    vital
    vlang
    wlx-overlay-s
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
