{ config, lib, pkgs, ... }:
let
  home-cloud-daemon = import ./home-cloud/daemon/default.nix;
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
    ./vars.nix
    #installer-only ./hardware-configuration.nix
  ];

  boot = lib.importJSON (lib.concatStrings [ config.vars.root "/config/boot.json" ]);
  networking = lib.importJSON (lib.concatStrings [ config.vars.root "/config/networking.json" ]);
  services = lib.importJSON (lib.concatStrings [ config.vars.root "/config/services.json" ]);
  time = lib.importJSON (lib.concatStrings [ config.vars.root "/config/time.json" ]);
  users = lib.importJSON (lib.concatStrings [ config.vars.root "/config/users.json" ]);
  security = lib.importJSON (lib.concatStrings [ config.vars.root "/config/security.json" ]);

  # This service runs the Home Cloud Daemon at boot.
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
      RestartSec = 3;
      WorkingDirectory = "/root";
      ExecStart = ''
        ${home-cloud-daemon}/bin/daemon
      '';
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages =
    [
      home-cloud-daemon
      pkgs.avahi
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
