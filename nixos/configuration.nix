# This is your systYour new nix configis to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages;
  # boot.extraModulePackages = [inputs.mt7601u-access-point.packages.x86_64-linux.default];
  boot.extraModulePackages = [config.boot.kernelPackages.rtl8852bu];
  boot.kernelParams = [
    "quiet"
    "splash"
    "coherent_pool=4M"
  ];

  boot.loader.systemd-boot.enable = false;
  virtualisation.docker = {
    enable = true;
  };

  zramSwap.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.loader.grub.device = "nodev"; # seems strange but recommended for EFI setups
  boot.loader.grub.extraConfig = ''
    if keystatus --shift ; then
        set timeout=-1
    else
        set timeout=0
    fi
  '';
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.custom-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    #   amdgpu.amdvlk = {
    #     enable = true;
    #     support32Bit.enable = true;
    #   };
  };

  services.wivrn.enable = true;
  services.wivrn.openFirewall = true;

  environment.systemPackages = with pkgs; [
    OVMFFull
    acpilight
    appimage-run
    bash
    dxvk
    file
    gdk-pixbuf
    git
    git-lfs
    gutenprint
    icewm
    libva
    libva-utils
    lxde.lxsession
    mesa
    mesa-gl-headers
    neovim
    networkmanager
    openvr
    pipewire
    powertop
    python3
    qemu
    rtkit
    unityhub
    unstable.alcom
    usbutils
    virtiofsd
    vulkan-extension-layer
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    wine
    wine64
    winetricks
    wivrn
    zsh
  ];

  fonts.packages = with pkgs; [
    victor-mono
  ];

  # XRDP
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "icewm";
  services.xrdp.openFirewall = true;

  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  programs.virt-manager.enable = true;

  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play

    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.adb.enable = true;

  # programs.kdeconnect.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = [pkgs.virtiofsd];

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.waydroid.enable = true;
  security.polkit.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint];
  };

  # For connected file systems on libvirt
  # services.virtiofsd.enable = true;

  # FTP SERVER
  # services.vsftpd = {
  #   enable = true;
  #   writeEnable = true;
  #   localUsers = true;
  #   anonymousUser = false;
  #   extraConfig = ''
  #     pasv_enable=YES
  #     pasv_min_port=50000
  #     pasv_max_port=50100
  #     local_umask=022
  #     allow_writeable_chroot=YES
  #   '';
  # };
  # networking.firewall.allowedTCPPorts = [21] ++ (lib.range 50000 50100);

  # Inhibit power button input
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    PowerKeyIgnoreInhibited=yes
  '';

  programs.gdk-pixbuf.modulePackages = [pkgs.librsvg];
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  boot.initrd.kernelModules = ["amdgpu"];
  programs.dconf.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  networking.networkmanager.enable = true;
  services.automatic-timezoned.enable = true;
  services.udisks2.enable = true;
  services.ntp.enable = true;
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    package = pkgs.greetd;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "james";
      };
      default_session = initial_session;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["james"];
    };

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  services.resolved = {
    enable = true;
  };

  services.flatpak.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.mullvad-vpn.enable = true;
  programs.gamemode.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  networking.hostName = "powwuinator";
  networking.hostId = "deaffade";

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    james = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [];
      extraGroups = [
        "wheel"
        "audio"
        "games"
        # "docker"
        "video"
        "libvirt"
        "adbusers"
        "input"
        "autologin"
        "fuse"
        "seat"
      ];
      initialPassword = "password";
    };
  };

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];
  services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5343", ATTRS{idProduct}=="0080", OWNER="1000", GROUP="100", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
  '';
  # services.udev.packages = [
  #   (pkgs.writeTextFile {
  #     name = "50-oculus.rules";
  #     text = ''
  #         SUBSYSTEM="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660" group="plugdev", symlink+="ocuquest%n"
  #       '';
  #     destination = "/etc/udev/rules.d/50-oculus.rules";
  #   } )
  #   (pkgs.writeTextFile {
  #     name = "52-android.rules";
  #     text = ''
  #         SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", OWNER=matt;
  #       '';
  #     destination = "/etc/udev/rules.d/52-android.rules";
  #   })
  # ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
