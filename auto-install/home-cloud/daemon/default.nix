with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.36";
  vendorHash = "sha256-zJOpyKCiju7j03yHaqauoQHMEGIsdq6KajZp/kQ/RmE=";

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
    hash = "sha256-wmfP+zez3k74HoSF/SK/DpZaM/5gsyJX22FoZFEoeAs=";
  } + "/services/platform/daemon";
}