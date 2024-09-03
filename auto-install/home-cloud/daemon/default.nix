with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.15";
  vendorHash = "sha256-R3PF1023EuADomKVp7p1Zg0KGL336XACf1xr7nZgM8M=";

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
    hash = "sha256-IUMLp7pEwBeq6CFFxcTeTvCkVQMsQyyfMbgm+IPCVeg=";
  } + "/services/platform/daemon";
}
