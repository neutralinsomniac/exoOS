{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-micropc
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  config = {
    services.xserver.xkb.variant = lib.mkForce "";
    services.xserver.xrandrHeads = [
      {
        output = "DSI-1"; # Replace with your output (e.g., eDP-1, DP-2)
        monitorConfig = ''
          Option "Rotate" "right" # Options: left, right, inverted, normal
        '';
      }
    ];
  };
}
