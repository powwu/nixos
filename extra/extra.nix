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
    # android-studio
    anki-bin
    ardour
    awscli2
    bc
    blender
    bottles
    calibre
    cpulimit
    crc64fast-nvme
    custom.archlinux-logout
    custom.toonmux
    custom.tt-multiclick-linux
    custom.tunetoon
    easyeffects
    ffmpeg
    flex
    gamescope
    gcc
    gdb
    gh
    ghidra
    gimp3-with-plugins
    go
    gpp
    grim
    helm
    inkscape
    inputs.themecord.packages.x86_64-linux.default
    kdePackages.kleopatra
    kdePackages.okular
    kicad
    krita
    libqalculate
    moonlight-qt
    nix-index
    nix-search-cli
    njq
    nurl
    obs-studio
    obsidian
    odin2
    openscad
    openvr
    pinentry-qt
    qbittorrent
    qdirstat
    reaper
    remmina
    ryubing
    scrcpy
    shticker-book-unwritten
    slurp
    songrec
    steam
    steam-run
    surge-xt
    telegram-desktop
    tesseract
    texliveTeTeX
    unstable.crossmacro
    unstable.pince
    unstable.slimevr
    unstable.slimevr-server
    unstable.spicetify-cli
    unstable.winetricks
    unstable.wowup-cf
    usb-modeswitch
    vagrant
    vesktop
    vial
    virt-manager
    vital
    vlang
    wayvr
    wineWow64Packages.staging
    xclicker
    xeyes
    yabridge
    yabridgectl
    yt-dlp
    zpaq
    (nix-webapps-lib.mkChromiumApp {
      appName = "trello";
      desktopName = "Trello";
      url = "https://trello.com";
    })
  ];

  xdg.desktopEntries.bcp = {
    name = "Book of Common Prayer";
    genericName = "BCP";
    exec = "okular \"/home/james/Books/Church Publishing Incorporated/The Book of Common Prayer (63)/The Book of Common Prayer - Church Publishing Incorporated.pdf\"";
    icon = "x-office-address-book";
    comment = "The Episcopal Church BCP";
    categories = [ "Education" ];
    terminal = false;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 3600; # cache passphrase 1 hour
    maxCacheTtl = 86400; # max cache 24 hours
    enableSshSupport = true; # optional: use GPG key for SSH
  };

  programs.gpg = {
    enable = true;
  };
}
