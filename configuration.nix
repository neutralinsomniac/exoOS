# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "audio"
    ];
    initialPassword = "password!";
  };

  environment.variables = {
    EDITOR = "hx";
    PAGER = "less -F";
  };

  # fwupd
  services.fwupd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  programs.mosh.enable = true;

  environment.systemPackages = with pkgs; [
    (st.overrideAttrs (oldAttrs: rec {
      configFile = ./st.conf;
      postPatch = (oldAttrs.postPatch or "") + "cp ${configFile} config.def.h";
    }))
    helix
    dmenu
    inputs.exocortex.packages.${pkgs.stdenv.hostPlatform.system}.exo
  ];

  fonts.packages = [
    pkgs.ultimate-oldschool-pc-font-pack
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "jeremy" ];
  };

  nix.channel.enable = false;
}
