# daemon

This is a simple Nix package that builds the Home Cloud daemon from the [core](https://github.com/home-cloud-io/core) repo. For now there isn't any automation to bundle this into the Home Cloud ISO so the process is:

1. Run `nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'` to build the binary
2. Copy the binary to the device: `scp result/bin/daemon admin@home-cloud.local:/home/admin`

And if you need to generate a new version, update the version in `default.nix`, replace the hashes with empty strings, and run the above build command a couple times to generate the hashes and paste them into `default.nix`. It's hacky but I'll work out a better flow later.
