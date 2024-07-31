{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.1";
  vendorHash = "sha256-mjbsnnZPMV+x6ymBWgFK3eMO7bJKX/T4AfYRmFuZ4bE=";

  meta = with lib; {
    description = "Home Cloud Host Daemon";
    homepage = "https://github.com/home-cloud-io/core";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.jgkawell ];
  };

  src = fetchFromGitHub {
    owner = "home-cloud-io";
    repo = "core";
    rev = "services/platform/daemon/v${version}";
    hash = "sha256-6ahOgMRfWBBxrLDYdNZqhmdzB/0CqkGc4AIrUlf/JLs=";
  } + "/services/platform/daemon";
}
