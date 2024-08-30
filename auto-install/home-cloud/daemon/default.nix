with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.10";
  vendorHash = "sha256-5pSbjCEkUdTdKT5/YzghQTn5lFxGTj5pWe20Umzx8F4=";

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
    hash = "sha256-xYibOxlj+zCLrqG+ZMYs2LCKvnf8APncpDJZqDZ5uK8=";
  } + "/services/platform/daemon";
}
