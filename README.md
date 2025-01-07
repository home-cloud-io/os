# os

The Home Cloud Operating System.

## auto-install

Steps to use:

1. Copy over the hardware configuration of your choice. For example:

```shell
cd auto-install
cp hardware/beelink-s12-n100.nix auto-install/hardware-configuration.nix
```

2. Copy the `vars.install.nix` files to `vars.nix` and update it to use the *absolute path* to the `auto-install` directory. For example, replace `/etc/nixos` with `/home/YOUR_USER/repos/home-cloud-io/os/auto-install`.

```shell
cp vars.install.nix vars.nix
```

3. Compile the ISO:

```shell
nix-build
```

4. Flash the generated `.iso` file to a USB drive using a tool like [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://etcher.balena.io/).

5. Install the ISO to your hardware using the bootable USB.

6. It will take a while to install and will shutdown when it's finished.

7. Remove the USB and reboot your hardware.

8. Home Cloud will be installed and when it completes you can access the web dashboard at http://home-cloud.local


Special thanks to [Andrei Volt](https://gitlab.com/andreivolt/nixos-auto-install) for his initial work on this. We have adapted his effort for this use case.
