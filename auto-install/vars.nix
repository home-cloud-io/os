{ lib, ... }:
with lib;
{
  options.vars = {
    root = mkOption {
      type = types.str;
      default = "/etc/nixos";
      description = "";
    };
  };
}