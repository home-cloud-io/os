{ system ? "x86_64-linux"
,
}:
(import <nixpkgs/nixos/lib/eval-config.nix> {
  inherit system;
  modules = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    ./configuration.nix
    ({ config, pkgs, lib, ... }: {
      systemd.services.install = {
        description = "Bootstrap a NixOS installation";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "polkit.service" ];
        path = [ "/run/current-system/sw/" ];
        script = with pkgs; ''
          					echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history

          					set -eux

          					wait-for() {
          						for _ in seq 10; do
          							if $@; then
          								break
          							fi
          							sleep 1
          						done
          					}

          					dev=/dev/sda
          					[ -b /dev/nvme0n1 ] && dev=/dev/nvme0n1
          					[ -b /dev/vda ] && dev=/dev/vda

          					${utillinux}/bin/sfdisk --delete $dev
										parted -s $dev -- mklabel gpt
										parted -s $dev -- mkpart root ext4 512MB -8GB
										parted -s $dev -- mkpart swap linux-swap -8GB 100%
										parted -s $dev -- mkpart ESP fat32 1MB 512MB
										parted -s $dev -- set 3 esp on

										mkfs.ext4 -L nixos "$dev"1
										mkswap -L swap "$dev"2
										mkfs.fat -F 32 -n boot "$dev"3

										mount /dev/disk/by-label/nixos /mnt
										mkdir -p /mnt/boot
										mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
										swapon "$dev"2

          					install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
          					install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

          					sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

          					${config.system.build.nixos-install}/bin/nixos-install \
          						--system ${(import <nixpkgs/nixos/lib/eval-config.nix> {
          							inherit system;
          							modules = [
          								./configuration.nix
          								./hardware-configuration.nix
          							];
          						}).config.system.build.toplevel} \
          						--no-root-passwd \
          						--cores 0

          					echo 'Shutting off in 1min'
          					${systemd}/bin/shutdown +1
          				'';
        environment = config.nix.envVars // {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };
    })
  ];
}).config.system.build.isoImage