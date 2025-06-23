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

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    acpilight
    bash
    dxvk
    git
    git-lfs
    file
    gutenprint
    icewm
    virtiofsd
    gdk-pixbuf
    OVMFFull
    libva
    libva-utils
    lxde.lxsession
    mesa
    inputs.crc64fast-nvme-nix.packages.x86_64-linux.default
    mesa-gl-headers
    neovim
    networkmanager
    openvr
    pipewire
    python3
    qemu
    rtkit
    usbutils
    vulkan-extension-layer
    vulkan-loader
    vulkan-tools
    powertop
    vulkan-validation-layers
    wine
    wine64
    winetricks
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

  programs.adb.enable = true;

  # programs.kdeconnect.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.waydroid.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint];
  };

  # For connected file systems on libvirt
  # services.virtiofsd.enable = true;

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/xbacklight";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/reboot";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/nmtui";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
