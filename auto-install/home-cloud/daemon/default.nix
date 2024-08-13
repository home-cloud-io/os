with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.4";
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
    hash = "sha256-WF3g8FXIVbjjAlTSh3S5rfAsXIyGl9m3FiOlBItfEUA=";
  } + "/services/platform/daemon";
}
