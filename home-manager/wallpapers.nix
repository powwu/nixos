{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.file."Wallpapers" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "powwu";
      repo = "wallpapers";
      rev = "60a7aa13531efd0c231dd06db086556ed401f498";
      hash = "sha256-FxXD4bU8rEuA6ENnSoMmpkwyvQyoOw6rWSmvzjozrsU=";
    };
  };
  home.file."Wallpapers/wallpapers.7z.001".source = pkgs.fetchurl {
    url = "https://github.com/powwu/wallpapers/releases/download/2025-06-23/wallpapers.7z.001";
    hash = "sha256-TdE9NNrpwpYXTd5p+zTM/9A9RIW9RKZXcazC6rUjGo4=";
  };
  home.file."Wallpapers/wallpapers.7z.002".source = pkgs.fetchurl {
    url = "https://github.com/powwu/wallpapers/releases/download/2025-06-23/wallpapers.7z.002";
    hash = "sha256-J6zWfJSZiMA5JlXISV5cYtTTOMggYq9A/Ei83OaFpHY=";
  };
  home.file."Wallpapers/wallpapers.7z.003".source = pkgs.fetchurl {
    url = "https://github.com/powwu/wallpapers/releases/download/2025-06-23/wallpapers.7z.003";
    hash = "sha256-Vp/qp8XjIvQlNacb0PPGM4E7WIFaneShMSwImB6bT20=";
  };
  home.file."Wallpapers/wallpapers.7z.004".source = pkgs.fetchurl {
    url = "https://github.com/powwu/wallpapers/releases/download/2025-06-23/wallpapers.7z.004";
    hash = "sha256-5sncMB5eRqk0hDrSF2QrviGfJBz+Z3zJqwmQ41CURe0=";
  };
  home.activation = {
    unpackWallpapers = lib.hm.dag.entryAfter ["onFilesChange"] ''
      find $HOME/Wallpapers/wallpapers -type d -mindepth 0 -maxdepth 0 > /dev/null 2> /dev/null || { cd $HOME/Wallpapers; $HOME/.nix-profile/bin/7z x wallpapers.7z.001 -pFTQmDd3rd6PxcKgF328C3N6XnzUW63PFiFd ; }
    '';
  };
}
