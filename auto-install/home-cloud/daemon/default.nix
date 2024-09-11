with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.19";
  vendorHash = "sha256-LcLj7b4+D2QPuCALeIyA0+Za8Wh2WCbHxv6QHAESuU0=";

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
    hash = "sha256-nAeQs6NeBBZEZTHVKV2i7RebfaR3H2XtecIWEXoDh7E=";
  } + "/services/platform/daemon";
}
