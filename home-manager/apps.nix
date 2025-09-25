{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  /*
  #######   #####   #     #
       #   #     #  #     #
   ​   #    #        #     #
     #      #####   #######
    #            #  #     #
   #       #     #  #     #
  #######   #####   #     #
  */
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      PROMPT = "%m%F{green}%B%(?.%#.%F{red}!)%b%F{green} ";
      RPROMPT = " %F{red}%=%(?..%?)%b";
      PATH = "$PATH:/run/current-system/sw/bin/:$HOME/.local/bin/";
    };

    shellAliases = {
      cls = "clear";
      ew = "emacsclient -n -r -a \"\"";
      fav = "cat ~/.current-wallpaper | xargs cp -t ~/Wallpapers/wallpapers/favorites";
      lnp = "export NIX_PATH='nixpkgs=/home/james/nixpkgs/'";
      ls = "eza -a";
      nxe = "sudo nixos-rebuild switch --flake /etc/nixos#powwuinator && home-manager switch -b backup --flake /etc/nixos#james@powwuinator";
      nxeh = "home-manager switch -b backup --flake /etc/nixos#james@powwuinator";
      nxen = "sudo nixos-rebuild switch --flake /etc/nixos#powwuinator";
      q = "amazon-q";
      repl = "nix repl /etc/nixos";
      shiny = "pkill sunshine && sleep 10; flatpak run dev.lizardbyte.app.Sunshine";
      spotify = "spicetify watch -s";
      unfav = "cat ~/.current-wallpaper | rev | cut -d '/' -f 1 | rev | xargs -I {} rm ~/Wallpapers/wallpapers/favorites/{}";
      ytdl = "yt-dlp -f \"bestvideo[height<=1080]+bestaudio/best[height<=1080]\" -t sleep --cookies ~/yt-dlp-cookies.txt --extractor-args \"youtube:player-client=all,-ios,-android,-mweb,-tv,-tv_simply,-android_vr\"";
      videores = "ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0";
    };
    history.size = 1000000;
    history.path = "/home/james/.histfile";
    history.ignoreDups = true;
    history.ignoreSpace = true;
    history.append = true;

    initContent = ''
      any-nix-shell zsh --info-right | source /dev/stdin
      [[ $RPROMPT = '%0{%}' ]] && cd ~
    '';
  };

  /*
   #####   ######   #######  #######  ###  #######  #     #
  #     #  #     #  #     #     #      #   #         #   #
  #        #     #  #     #     #      #   #          # #
   #####   ######   #     #     #      #   #####       #
        #  #        #     #     #      #   #           #
  #     #  #        #     #     #      #   #           #
   #####   #        #######     #     ###  #           #
  */
  home.file.".config/spicetify" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "spicetify";
      rev = "fe24be93eef748c370f8948643ce2939970923b9";
      sha256 = "GXmth7wJb0EKRctOcM5tZIw6VjhAb19Wb1AGBDj7vCU=";
    };
  };
  home.file.".spotify-tmp" = {
    recursive = true;
    source = pkgs.custom.not-spotify.outPath;
  };
  home.activation = {
    fixSpotify = lib.hm.dag.entryAfter ["onFilesChange"] ''
      mkdir $HOME/spotify 2> /dev/null && cp -rL $HOME/.spotify-tmp/* $HOME/spotify
      rm -f $HOME/spotify/bin/spotify
      ln -s $HOME/spotify/share/spotify/spotify $HOME/spotify/bin/spotify
      chmod -R 774 $HOME/spotify/
      chmod +x $HOME/spotify/share/spotify/spotify $HOME/spotify/share/spotify/.spotify-wrapped
      export OLDPATH=$(echo ${pkgs.custom.not-spotify.outPath} | sed 's/\//\\\//g')
      export NEWPATH=$(echo $HOME/spotify | sed 's/\//\\\//g')
      sed -i "s/$OLDPATH/$NEWPATH/g" $HOME/spotify/share/spotify/spotify
      rm -rf $HOME/.spotify-tmp/
    '';
  };
  xdg.desktopEntries.spotify = {
    type = "Application";
    name = "Spotify";
    exec = "spicetify watch -s";
    terminal = false;
    comment = "Spotify launch wrapper w/ spicetify";
  };

  /*
  ######   #######  #######  ###
  #     #  #     #  #         #
  #     #  #     #  #         #
  ######   #     #  #####     #
  #   #    #     #  #         #
  #    #   #     #  #         #
  #     #  #######  #        ###
  */
  home.file.".config/rofi/config.rasi".text = ''
    @theme "~/.cache/wal/colors-rofi-dark.rasi"
  '';

  /*
  #     #     #     #
  #  #  #    # #    #
  #  #  #   #   #   #
  #  #  #  #     #  #
  #  #  #  #######  #
  #  #  #  #     #  #
   ## ##   #     #  #######
  */
  home.file.".config/wal" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "wal";
      rev = "99c30689dffc6ba8f8c1f06ea22e726064c6f17e";
      sha256 = "sha256-SgpInaY4BCSViAaZg+KLbyCV2pYBY3QjGGNLqmL77KY=";
    };
  };

  /*
  #     #  #######   #####   #    #  #######  #######  ######
  #     #  #        #     #  #   #      #     #     #  #     #
  #     #  #        #        #  #       #     #     #  #     #
  #     #  #####     #####   ###        #     #     #  ######
   #   #   #              #  #  #       #     #     #  #
    # #    #        #     #  #   #      #     #     #  #
     #     #######   #####   #    #     #     #######  #
  */
  home.file.".config/vesktop" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "vesktop";
      rev = "97587a215c188efa36fddfd20ae9509b0beb60c5";
      sha256 = "sha256-4Paxa4GdA7EqwgAqL6zZMjGxriD9VfKggnjcQ7UF2AY=";
    };
  };
  home.activation = {
    fixVesktop = lib.hm.dag.entryAfter ["onFilesChange"] ''
      find ~/.config/vesktop/themes/Themecord.css > /dev/null 2> /dev/null || cp -L ~/.config/vesktop/themes/Themecord-tmp.css ~/.config/vesktop/themes/Themecord.css
      chmod 664 ~/.config/vesktop/themes/Themecord.css
    '';
  };

  /*
  #     #     #     #    #  #######
  ##   ##    # #    #   #   #     #
  # # # #   #   #   #  #    #     #
  #  #  #  #     #  ###     #     #
  #     #  #######  #  #    #     #
  #     #  #     #  #   #   #     #
  #     #  #     #  #    #  #######
  */
  home.file.".config/mako" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "mako";
      rev = "f518060dd30ae9b4694d82f61504f4f48ff011ea";
      hash = "sha256-JB3EdjeWnNHHlfIPtpF4CceyI3aw5XumVqMoV+oWs1k=";
    };
  };
  home.activation = {
    fixMako = lib.hm.dag.entryAfter ["onFilesChange"] ''
      find ~/.config/mako/config > /dev/null 2> /dev/null || cp -L ~/.config/mako/config-tmp ~/.config/mako/config
      chmod 664 ~/.config/mako/config
    '';
  };

  /*
     #     #           #      #####   ######   ###  #######  #######  #     #
    # #    #          # #    #     #  #     #   #      #        #      #   #
   #   #   #         #   #   #        #     #   #      #        #       # #
  #     #  #        #     #  #        ######    #      #        #        #
  #######  #        #######  #        #   #     #      #        #        #
  #     #  #        #     #  #     #  #    #    #      #        #        #
  #     #  #######  #     #   #####   #     #  ###     #        #        #
  */
  home.file.".config/alacritty" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "alacritty";
      rev = "0641c98f2c897da63fe3b980f27773ab8f9a8c70";
      hash = "sha256-yxG0I5bVevO5SvGDz10q5VgDQqyJYlcxjYJq9pe+Im4=";
    };
  };
  home.activation = {
    fixAlacritty = lib.hm.dag.entryAfter ["onFilesChange"] ''
      find ~/.config/alacritty/alacritty.yml > /dev/null 2> /dev/null || cp -L ~/.config/alacritty/alacritty-tmp.yml ~/.config/alacritty/alacritty.yml
      chmod 774 ~/.config/alacritty/alacritty.yml
    '';
  };

  /*
  #######  #     #     #      #####    #####
  #        ##   ##    # #    #     #  #     #
  #        # # # #   #   #   #        #
  #####    #  #  #  #     #  #         #####
  #        #     #  #######  #              #
  #        #     #  #     #  #     #  #     #
  #######  #     #  #     #   #####    #####
  */
  # Unfortunately, we can only deal with installation for now, until someone makes a spacemacs overlay for nixos (which I honestly don't care enough to do). `.spacemacs` is already a declarative configuration for emacs, just like home-manager would provide
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs.defaultEditor = true;
  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "spacemacs";
      rev = "df7dc295ad09f4f5af8731144d40e01a549ce336";
      hash = "sha256-kJRq+uF5iD4RaGVXePiQf9pt8dCA0T+GJgtpvSd2z4M=";
    };
  };

  # overwriting would be a cause for concern. however, home-manager makes sure that any backups are not overwritten, and will refuse to continue if that's not the case
  home.file.".spacemacs".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/powwu/dotspacemacs/refs/heads/main/.spacemacs";
    hash = "sha256-9qx9wb+EnQM8Z3FACCTqh+6tHGxPOa3iIIvdcKejbF4=";
  };

  home.activation = {
    fixSpacemacs = lib.hm.dag.entryAfter ["onFilesChange"] ''
      find $HOME/.spacemacs -type l > /dev/null && cp --remove-destination `readlink $(readlink $HOME/.spacemacs)` .spacemacs
      chmod 664 $HOME/.spacemacs
    '';
    backupSpacemacs = lib.hm.dag.entryAfter ["fixSpacemacs"] ''
      ls $HOME/.backup-spacemacs > /dev/null || mkdir $HOME/.backup-spacemacs
      mv $HOME/.spacemacs.backup $HOME/.backup-spacemacs/spacemacs.backup-"$(date --iso-8601=s)" || exit 0
    '';
  };

  /*
  #######  ###  ######   #######  #######  #######  #     #
  #         #   #     #  #        #        #     #   #   #
  #         #   #     #  #        #        #     #    # #
  #####     #   ######   #####    #####    #     #     #
  #         #   #   #    #        #        #     #    # #
  #         #   #    #   #        #        #     #   #   #
  #        ###  #     #  #######  #        #######  #     #
  */
  programs.firefox = {
    enable = true;
    languagePacks = ["en-US"];

    policies = {
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      ExtensionSettings = {
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        # Pywalfox:
        "pywalfox@frewacom.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          installation_mode = "normal_installed";
        };
      };

      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "sidebar.verticalTabs" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
      };
    };
  };
  home.activation = {
    installPywalfox = lib.hm.dag.entryAfter ["onFilesChange"] ''
      $HOME/.nix-profile/bin/pywalfox install --browser firefox
    '';
  };
}
