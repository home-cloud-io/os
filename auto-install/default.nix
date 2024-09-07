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

										disks=$(lsblk -l -n -o NAME)
										echo $disks
										if [[ " $disks[*] " =~ [[:space:]]"nvme0n1"[[:space:]] ]]; then
												dev="/dev/nvme0n1"
										elif [[ " $disks[*] " =~ [[:space:]]"sda"[[:space:]] ]]; then
												dev="/dev/sda"
										elif [[ " $disks[*] " =~ [[:space:]]"vda"[[:space:]] ]]; then
												dev="/dev/vda"
										else
												echo "no valid device found"
												exit 1
										fi
										echo "using drive: $dev"

										part1=$dev"1"
										part2=$dev"2"
										if [ "$dev" = "/dev/nvme0n1" ]; then
												part1=$dev"p1"
												part2=$dev"p2"
										fi
										echo "parts: $part1 $part2"

          					${utillinux}/bin/sfdisk --delete $dev
										parted -s $dev -- mklabel gpt
										parted -s $dev -- mkpart root ext4 512MB 100%
										parted -s $dev -- mkpart ESP fat32 1MB 512MB
										parted -s $dev -- set 2 esp on

										mkfs.ext4 -L nixos "$part1"
										mkfs.fat -F 32 -n boot "$part2"

										mount /dev/disk/by-label/nixos /mnt
										mkdir -p /mnt/boot
										mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

          					install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
          					install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix
          					install -D ${./vars.nix} /mnt/etc/nixos/vars.nix
          					install -D ${./secrets.nix} /mnt/etc/nixos/secrets.nix
          					install -D ${./home-cloud/daemon/default.nix} /mnt/etc/nixos/home-cloud/daemon/default.nix
										install -D ${./home-cloud/draft.yaml} /mnt/var/lib/rancher/k3s/server/manifests/draft.yaml
										install -D ${./home-cloud/mdns.yaml} /mnt/var/lib/rancher/k3s/server/manifests/mdns.yaml
										install -D ${./home-cloud/operator.yaml} /mnt/var/lib/rancher/k3s/server/manifests/operator.yaml
										install -D ${./home-cloud/server.yaml} /mnt/var/lib/rancher/k3s/server/manifests/server.yaml
										install -D ${./home-cloud/daemon/config.yaml} /mnt/etc/home-cloud/config.yaml

          					sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/configuration.nix

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
