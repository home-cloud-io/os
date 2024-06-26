# os

The Home Cloud Operating System.

## auto-install

Steps to use:

1. Copy over the hardware configuration of your choice. For example:

```shell
cp auto-install/hardware/beelink-s12-n100.nix auto-install/hardware-configuration.nix
```

2. Compile the ISO:

```shell
cd auto-install
nix-build
```

3. Flash the generated `.iso` file to a USB drive using a tool like [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://etcher.balena.io/).

4. Install the ISO to your hardware using the bootable USB.


Special thanks to [Andrei Volt](https://gitlab.com/andreivolt/nixos-auto-install) for his initial work on this. We have adapted his effort for this use case.
