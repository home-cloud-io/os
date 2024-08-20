with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.5";
  vendorHash = "sha256-l8oyfjDF0O4W5RNju5Ahkmp2MC/u3nzcjKURgYWmj1k=";

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
    hash = "sha256-44imk3kiy9+AnvvNZieKV/vxHrQ6Wy0K/WV3m6517UU=";
  } + "/services/platform/daemon";
}
