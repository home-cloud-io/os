# os

This configuration creates an ISO that automatically installs Home Cloud on the primary disk of the machine it's plugged into (at boot of course).

Steps:

1. Copy the hardware configuration of your choice from the `hardware` directory up to this level: `cp hardware/generic.nix hardware-configuration.nix`
2. You may want to add your SSH public key to the `configuration.nix` under `openssh.authorizedKeys.keys`.
3. Then compile the ISO: `nix-build`
4. You can use Rufus to create a bootable USB with the ISO
5. And finally you can plug the USB into your machine, boot to it, and wait a while for it to install

NOTE: The install takes a while. If you want to monitor progress you can run the command `journalctl -fb -n100 -uinstall` from the terminal. You'll know it's completed when the machine turns itself off.
