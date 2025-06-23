{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      # min_log_level = "verbose";
    };

    # TEMPORARY WHILE VIRTUAL DISPLAY FEATURE IS IN PRE-RELEASE
    package = pkgs.custom.sunshine;

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
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.333333";
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
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.333333";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor DP-2, 1920x1080@60, auto-left, auto";
              undo = "";
            }
            {
              do = "hyprctl keyword monitor HEADLESS-0, 2256x1504@60, auto, 1.333333";
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
              do = "hyprctl keyword monitor eDP-1, 2256x1504@60, auto, 1.333333";
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
          cmd = "sudo /run/current-system/sw/bin/reboot";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
