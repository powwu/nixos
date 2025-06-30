{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
