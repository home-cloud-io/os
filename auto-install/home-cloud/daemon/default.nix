with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.16";
  vendorHash = "sha256-LcLj7b4+D2QPuCALeIyA0+Za8Wh2WCbHxv6QHAESuU0=";

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
    hash = "sha256-kdEEwkFBDnN0o6iHho9qBBbZUXj3a47kxQrgSeC/Qz8=";
  } + "/services/platform/daemon";
}
