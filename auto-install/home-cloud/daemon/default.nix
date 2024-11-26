with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.25";
  vendorHash = "sha256-2krAKDxOnTdSwrQWk4UnZvS8WLoclUMTVQ14O3Aap18=";

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
    hash = "sha256-ssoNn70szCYUXCeosn1v6cnKvayWAfUHc76ThqqiH1Q=";
  } + "/services/platform/daemon";
}
