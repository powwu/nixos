# This is your systYour new nix configis to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  sunshine-2025414181259 = pkgs.unstable.callPackage ../pkgs/sunshine-2025.414.181259/package.nix {libgbm = pkgs.unstable.libgbm;};
in {
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
  boot.loader.grub.device = "nodev"; # seems strange but recommended for EFI setups
  boot.loader.grub.extraConfig = ''
    if keystatus --shift ; then
        set timeout=-1
    else
        set timeout=0
    fi
  '';
  boot.loader.timeout = 0;
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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
    zerotierone
    zsh
  ];

  fonts.packages = with pkgs; [
    source-code-pro
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

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      # min_log_level = "verbose";
    };

    # TEMPORARY WHILE VIRTUAL DISPLAY FEATURE IS IN PRE-RELEASE
    package = sunshine-2025414181259;

    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin:$(HOME)/Wallpapers/bin";
      };
      apps = [
        {
          name = "1920x1080 Virtual";
          prep-cmd = [
            {
              do = "hyprctl keyword monitor HDMI-A-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, disable";
              undo = "";
            }
            {
              do = "hyprctl output create headless HEADLESS-0";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HDMI-A-1, 1920x1080@120, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.566663";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, 1920x1080@60, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HEADLESS-0, 1920x1080@60, auto, auto";
              undo = "";
            }
            {
              do = "swww kill";
              undo = "";
            }
            {
              do = "swww init";
              undo = "";
            }
          ];
        }
        {
          name = "2256x1504 Virtual";
          prep-cmd = [
            {
              do = "hyprctl keyword monitor HDMI-A-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, disable";
              undo = "";
            }
            {
              do = "hyprctl output create headless HEADLESS-0";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HDMI-A-1, 1920x1080@120, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.566663";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, 1920x1080@60, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HEADLESS-0, 2256x1504@60, auto, auto";
              undo = "";
            }
            {
              do = "swww kill";
              undo = "";
            }
            {
              do = "swww init";
              undo = "";
            }
          ];
        }
        {
          name = "2480x1650 Virtual";
          prep-cmd = [
            {
              do = "hyprctl keyword monitor HDMI-A-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, disable";
              undo = "";
            }
            {
              do = "hyprctl output create headless HEADLESS-0";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HDMI-A-1, 1920x1080@120, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.566663";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, 1920x1080@60, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HEADLESS-0, 2480x1650@30, auto, auto";
              undo = "";
            }
            {
              do = "swww kill";
              undo = "";
            }
            {
              do = "swww init";
              undo = "";
            }
          ];
        }

        {
          name = "Virtual Display Stop";
          prep-cmd = [
            {
              do = "hyprctl output remove HEADLESS-0";
              undo = "";
            }
          ];

          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }

        {
          name = "Desktop";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }

        {
          name = "Steam";
          detached = [
            "capsh --delamb=cap_sys_admin -- -c \"setsid steam steam://open/bigpicture\""
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Lutris";
          cmd = "capsh --delamb=cap_sys_admin -- -c \"lutris\"";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }

        {
          name = "Kill Main Displays";
          prep-cmd = [
            {
              do = "hyprctl keyword monitor HDMI-A-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor eDP-1, disable";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, disable";
              undo = "";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Reboot";
          cmd = "sudo reboot";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };

  # For connected file systems on libvirt
  # services.virtiofsd.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "52b337794fcb739b"
    ];
  };

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
        ];
        groups = ["wheel"];
      }
    ];
  };

  # FTP SERVER
  # networking.firewall.allowedTCPPorts = [21];

  # Inhibit power button input
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    PowerKeyIgnoreInhibited=yes
  '';

  programs.gdk-pixbuf.modulePackages = [pkgs.librsvg];
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
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
        command = "dbus-run-session Hyprland";
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
      trusted-users = [ "james" ];
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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
