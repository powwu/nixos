{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "52b337794fcb739b"
    ];
  };
}
