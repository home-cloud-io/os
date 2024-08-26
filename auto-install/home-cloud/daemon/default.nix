with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.9";
  vendorHash = "sha256-lSe0P/nqCnRvP6nUZG5d9oXQ0Q+hKet1v0rhTrtapx4=";

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
    hash = "sha256-L6Y2hAsVHU6bYvYNsxpH5xIU6eBRzkLg9eoFZjJK4Y0=";
  } + "/services/platform/daemon";
}
