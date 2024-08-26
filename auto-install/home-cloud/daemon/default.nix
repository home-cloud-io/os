with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.7";
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
    hash = "sha256-TM4rMos4/KMxQTnkB1/oL5vEYB6EQFi7vjVliORTEGw=";
  } + "/services/platform/daemon";
}
