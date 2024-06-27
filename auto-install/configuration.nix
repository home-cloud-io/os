{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
    ./vars.nix
    #installer-only ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.bcache.enable = false;

  # TODO-RC1: should this be true?
  security.sudo.wheelNeedsPassword = false;

  networking = {
    # TODO-RC2: configure this at initial user setup (since nodes after the first shouldn't be home-cloud.local)
    hostName = config.vars.hostname;
    networkmanager.enable = true;
    wireless.enable = false;

    firewall = {
      enable = false;
      # TODO-RC1: consider only opening certain ports (80, 443, 8443?) and setting `enable = true`
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };

  # TODO-RC1: disable this
  services.openssh.enable = true;

  # TODO-RC2, configure this at initial user setup so it can be an agent instead of a server (or do we want HA?)
  # ref: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
  services.k3s.enable = true;
  services.k3s.role = "server";

  # TODO-RC1: set password randomly during imaging or have the user set it during OOBE?
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ ];
  };

  # TODO-RC1: select locale options during OOBE
  # time.timeZone = "America/Chicago";
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # TODO-RC2: don't enable this for non-primary devices?
  # advertise hostname through mDNS
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = false;
    nssmdns4 = true;
    publish = { enable = true; domain = true; addresses = true; };
  };

  # TODO-RC1: slim these down to only the required ones when moving to RC1
  environment.systemPackages = with pkgs; [
    coreutils
    curl
    file
    git
    htop
    lsof
    nano
    openssl
    wget
    zip
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
