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

  boot.loader.systemd-boot.enable = true;
  boot.bcache.enable = false;

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];


  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      # TODO: Does this port need to be available externally via STUN? Do we want a unique port per client? Does that require multiple interfaces (one per client)?
      listenPort = 51820;

      # TODO: Give the user an option to tunnel all their traffic through Home Cloud
      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

      # This undoes the above command
      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

      # TODO: Generate this file when the user enables the feature.
      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/home-cloud/wireguard-keys/private";

      # TODO: These keys will be sent to the daemon from the server when adding clients through the admin dashboard.
      peers = [
        {
          publicKey = "qQPgg/fjW+ciCM2AO1NqxCs7kCa+NhMXc3VGK+bYWnE=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "gTw4fvPlrASYbEhRXtqnZEK7p6pftrzNE5EHHYxhCEI=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  # TODO: this is either not triggering or is triggering after the daemon has already been killed
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

  # TODO-RC3: these needs further testing
  # This service drains the node right before shutdown to make sure things have a chance to gracefully shutdown.
  # It also avoid the 90sec wait for containers to shutdown if you don't tell them to directly, speeding up shutdowns.
  # systemd.services.drain-node = {
  #   enable = true;
  #   description = "Drain Node";
  #   before = [ "shutdown.target" "umount.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = with pkgs;''
  #       ${k3s}/bin/k3s kubectl drain ${config.vars.hostname} --delete-emptydir-data=true --force=true
  #     '';
  #     Restart = "on-failure";
  #     RestartSec = 3;
  #   };
  #   wantedBy = [ "shutdown.target" ];
  # };

  # TODO-RC3: these needs further testing
  # This service uncordons the node at boot since the node is automatically cordoned when drained during shutdown.
  # This makes sure pods can be rescheduled on the node every time it boots up.
  # systemd.services.uncordon-node = {
  #   enable = true;
  #   description = "Uncordon Node";
  #   after = [ "k3s.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = with pkgs;''
  #       ${k3s}/bin/k3s kubectl uncordon ${config.vars.hostname}
  #     '';
  #     Restart = "on-failure";
  #     RestartSec = 3;
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

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

  networking = {
    # TODO-RC3: configure this at initial user setup (since nodes after the first shouldn't be home-cloud.local)
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

  # TODO-RC3, configure this at initial user setup so it can be an agent instead of a server (or do we want HA?)
  # ref: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = lib.concatStrings [ "--tls-san " config.vars.hostname ".local --disable traefik --service-node-port-range 80-32767" ];
  };

  # NOTE: the admin password is set by user during OOBE
  security.sudo.wheelNeedsPassword = false;
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # enable sudo
    openssh.authorizedKeys.keys = [];
  };

  # NOTE: this is set by user during OOBE
  time.timeZone = "Etc/UTC";

  # TODO-RC3: need to make sure the hostname is unique for multiple devices
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      userServices = true;
    };
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
      # pkgs.wireguard
      # pkgs.wireguard-tools
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
