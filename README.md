# os

The Home Cloud Operating System.

## auto-install

Steps to use:

1. Copy over the hardware configuration of your choice. For example:

```shell
cp auto-install/hardware/beelink-s12-n100.nix auto-install/hardware-configuration.nix
```

2. In `auto-install/configuration.nix` replace `YOUR_SSH_PUBLIC_KEY` with your SSH public key.

3. Compile the ISO:

```shell
cd auto-install
nix-build
```

4. Flash the generated `.iso` file to a USB drive using a tool like [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://etcher.balena.io/).

5. Install the ISO to your hardware using the bootable USB.

6. It will take a while to install and will shutdown when it's finished.

7. After turning on the system, SSH into it with `ssh admin@home-cloud.local`

8. In `/var/lib/rancher/k3s/server/manifests/draft.yaml` replace `YOUR_HOME_CLOUD_IP` with the IP address of the home-cloud box.


Special thanks to [Andrei Volt](https://gitlab.com/andreivolt/nixos-auto-install) for his initial work on this. We have adapted his effort for this use case.
