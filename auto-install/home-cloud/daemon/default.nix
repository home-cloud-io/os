with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.2";
  vendorHash = "sha256-sDsLme604ZjLTAQLiaHrX2OYfUiVIqOSuKOYlJ90/Js=";

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
    hash = "sha256-DL2Bm0me6Obc1v6hu+7gwPyGncWI3ts0Mie1/FTixgs=";
  } + "/services/platform/daemon";
}
