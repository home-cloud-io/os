{ config, lib, pkgs, ... }:
let
  home-cloud-daemon = import ./home-cloud/daemon/default.nix;
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
    ./vars.nix
    ./secrets.nix
    #installer-only ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.bcache.enable = false;

  # TODO-RC2: this is either not triggering or is triggering after the daemon has already been killed
  # systemd.services.shutdown-alert = {
  #   enable = true;
  #   description = "Shutdown Alert";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStop = with pkgs;''
  #       ${curl}/bin/curl --header "Content-Type: application/json" --data '{}' http://localhost:9000/platform.daemon.v1.HostService/ShutdownAlert
  #     '';
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

  systemd.services.daemon = {
    enable = true;
    description = "Home Cloud Daemon";
    after = [ "network.target" ];
    serviceConfig = {
      Environment = [
        "DRAFT_CONFIG=/etc/home-cloud/config.yaml"
        "NIX_PATH=/root/.nix-defexpr/channels:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
        "PATH=/run/current-system/sw/bin"
      ];
      Restart = "always";
      WorkingDirectory = "/root";
      ExecStart = ''
        ${home-cloud-daemon}/bin/daemon
      '';
    };
    wantedBy = [ "multi-user.target" ];
  };

  security.sudo.wheelNeedsPassword = true;

  networking = {
    # TODO-RC2: configure this at initial user setup (since nodes after the first shouldn't be home-cloud.local)
    hostName = config.vars.hostname;
    networkmanager.enable = true;
    wireless.enable = false;
    domain = "local";

    firewall = {
      enable = false;
      # TODO-RC2: consider only opening certain ports (80, 443, 8443?) and setting `enable = true`
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };

  services.resolved = {
    enable = true;
    domains = [ "local" ];
  };

  # NOTE: enable this for local dev
  # services.openssh.enable = true;

  # TODO-RC2, configure this at initial user setup so it can be an agent instead of a server (or do we want HA?)
  # ref: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = lib.concatStrings [ "--tls-san " config.vars.hostname ".local --disable traefik --service-node-port-range 80-32767" ];
  };

  # NOTE: the admin password is set by user during OOBE
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # enable sudo
    openssh.authorizedKeys.keys = config.secrets.sshKeys;
  };

  # NOTE: this is set by user during OOBE
  time.timeZone = "Etc/UTC";

  environment.systemPackages =
    [
      home-cloud-daemon
      pkgs.coreutils
      pkgs.curl
      pkgs.nano
      pkgs.openssl
      pkgs.nvd
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
