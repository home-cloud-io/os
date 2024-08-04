with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.3";
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
    hash = "sha256-hc3maLBJQvPENdCjbe3ion9/nXcCKh2jKCxtH5MbutA=";
  } + "/services/platform/daemon";
}
