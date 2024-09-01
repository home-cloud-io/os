with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.13";
  vendorHash = "sha256-efVZgYpVubSunXA0Plo7tt1YfQch9sLDvNSaE9t2+cM=";

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
    hash = "sha256-nzlJOZcm05RZ4geGiZVOPJOFBuNK67Hn3z3qLF2AN3U=";
  } + "/services/platform/daemon";
}
