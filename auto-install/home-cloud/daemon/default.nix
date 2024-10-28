with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.24";
  vendorHash = "sha256-bcZgv77qIZrHT/0mmLAUFnIYknI5gsvC4l2m20BDVLE=";

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
    rev = "services/platform/daemon/${version}";
    hash = "sha256-8tzkBsDUVuZQB/ZgwXbSvyshR4dTYOnuTr4RHefu5Dg=";
  } + "/services/platform/daemon";
}
