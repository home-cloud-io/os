{ lib, ... }:
with lib;
{
  options.vars = {
    hostname = mkOption {
      type = types.str;
      default = "home-cloud";
      description = "The hostname of the device.";
    };
  };
}