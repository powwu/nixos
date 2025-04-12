# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "james";
    homeDirectory = "/home/james";

  };

  ######  #    #  #####   #####
  #     # #   #  #     # #     #
  #     # #  #   #       #
  ######  ###    #  ####  #####
  #       #  #   #     #       #
  #       #   #  #     # #     #
  #       #    #  #####   #####
  home.packages = with pkgs; [
    adwaita-icon-theme
    adwaita-icon-theme-legacy
    alacritty
    amdgpu_top
    btop
    easyeffects
    eza
    firefox
    font-awesome
    gh
    git
    gimp-with-plugins
    hyprland
    hyprshot
    lightdm
    lutris
    lxappearance
    mako
    moonlight-qt
    nemo
    p7zip
    pavucontrol
    pycritty
    pywal
    pywalfox-native
    rofi
    source-code-pro
    spotify
    steam
    swww
    telegram-desktop
    thunderbird
    tuxclocker
    vesktop
    waybar
    wine
    wlroots
    wowup-cf
    wtype
    xclicker
    xorg.xeyes
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  # Enable programs
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  programs.waybar.enable = true;

  # programs.firefox = {
  #  enable = true;
  #  preferences = {
  #    "widget.use-xdg-desktop-portal.file-picker" = 1;
  #    "widget.use-xdg-desktop-portal.mime-handler" = 1;
  #  };
  #};

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  /*
  ​ #######   #####   #     #
   ​     #   #     #  #     #
    ​   #    #        #     #
  ​   #       #####   #######
  ​  #             #  #     #
  ​ #        #     #  #     #
  ​ #######   #####   #     #
*/
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      PROMPT="%m%F{green}%B%(?.%#.%F{red}!)%b%F{green} ";
      RPROMPT=" %F{red}%=%(?..%?)%b";
      PATH = "$PATH:/run/current-system/sw/bin/";
    };

    shellAliases = {
      nxe = "sudo nixos-rebuild switch --flake /etc/nixos#powwuinator; home-manager switch -b backup --flake /etc/nixos#james@powwuinator";
      nxen = "sudo nixos-rebuild switch --flake /etc/nixos#powwuinator";
      nxeh = "home-manager switch -b backup --flake /etc/nixos#james@powwuinator";
      ls = "eza -a";
    };
    history.size = 1000000;
    # history.file = "~/.histfile";
  };




  #######  #     #     #      #####    #####
  #        ##   ##    # #    #     #  #     #
  #        # # # #   #   #   #        #
  #####    #  #  #  #     #  #         #####
  #        #     #  #######  #              #
  #        #     #  #     #  #     #  #     #
  #######  #     #  #     #   #####    #####
  # Unfortunately, we can only deal with installation for now, until someone makes a spacemacs overlay for nixos (which I honestly don't care enough to do)
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs.defaultEditor = true;

  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "88c390ce78f1667eecee25baff1ee9b3acbb9b03";
      sha256 = "1jrZhBbncEvqwaZz4bDp9Snc0JkzYM1La0iLj/Art6E=";
    };
  };

  #     # #     # ######  ######  #          #    #     # ######
  #     #  #   #  #     # #     # #         # #   ##    # #     #
  #     #   # #   #     # #     # #        #   #  # #   # #     #
  #######    #    ######  ######  #       #     # #  #  # #     #
  #     #    #    #       #   #   #       ####### #   # # #     #
  #     #    #    #       #    #  #       #     # #    ## #     #
  #     #    #    #       #     # ####### #     # #     # ######
  wayland.windowManager.hyprland.settings = {
    exec-once = "swww-daemon & ~/Wallpapers/bin/wallpaper ~/Wallpapers/wallpapers/favorites & waybar & mako --default-timeout=15000 --layer=overlay & lxpolkit & sleep 2; thunderbird & pw-metadata -n settings 0 clock.force-quantum 0 & amdgpu_top --gui & sudo ntpd";
    # exec-once = "wl-paste -t text -w sh -c 'xclip -selection clipboard -o > /dev/null 2> /dev/null || xclip -selection clipboard'";

    monitor = [
      "DP-4,1920x1080@120,auto-left,1"
      "eDP-1,2256x1504@60,auto,1.8"
      "HDMI-A-1,1920x1080@120,auto,1"
    ];

    env = [
      "XCURSOR_THEME,Adwaita"
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_THEME,Adwaita"
      "HYPRCURSOR_SIZE,24"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";


      follow_mouse = 1;

      touchpad.natural_scroll = false;
      touchpad.scroll_factor = 0.5;
      # disable_while_typing = false;

      tablet = {
        # transform = 0;
        region_size = "2480 1650";
        # region_size = "6200 4650";
      };
      mouse_refocus = false;

      # accel_profile = "custom 0.2 0.0 0.5 1 1.2 1.5";
      accel_profile = "flat";
    };

    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      gaps_in = 1;
      gaps_out = 1;
      border_size = 1;

      "col.inactive_border" = "rgba(595959aa)";

      layout = "dwindle";
    };

    decoration = {
      rounding = 3;
      blur.enabled = false;
    };
    animations = {
      enabled = true;

      bezier = [
        "linear,0,0,0,0"
        "nearInstant,0,1.15,0,1"
        "easeOutCubic,0.33,1,0.68,1"
        "easeOutCirc,0,0.55,0.45,1"
        "easeOutSharp,0,0.55,0.1,1"
        "easeOutSharper,0,0.75,0,1"
        "easeOutSharpest,0,0.9,0,1"
        "easeOutBack, 0.05, 0.9, 0.1, 1.05"
      ];

      animation = [
        "windows, 1, 2, easeOutSharpest"
        "windowsOut, 1, 0.00000000001, linear"
        "border, 1, 1, default"
        "borderangle, 1, 1, default"
        "fade, 1, 3, easeOutSharper"
        "workspaces, 1, 3, easeOutSharper, fade"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    group = {
      "col.border_active" = "rgba(FFFFFFFF)";
      "col.border_inactive" = "rgba(000000BB)";
      groupbar = {
        "col.active" = "rgba(999999FF)";
        "col.inactive" = "rgba(999999FF)";
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_cancel_ratio = 0.1;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    misc = {
      disable_hyprland_logo = true;
    };

    windowrulev2 = [
      "noanim,class:(flameshot)"
      "move 0 0,class:(flameshot)"
      "noanim,class:(swww)"
      "move 0 0,class:(archlinux-logout.py)"
      "float,class:(archlinux-logout.py)"
      "tile,title:(.*Battle\.net.*)"
      "workspace 6,title:(.*Battle\.net.*)"
      "tile,class:(wow.exe)"
      "fullscreen,class:(wow.exe)"
      "workspace 6,class:(wow.exe)"
      "workspace 6,class:(lutris)"
      "animation slidefadevert,1,10,linear,class:(archlinux-logout.py)"
      "workspace 2,class:(firefox)"
      "workspace 3,class:(discord)"
      "workspace 3,class:(vesktop)"
      "workspace 3,class:(org.telegram.desktop)"
      "workspace 5,class:(Spotify)"
      "workspace name:mail silent,class:(thunderbird)"
      "workspace name:gpu silent,class:(amdgpu_top)"
      "move onscreen cursor -20% -20%,title:(glxgears)"
      "stayfocused,class:(Rofi)"
      "center,class:(Rofi)"
      "dimaround,class:(Rofi)"
      "move cursor -10% -10%,class:(^MATLAB.*)"
      "noanim,class:(osu)"
      "noblur,class:(osu)"
      "nodim,class:(osu)"
      "noborder,class:(osu)"
      "noshadow,class:(osu)"
    ];

    "$mainMod" = "SUPER";
    bind = [
      ", code:124, exec, archlinux-logout"
      ", code:123, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", code:122, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", code:121, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", code:232, exec, xbacklight -dec 5"
      ", code:233, exec, xbacklight -inc 5"
      "$mainMod, O, movecurrentworkspacetomonitor, 1"
      "$mainMod, P, movecurrentworkspacetomonitor, 0"
      "$mainMod, RETURN, exec, alacritty"
      "$mainMod, E, exec, env -u WAYLAND_DISPLAY nemo"
      "$mainMod, BACKSLASH, exec, firefox"
      "$mainMod, BACKSPACE, exec, emacsclient -c --alternate-editor=\"\""
      "$mainMod SHIFT, BACKSLASH, exec, vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland"
      "$mainMod SHIFT, BACKSLASH, exec, telegram-desktop"
      "$mainMod SHIFT, W, exec, ~/Wallpapers/bin/wallpaper ~/Wallpapers/wallpapers/favorites"
      "$mainMod SHIFT ALT, W, exec, cat ~/.current-wallpaper | xargs ~/Wallpapers/bin/wallpaper "
      "$mainMod, X, killactive, "
      "$mainMod SHIFT, X, exec, hyprctl kill "
      "$mainMod SHIFT ALT CTRL, Q, exit, "
      "$mainMod SHIFT, SPACE, togglefloating, "
      "$mainMod, SPACE, exec, rofi -show drun"
      "$mainMod, F, fullscreen"
      "$mainMod SHIFT, F, fullscreen, 1"
      "$mainMod, W, togglegroup"
      ",Print,exec, hyprshot -m region -o /home/james/Screenshots/"
      "$mainMod,Tab,exec, hyprshot -m region -o /home/james/Screenshots/"
      "$mainMod SHIFT,Tab,exec,grim -g \"$(slurp)\" - | tesseract -l \"eng\" stdin stdout | wl-copy"
      "SHIFT,Print,exec,QT_SCREEN_SCALE_FACTORS=\"0.625\" flameshot gui"
      "$mainMod SHIFT, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, left, changegroupactive, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, right, changegroupactive, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Move window with mainMod + SHIFT + arrow keys
      "$mainMod SHIFT, left, movewindoworgroup, l"
      "$mainMod SHIFT, right, movewindoworgroup, r"
      "$mainMod SHIFT, up, movewindoworgroup, u"
      "$mainMod SHIFT, down, movewindoworgroup, d"


      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, togglespecialworkspace"
      "$mainMod ALT, RETURN, workspace, name:mail"
      "$mainMod, MINUS, workspace, previous"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, special"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };

  gtk.cursorTheme = "Adwaita";

  #     #    #    #     # ######     #    ######
  #  #  #   # #    #   #  #     #   # #   #     #
  #  #  #  #   #    # #   #     #  #   #  #     #
  #  #  # #     #    #    ######  #     # ######
  #  #  # #######    #    #     # ####### #   #
  #  #  # #     #    #    #     # #     # #    #
  ### ##  #     #    #    ######  #     # #     #
  programs.waybar = {
    settings = {
      mainBar = {
        layer = "top"; # Waybar at top layer
        position = "top"; # Waybar at the bottom of your screen
        height = 22; # Waybar height

        # Choose the order of the modules
        modules-left = [
          "hyprland/workspaces"
          "custom/spotify"
          "custom/media"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "custom/weather"
          "pulseaudio"
          "network"
          "battery"
          "tray"
          "clock"
        ];
        # "start_hidden": true,
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "mail" = "";
            "gpu" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        tray = {
          # "icon-size": 12,
          "spacing" = 10;
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        battery = {
          bat = "BAT1";
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          # "format-good": "", # An empty format will hide the module
          # "format-full": "",
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        network = {
          # "interface": "wlp2s0", # (Optional) To force the use of this interface
          format-wifi = "{signalStrength}% ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth= "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        "custom/spotify" = {
          format = "{}";
          max-length = 40;
          interval = 1;
          exec = "$HOME/.config/waybar/mediaplayer.sh 2> /dev/null"; # Script in resources folder
          exec-if = "pgrep spotify";
        };
        "custom/weather" = {
          format = "{}    ";
          max-length = 40;
          interval = 300;
          exec = "curl -Ss 'https:#wttr.in?0&T&Q' 2> /dev/null | cut -c 16- | head -2 | tr '\n' ' ' | awk '{$1=$1};1'";
        };

      };
    };
    style = lib.strings.concatStrings [
      ''
  * {
      border: none;
      border-radius: 0;
      font-family: "Ubuntu Nerd Font";
      font-size: 12px;
      min-height: 0;
  }

  window#waybar {
      background-color: rgba(0, 0, 0, 0.7);
      color: white;
  }

  #window {
      font-weight: bold;
      font-family: "Ubuntu";
  }
  /*
  #workspaces {
      padding: 0 5px;
  }
  */

  #workspaces button {
      padding: 0 5px;
      background: transparent;
      color: white;
      border-top: 2px solid transparent;
  }

  #workspaces button.focused {
      color: #c9545d;
      border-top: 2px solid #c9545d;
  }

  #mode {
      background: #64727D;
      border-bottom: 3px solid white;
  }

  #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
      padding: 0 3px;
      margin: 0 2px;
  }

  #clock {
      font-weight: bold;
  }

  #battery {
  }

  #battery icon {
      color: red;
  }

  #battery.charging {
  }

  @keyframes blink {
      to {
          background-color: #ffffff;
          color: black;
      }
  }

  #battery.warning:not(.charging) {
      color: white;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }

  #cpu {
  }

  #memory {
  }

  #network {
  }

  #network.disconnected {
      background: #f53c3c;
  }

  #pulseaudio {
  }

  #pulseaudio.muted {
  }

  #custom-spotify {
      color: rgb(102, 220, 105);
  }

  #tray {
  }


  ''
    ];
  };
}
